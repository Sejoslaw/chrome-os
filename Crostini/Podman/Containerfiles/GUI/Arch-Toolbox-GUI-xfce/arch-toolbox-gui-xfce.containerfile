FROM localhost/arch-toolbox-gui:latest

USER root

# Install useful xfce components
RUN pacman -S --noconfirm \
    thunar xfce4-terminal

CMD ["/usr/bin/tmux"]