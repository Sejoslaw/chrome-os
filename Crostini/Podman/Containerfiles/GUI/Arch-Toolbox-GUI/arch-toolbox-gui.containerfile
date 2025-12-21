FROM localhost/arch-toolbox:latest

USER root

# Install Video + Audio
RUN pacman -S --noconfirm \
    mesa vulkan-intel \
    libx11 wayland libxcomposite libxkbcommon \
    adwaita-icon-theme noto-fonts \
    pipewire libpulse \
    dbus

# Prepare entrypoint script
ENV ENTRYPOINT_PATH=/usr/local/bin/entrypoint.sh
RUN echo '#!/bin/bash' > $ENTRYPOINT_PATH && \       
    echo 'chown -R archuser:archuser /home/archuser /run/user/1000' >> $ENTRYPOINT_PATH && \
    echo 'chmod 755 /home/archuser' >> $ENTRYPOINT_PATH && \
    echo 'chmod 700 /run/user/1000' >> $ENTRYPOINT_PATH && \
    echo 'find /run/user/1000 -type s -exec chmod 666 {} + 2>/dev/null' >> $ENTRYPOINT_PATH && \
    echo 'exec runuser -u archuser -- dbus-run-session -- "$@"' >> $ENTRYPOINT_PATH

RUN chmod +x $ENTRYPOINT_PATH       

ENV DISPLAY=:0 \
    WAYLAND_DISPLAY=wayland-0 \
    XDG_RUNTIME_DIR=/run/user/1000 \
    GTK_THEME=Adwaita:dark

ENTRYPOINT ["/bin/bash", "-c", "${ENTRYPOINT_PATH} \"$@\"", "--"]

CMD ["/usr/bin/tmux"]