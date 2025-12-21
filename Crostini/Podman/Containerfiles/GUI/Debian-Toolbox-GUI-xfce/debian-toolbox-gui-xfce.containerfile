FROM localhost/debian-toolbox-gui:latest

USER root

# Install useful xfce components
RUN apt install -y \
    thunar xfce4-terminal

CMD ["/usr/bin/tmux"]