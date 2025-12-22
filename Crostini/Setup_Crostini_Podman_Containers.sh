#!/bin/sh

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##               Setting up Podman containers...              ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

echo ""
read -p "## Setup Podman containers? (may take some time) (yes/empty)" _setupPodmanContainers;

if [ "$_setupPodmanContainers" != "" ]
then
    # Build Core images
    podman build -t arch-toolbox -f ./chrome-os/Crostini/Podman/Containerfiles/Terminal/arch-toolbox.containerfile .
    podman build -t debian-toolbox -f ./chrome-os/Crostini/Podman/Containerfiles/Terminal/debian-toolbox.containerfile .
    podman build -t fedora-toolbox -f ./chrome-os/Crostini/Podman/Containerfiles/Terminal/fedora-toolbox.containerfile .

    # Build GUI-configured images
    podman build -t arch-toolbox-gui -f ./chrome-os/Crostini/Podman/Containerfiles/GUI/Arch-Toolbox-GUI/arch-toolbox-gui.containerfile .
    podman build -t debian-toolbox-gui -f ./chrome-os/Crostini/Podman/Containerfiles/GUI/Debian-Toolbox-GUI/debian-toolbox-gui.containerfile .
    podman build -t fedora-toolbox-gui -f ./chrome-os/Crostini/Podman/Containerfiles/GUI/Fedora-Toolbox-GUI/fedora-toolbox-gui.containerfile .
    
    # Build application-configured images - Arch
    podman build -t arch-toolbox-gui-xfce -f ./chrome-os/Crostini/Podman/Containerfiles/GUI/Arch-Toolbox-GUI-xfce/arch-toolbox-gui-xfce.containerfile .
    podman build -t arch-toolbox-gui-yay -f ./chrome-os/Crostini/Podman/Containerfiles/GUI/Arch-Toolbox-GUI-yay/arch-toolbox-gui-yay.containerfile .

    # Build application-configured images - Debian
    podman build -t debian-toolbox-gui-xfce -f ./chrome-os/Crostini/Podman/Containerfiles/GUI/Debian-Toolbox-GUI-xfce/debian-toolbox-gui-xfce.containerfile .
    
    # Build application-configured images - Fedora
    podman build -t fedora-toolbox-gui-brave -f ./chrome-os/Crostini/Podman/Containerfiles/GUI/Fedora-Toolbox-GUI-Brave/fedora-toolbox-gui-brave.containerfile .
    podman build -t fedora-toolbox-gui-xfce -f ./chrome-os/Crostini/Podman/Containerfiles/GUI/Fedora-Toolbox-GUI-xfce/fedora-toolbox-gui-xfce.containerfile .

    # Copy runners
    mkdir ~/podman-runner

    cp ./chrome-os/Crostini/Podman/Containerfiles/GUI/Arch-Toolbox-GUI/arch-toolbox-gui.run.sh ~/podman-runner/arch-toolbox-gui.run.sh
    cp ./chrome-os/Crostini/Podman/Containerfiles/GUI/Arch-Toolbox-GUI-xfce/arch-toolbox-gui-xfce.run.sh ~/podman-runner/arch-toolbox-gui-xfce.run.sh
    cp ./chrome-os/Crostini/Podman/Containerfiles/GUI/Arch-Toolbox-GUI-yay/arch-toolbox-gui-yay.run.sh ~/podman-runner/arch-toolbox-gui-yay.run.sh

    cp ./chrome-os/Crostini/Podman/Containerfiles/GUI/Debian-Toolbox-GUI/debian-toolbox-gui.run.sh ~/podman-runner/debian-toolbox-gui.run.sh
    cp ./chrome-os/Crostini/Podman/Containerfiles/GUI/Debian-Toolbox-GUI-xfce/debian-toolbox-gui-xfce.run.sh ~/podman-runner/debian-toolbox-gui-xfce.run.sh

    cp ./chrome-os/Crostini/Podman/Containerfiles/GUI/Fedora-Toolbox-GUI/fedora-toolbox-gui.run.sh ~/podman-runner/fedora-toolbox-gui.run.sh
    cp ./chrome-os/Crostini/Podman/Containerfiles/GUI/Fedora-Toolbox-GUI-xfce/fedora-toolbox-gui-xfce.run.sh ~/podman-runner/fedora-toolbox-gui-xfce.run.sh

    cp ./chrome-os/Crostini/Podman/Containerfiles/GUI/Fedora-Toolbox-GUI-Brave/fedora-toolbox-gui-brave.run.sh ~/podman-runner/fedora-toolbox-gui-brave.run.sh
    cp ./chrome-os/Crostini/Podman/Containerfiles/GUI/Fedora-Toolbox-GUI-Brave/fedora-toolbox-gui-brave-persistent.run.sh ~/podman-runner/fedora-toolbox-gui-brave-persistent.run.sh

    # Make all runners executable
    chmod +x ~/podman-runner/*.sh
    
    # Prepare .bashrc file
    printf '

alias update="sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y"

disp-arch-toolbox() {
    podman run --rm -it arch-toolbox:latest
}

disp-debian-toolbox() {
    podman run --rm -it debian-toolbox:latest
}

disp-fedora-toolbox() {
    podman run --rm -it fedora-toolbox:latest
}

disp-arch-gui() {
    ~/podman-runner/arch-toolbox-gui.run.sh
}

disp-arch-gui-xfce() {
    ~/podman-runner/arch-toolbox-gui-xfce.run.sh
}

disp-arch-gui-yay() {
    ~/podman-runner/arch-toolbox-gui-yay.run.sh
}

disp-debian-gui() {
    ~/podman-runner/debian-toolbox-gui.run.sh
}

disp-debian-gui-xfce() {
    ~/podman-runner/debian-toolbox-gui-xfce.run.sh
}

disp-fedora-gui() {
    ~/podman-runner/fedora-toolbox-gui.run.sh
}

disp-fedora-gui-xfce() {
    ~/podman-runner/fedora-toolbox-gui-xfce.run.sh
}

disp-fedora-gui-brave() {
    ~/podman-runner/fedora-toolbox-gui-brave.run.sh
}

disp-fedora-gui-brave-persistent-volume() {
    ~/podman-runner/fedora-toolbox-gui-brave-persistent.run.sh
}
' >> ~/.bashrc
fi
