FROM localhost/arch-toolbox-gui:latest

USER archuser

# Install yay
RUN git clone https://aur.archlinux.org/yay-bin.git && \
    cd yay-bin && \
    makepkg -si --noconfirm && \
    cd .. && rm -rf yay-bin

# Config must be finished as root
USER root

CMD ["/usr/bin/tmux"]