FROM docker.io/library/debian:latest     

# Install Core utilities
RUN apt update && apt full-upgrade -y && apt install -y \
    tmux build-essential \
    vim git less \
    python3 python3-pip python3-venv \
    sudo bash-completion     

# Create dedicated user
RUN useradd -m -s /bin/bash debianuser && usermod -aG sudo debianuser && echo "debianuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER debianuser
WORKDIR /home/debianuser

RUN sudo apt update

RUN rm -f ~/.bashrc

# Create customized prompt
RUN echo 'alias ls="ls --color=auto"' >> ~/.bashrc && \
    echo 'alias grep="grep --color=auto"' >> ~/.bashrc && \
    echo "alias py='source ~/.venv/bin/activate'" >> ~/.bashrc && \
    echo 'parse_git_branch() { local branch=$(git branch --show-current 2>/dev/null); [ -n "$branch" ] && echo " > ($branch)"; }' >> ~/.bashrc && \
    echo 'export PS1="\[\e[01;35m\][podman > \h] \[\e[01;32m\]\u\[\e[00m\] > \[\e[01;34m\]\w\[\e[01;31m\]\$(parse_git_branch)\[\e[00m\] \$ "' >> ~/.bashrc && \
    echo '[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion' >> ~/.bashrc

RUN echo "set -g default-shell /bin/bash" >> ~/.tmux.conf && \
    echo "set -g default-command /bin/bash" >> ~/.tmux.conf

# Setup default git user
RUN git config --global user.email "debianuser@container.local" && \
    git config --global user.name "Debian User" && \
    git config --global init.defaultBranch main

RUN python3 -m venv ~/.venv

ENV TERM=xterm-256color

CMD ["/usr/bin/tmux"]