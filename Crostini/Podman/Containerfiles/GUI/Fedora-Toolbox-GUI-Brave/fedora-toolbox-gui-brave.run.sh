#!/bin/bash

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
  --security-opt seccomp=unconfined \
  --security-opt no-new-privileges \
  --device /dev/dri/card0:/dev/dri/card0 \
  --device /dev/dri/renderD128:/dev/dri/renderD128 \
  -e PULSE_SERVER=unix:/run/user/1000/pulse/native \
  -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/run/user/1000/wayland-0:ro \
  -v $XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse:ro \
  --tmpfs /run/user/1000:mode=700,size=512M \
  --tmpfs /home/fedorauser:mode=755,size=4G \
  --tmpfs /tmp:mode=1777,size=1G \
  --tmpfs /var/tmp:mode=1777,size=512M \
  fedora-toolbox-gui-brave:latest