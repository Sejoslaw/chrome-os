FROM localhost/fedora-toolbox-gui:latest

USER root

# Install useful xfce components
RUN dnf -y install \
    thunar xfce4-terminal && \
    dnf clean all

CMD ["/usr/bin/tmux"]