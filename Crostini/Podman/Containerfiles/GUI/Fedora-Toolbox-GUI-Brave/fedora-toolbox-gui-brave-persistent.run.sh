#!/bin/bash

VOLUME_NAME="brave-persistent-volume"

podman volume exists "$VOLUME_NAME" || podman volume create "$VOLUME_NAME"

podman run -it --rm \
  --read-only \
  --memory=4g \
  --cpus=2 \
  --userns keep-id \
  --cap-drop=all \
  --cap-add=net_raw \
  --cap-add=chown \
  --cap-add=setuid \
  --cap-add=setgid \
  --security-opt label=disable \
  --security-opt seccomp=unconfined \
  --security-opt no-new-privileges \
  --device /dev/dri/card0:/dev/dri/card0 \
  --device /dev/dri/renderD128:/dev/dri/renderD128 \
  -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/run/user/1000/wayland-0:ro \
  -v $XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse:ro \
  -v "$VOLUME_NAME":/home/fedorauser:Z \
  --tmpfs /run/user/1000:mode=700,size=512M \
  --tmpfs /tmp:mode=1777,size=1G \
  --tmpfs /var/tmp:mode=1777,size=512M \
  fedora-toolbox-gui-brave:latest