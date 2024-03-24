#!/bin/bash

if [ -x "$(command -v podman)" ]; then
        systemctl --user enable --now podman.service
        systemctl --user enable --now podman.socket
fi

if [ -x "$(command -v distrobox)" ] && [ -x "$(command -v podman)" ]; then
    mkdir -p $USERHOME/distrobox
    create_desktop_entry $USERHOME/distrobox package-upgrade-auto
    mkdir -p $USERHOME/distrobox/home/{fedora,debian}
    distrobox-create -i fedora:latest -n fedora --nvidia --init -H $USERHOME/distrobox/home/fedora -ap 'xdg-user-dirs systemd dos2unix' --additional-flags "--env DX_OS=opensuse-tumbleweed"
    distrobox-create -i debian:latest -n debian --nvidia --init -H $USERHOME/distrobox/home/debian -ap 'xdg-user-dirs systemd libpam-systemd dos2unix' --additional-flags "--env DX_OS=opensuse-tumbleweed"
fi

    if [ -f "$USERHOME/bin/docker" ] && [ -x "$(command -v docker)" ]; then

        if [ -f "$USERHOME/bin/docker" ]; then
            systemctl --user enable --now docker.service
            systemctl --user enable --now docker.socket
            export DOCKER_HOST=unix:///run/user/1000/docker.sock
        else
            systemctl enable --now docker.service
            systemctl enable --now docker.socket
        fi
    fi