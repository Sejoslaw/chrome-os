FROM registry.fedoraproject.org/fedora:latest

RUN dnf -y update && dnf -y install \
    tmux @development-tools \
    vim git less \
    python3 python3-pip python3-virtualenv \
    sudo \
    bash-completion

RUN dnf -y install \
    mesa-dri-drivers mesa-vulkan-drivers \
    libX11 wayland-devel libXcomposite libxkbcommon \
    adwaita-icon-theme google-noto-sans-fonts \
    pipewire-libs pulseaudio-libs

RUN dnf -y install \
    thunar xfce4-terminal

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

RUN sudo dnf -y update

RUN rm -f ~/.bashrc

RUN echo 'alias ls="ls --color=auto"' >> ~/.bashrc && \
    echo 'alias grep="grep --color=auto"' >> ~/.bashrc && \
    echo "alias py='source ~/.venv/bin/activate'" >> ~/.bashrc && \
    echo 'parse_git_branch() { local branch=$(git branch --show-current 2>/dev/null); [ -n "$branch" ] && echo " > ($branch)"; }' >> ~/.bashrc && \
    echo 'export PS1="\[\e[01;35m\][podman > \h] \[\e[01;32m\]\u\[\e[00m\] > \[\e[01;34m\]\w\[\e[01;31m\]\$(parse_git_branch)\[\e[00m\] \$ "' >> ~/.bashrc && \
    echo '[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion' >> ~/.bashrc

RUN echo "set -g default-shell /bin/bash" >> ~/.tmux.conf && \
    echo "set -g default-command /bin/bash" >> ~/.tmux.conf

RUN git config --global user.email "fedorauser@container.local" && \
    git config --global user.name "Fedora User" && \
    git config --global init.defaultBranch main

RUN python3 -m venv ~/.venv

ENV TERM=xterm-256color
ENV DISPLAY=:0
ENV WAYLAND_DISPLAY=wayland-0
ENV XDG_RUNTIME_DIR=/run/user/1000
ENV GTK_THEME=Adwaita:dark

USER root
ENTRYPOINT ["/bin/bash", "-c", "${ENTRYPOINT_PATH} \"$@\"", "--"]

CMD ["/usr/bin/tmux"]