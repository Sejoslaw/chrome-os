FROM localhost/debian-toolbox:latest

USER root

# Install Video + Audio
RUN apt install -y \
    libgl1-mesa-dri libvulkan1 mesa-vulkan-drivers \
    libx11-6 libwayland-client0 libxcomposite1 libxkbcommon0 \
    adwaita-icon-theme fonts-noto-core \
    libpipewire-0.3-modules libpulse0 \
    dbus-x11

# Prepare entrypoint script
ENV ENTRYPOINT_PATH=/usr/local/bin/entrypoint.sh
RUN echo '#!/bin/bash' > $ENTRYPOINT_PATH && \       
    echo 'chown -R debianuser:debianuser /home/debianuser /run/user/1000' >> $ENTRYPOINT_PATH && \
    echo 'chmod 755 /home/debianuser' >> $ENTRYPOINT_PATH && \
    echo 'chmod 700 /run/user/1000' >> $ENTRYPOINT_PATH && \
    echo 'find /run/user/1000 -type s -exec chmod 666 {} + 2>/dev/null' >> $ENTRYPOINT_PATH && \
    echo 'exec runuser -u debianuser -- dbus-run-session -- "$@"' >> $ENTRYPOINT_PATH

RUN chmod +x $ENTRYPOINT_PATH       

ENV DISPLAY=:0 \
    WAYLAND_DISPLAY=wayland-0 \
    XDG_RUNTIME_DIR=/run/user/1000 \
    GTK_THEME=Adwaita:dark

ENTRYPOINT ["/bin/bash", "-c", "${ENTRYPOINT_PATH} \"$@\"", "--"]

CMD ["/usr/bin/tmux"]