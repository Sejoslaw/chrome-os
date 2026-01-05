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
    
    # Build application-configured images - Fedora
    podman build -t fedora-toolbox-gui-brave -f ./chrome-os/Crostini/Podman/Containerfiles/GUI/Fedora-Toolbox-GUI-Brave/fedora-toolbox-gui-brave.containerfile .

    # Copy runners
    mkdir ~/podman-runner

    cp ./chrome-os/Crostini/Podman/Containerfiles/run-toolbox.sh ~/podman-runner/run-toolbox.sh
    cp ./chrome-os/Crostini/Podman/Containerfiles/GUI/Fedora-Toolbox-GUI-Brave/fedora-toolbox-gui-brave-persistent.run.sh ~/podman-runner/fedora-toolbox-gui-brave-persistent.run.sh

    # Make all runners executable
    chmod +x ~/podman-runner/*.sh
    
    # Prepare .bashrc file
    printf '

toolbox-init() { # toolbox-init <distro = arch | debian | fedora> <name>
    ~/podman-runner/run-toolbox.sh $1 $2
}

brave-run() {
    ~/podman-runner/fedora-toolbox-gui-brave-persistent.run.sh
}
' >> ~/.bashrc
fi
