#!/bin/bash

DISTRO=$1
NAME=$2
VOLUME_NAME="$NAME-volume"

podman volume exists "$VOLUME_NAME" || podman volume create "$VOLUME_NAME"

podman run -it --rm \
  --name=$NAME \
  --hostname=$NAME \
  --userns keep-id \
  --cap-drop=all \
  --cap-add=chown \
  --cap-add=setuid \
  --cap-add=setgid \
  --cap-add=dac_override \
  --security-opt seccomp=unconfined \
  --device /dev/dri/card0:/dev/dri/card0 \
  --device /dev/dri/renderD128:/dev/dri/renderD128 \
  -e PULSE_SERVER=unix:/run/user/1000/pulse/native \
  -v $XDG_RUNTIME_DIR/wayland-0:$XDG_RUNTIME_DIR/wayland-0:ro \
  -v $XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse:ro \
  -v "$VOLUME_NAME":/home/${DISTRO}user:Z \
  --tmpfs /run/user/1000:mode=700,size=512M \
  --tmpfs /tmp:mode=1777,size=1G \
  --tmpfs /var/tmp:mode=1777,size=512M \
  ${DISTRO}-toolbox-gui:latest