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
    podman build -t arch-toolbox -f ./Podman/Containerfiles/Terminal/arch-toolbox.containerfile .
    podman build -t debian-toolbox -f ./Podman/Containerfiles/Terminal/debian-toolbox.containerfile .
    podman build -t fedora-toolbox -f ./Podman/Containerfiles/Terminal/fedora-toolbox.containerfile .

    # Build GUI-configured images
    sh ./Podman/Containerfiles/Fedora-Toolbox-GUI/fedora-toolbox-gui.build.sh
    
    # Build application-configured images
    sh ./Podman/Containerfiles/Brave-Disposable-Hardened/fedora-toolbox-gui-brave.build.sh
    sh ./Podman/Containerfiles/Fedora-Toolbox-GUI-xfce/fedora-toolbox-gui-xfce.build.sh
    
    cat <<EOF >> ~/.test

    alias update="sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y"

    fedora-disp() {
        podman run -it --rm \\
            --userns keep-id \\
            --ipc=host \\
            --cap-drop=all \\
            --cap-add={net_raw,audit_write,chown,setuid,setgid,dac_override} \\
            --security-opt label=disable \\
            --security-opt seccomp=unconfined \\
            --device /dev/dri/card0:/dev/dri/card0 \\
            --device /dev/dri/renderD128:/dev/dri/renderD128 \\
            -v /tmp/.X11-unix:/tmp/.X11-unix:ro \\
            -v $XDG_RUNTIME_DIR/wayland-0:$XDG_RUNTIME_DIR/wayland-0:ro \\
            -v $XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse:ro \\
            --tmpfs /run/user/1000:mode=700,size=512M \\
            --tmpfs /home/fedorauser:mode=755,size=10G \\
            fedora-toolbox-gui-xfce:latest
    }

    brave-disp() {
        podman run -it --rm \\
            --read-only \\
            --memory=4g \\
            --cpus=2 \\
            --userns keep-id \\
            --ipc=host \\
            --cap-drop=all \\
            --cap-add={net_raw,chown,setuid,setgid} \\
            --security-opt label=disable \\
            --security-opt seccomp=unconfined \\
            --security-opt no-new-privileges \\
            --device /dev/dri/card0:/dev/dri/card0 \\
            --device /dev/dri/renderD128:/dev/dri/renderD128 \\
            -v /tmp/.X11-unix:/tmp/.X11-unix:ro \\
            -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/run/user/1000/wayland-0:ro \\
            -v $XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse:ro \\
            -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket:ro \\
            --tmpfs /run/user/1000:mode=700,size=512M \\
            --tmpfs /home/fedorauser:mode=755,size=4G \\
            --tmpfs /tmp:mode=1777,size=1G \\
            --tmpfs /var/tmp:mode=1777,size=512M \\
            fedora-toolbox-gui-brave:latest
    }

    brave-persistent() {
        VOLUME_NAME="brave-persistent-volume"

        podman volume exists "$VOLUME_NAME" || podman volume create "$VOLUME_NAME"

        podman run -it --rm \\
            --read-only \\
            --memory=4g \\
            --cpus=2 \\
            --userns keep-id \\
            --ipc=host \\
            --cap-drop=all \\
            --cap-add={net_raw,chown,setuid,setgid} \\
            --security-opt label=disable \\
            --security-opt seccomp=unconfined \\
            --security-opt no-new-privileges \\
            --device /dev/dri/card0:/dev/dri/card0 \\
            --device /dev/dri/renderD128:/dev/dri/renderD128 \\
            -v /tmp/.X11-unix:/tmp/.X11-unix:ro \\
            -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/run/user/1000/wayland-0:ro \\
            -v $XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse:ro \\
            -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket:ro \\
            -v "$VOLUME_NAME":/home/fedorauser:Z \\
            --tmpfs /run/user/1000:mode=700,size=512M \\
            --tmpfs /tmp:mode=1777,size=1G \\
            --tmpfs /var/tmp:mode=1777,size=512M \\
            fedora-toolbox-gui-brave:latest
    }
    EOF
fi
