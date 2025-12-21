# Hardened image for secure web browsing using Brave Browser
FROM registry.fedoraproject.org/fedora:latest

# Install Core packages
RUN dnf -y update && dnf -y install util-linux

# Install Video + Audio
RUN dnf -y install \
    mesa-dri-drivers mesa-vulkan-drivers \
    libX11 wayland-devel libXcomposite libxkbcommon \
    adwaita-icon-theme google-noto-sans-fonts \
    pipewire-libs pulseaudio-libs

# Install Brave Browser
RUN dnf -y install dnf-plugins-core && \
    dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo && \
    dnf -y install brave-browser

RUN dnf clean all

RUN useradd -u 1000 -m -G wheel fedorauser && echo "fedorauser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV ENTRYPOINT_PATH=/usr/local/bin/entrypoint.sh
RUN echo '#!/bin/bash' > $ENTRYPOINT_PATH && \       
    echo 'chown -R fedorauser:fedorauser /home/fedorauser' >> $ENTRYPOINT_PATH && \
    echo 'chown -R fedorauser:fedorauser /run/user/1000' >> $ENTRYPOINT_PATH && \
    echo 'chmod 755 /home/fedorauser' >> $ENTRYPOINT_PATH && \
    echo 'chmod 700 /run/user/1000' >> $ENTRYPOINT_PATH && \
    echo 'find /run/user/1000 -type s -exec chmod 666 {} + 2>/dev/null' >> $ENTRYPOINT_PATH && \
    echo 'exec runuser -u fedorauser -- "$@"' >> $ENTRYPOINT_PATH     

RUN chmod +x $ENTRYPOINT_PATH

USER fedorauser
WORKDIR /home/fedorauser

ENV DISPLAY=:0
ENV WAYLAND_DISPLAY=wayland-0
ENV XDG_RUNTIME_DIR=/run/user/1000
ENV GTK_THEME=Adwaita:dark
ENV OZONE_PLATFORM=wayland

USER root
ENTRYPOINT ["/bin/bash", "-c", "${ENTRYPOINT_PATH} \"$@\"", "--"]

CMD ["brave-browser", "--ozone-platform=wayland", "--enable-features=UseOzonePlatform"]