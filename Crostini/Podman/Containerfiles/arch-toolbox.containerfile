FROM docker.io/library/archlinux:latest

RUN pacman-key --init && pacman-key --populate archlinux && pacman -Syyuuu --noconfirm

RUN pacman -S --noconfirm \
        tmux \
        base-devel \
        vim \
        git less \
        python python-pip python-virtualenv \
        sudo \
        bash-completion words 

RUN useradd -m -G wheel archuser && echo "archuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER archuser
WORKDIR /home/archuser

RUN rm ~/.bashrc

RUN echo 'alias ls="ls --color=auto"' >> ~/.bashrc && \
        echo 'alias grep="grep --color=auto"' >> ~/.bashrc && \
        echo "alias py='source ~/.venv/bin/activate'" >> ~/.bashrc && \
        echo 'parse_git_branch() { local branch=$(git branch --show-current 2>/dev/null); [ -n "$branch" ] && echo " ➜  ($branch)"; }' >> ~/.bashrc && \
        echo 'export PS1="\[\e[01;35m\][podman ➜  \h] \[\e[01;32m\]\u\[\e[00m\] ➜  \[\e[01;34m\]\w\[\e[01;31m\]\$(parse_git_branch)\[\e[00m\] \$ "' >> ~/.bashrc && \
        echo '[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion' >> ~/.bashrc

RUN echo "set -g default-shell /bin/bash" >> ~/.tmux.conf && \
    echo "set -g default-command /bin/bash" >> ~/.tmux.conf

RUN git config --global user.email "archuser@container.local" && \
    git config --global user.name "Arch User" && \
    git config --global init.defaultBranch main

RUN python -m venv ~/.venv

ENV TERM=xterm-256color

CMD ["/usr/bin/tmux"]