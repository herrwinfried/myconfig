#!/bin/bash

if [ -x "$(command -v podman)" ]; then
    systemctl --user enable --now podman.service
    systemctl --user enable --now podman.socket
fi

if [ -x "$(command -v distrobox)" ] && [ -x "$(command -v podman)" ]; then
    mkdir -p $USERHOME/distrobox
    CreateDesktopEntry $USERHOME/distrobox package-upgrade-auto
    mkdir -p $USERHOME/distrobox/home/debian
    distrobox-create -i debian:latest -n debian --nvidia --init -H $USERHOME/distrobox/home/debian -ap 'xdg-user-dirs systemd libpam-systemd dos2unix' --additional-flags "--env DX_OS=fedora"
fi

    if [ -f "/usr/bin/docker" ] && [ -x "$(command -v docker)" ]; then
        systemctl --user enable --now docker.service
        systemctl --user enable --now docker.socket
        export DOCKER_HOST=unix:///run/user/1000/docker.sock
    fi