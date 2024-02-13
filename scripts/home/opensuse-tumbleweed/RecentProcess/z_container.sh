#!/bin/bash

if ! checkwsl; then

    if [ -x "$(command -v podman)" ]; then
        systemctl --user enable --now podman.service
        systemctl --user enable --now podman.socket
    fi

    if [ -x "$(command -v distrobox)" ] && [ -x "$(command -v podman)" ]; then
        mkdir -p $HomePWD/distrobox
        echo -e "[Desktop Entry]\nIcon=package-upgrade-auto" | tee $HomePWD/distrobox/.directory
        mkdir -p $HomePWD/distrobox/home
        mkdir -p $HomePWD/distrobox/home/osusetw
        mkdir -p $HomePWD/distrobox/home/fedora
        mkdir -p $HomePWD/distrobox/home/debian

    #     podman build --format docker --build-arg enable_account=1 --build-arg distroboxPackage=0 -t herrwinfried/dev_env:distrobox_osusetw . -f $ScriptFolder/docker/dockerfile/tw_developer.dockerfile
    #    distrobox-create -i herrwinfried/dev_env:distrobox_osusetw -n dev_suse --nvidia --init -H $HomePWD/distrobox/home/osusetw --pre-init-hooks 'sudo zypper -q -n in -y -l cmake-full' -ap 'systemd xdg-user-dirs dos2unix' --additional-flags "--env DX_OS=opensuse-tumbleweed"
         distrobox-create -i fedora:latest -n fedora --nvidia --init -H $HomePWD/distrobox/home/fedora -ap 'xdg-user-dirs systemd dos2unix' --additional-flags "--env DX_OS=opensuse-tumbleweed"
        distrobox-create -i debian:latest -n debian --nvidia --init -H $HomePWD/distrobox/home/debian -ap 'xdg-user-dirs systemd libpam-systemd dos2unix' --additional-flags "--env DX_OS=opensuse-tumbleweed"

    fi
fi
    if [ -f "$HomePWD/bin/docker" ] || checkwsl && [ -x "$(command -v docker)" ]; then

        if [ -f "$HomePWD/bin/docker" ]; then
            systemctl --user enable --now docker.service
            systemctl --user enable --now docker.socket
            export DOCKER_HOST=unix:///run/user/1000/docker.sock
        fi

        NowFinder=$(pwd)
        cd $ScriptFolder/docker/dockerfile
        # docker build -t herrwinfried/dev_env:opensuse_tumbleweed . -f ./tw_developer.dockerfile
        mkdir -p $XDG_PUBLICSHARE_DIR/dockerHost
        chgrp wheel $XDG_PUBLICSHARE_DIR/dockerHost
        ln -s $XDG_PUBLICSHARE_DIR/dockerHost ~/dockerHost
        # docker create -it --name tw_development -p 3256:22 -v $XDG_PUBLICSHARE_DIR/dockerHost:/home/host:rw herrwinfried/dev_env:opensuse_tumbleweed
        cd $NowFinder
        unset NowFinder
    fi
