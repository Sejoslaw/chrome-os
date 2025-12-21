#!/bin/bash

podman run -it --rm \
  --userns keep-id \
  --cap-drop=all \
  --cap-add=net_raw \
  --cap-add=audit_write \
  --cap-add=chown \
  --cap-add=setuid \
  --cap-add=setgid \
  --cap-add=dac_override \
  --security-opt label=disable \
  --security-opt seccomp=unconfined \
  --device /dev/dri/card0:/dev/dri/card0 \
  --device /dev/dri/renderD128:/dev/dri/renderD128 \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v $XDG_RUNTIME_DIR/wayland-0:$XDG_RUNTIME_DIR/wayland-0:ro \
  -v $XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse:ro \
  --tmpfs /run/user/1000:mode=700,size=512M \
  --tmpfs /home/archuser:mode=755,size=10G \
  arch-toolbox-gui-xfce:latest