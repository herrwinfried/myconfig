#!/bin/bash

if ! checkwsl; then

    if [ -x "$(command -v podman)" ]; then
        systemctl --user enable --now podman.service
        systemctl --user enable --now podman.socket
    fi

    if [ -x "$(command -v distrobox)" ] && [ -x "$(command -v podman)" ]; then
        mkdir -p $HomePWD/distrobox
        mkdir -p $HomePWD/distrobox/fedora
        distrobox-create -i fedora:latest -n Fedora-dx -H $HomePWD/distrobox/fedora --pre-init-hooks 'dnf update -y && dnf install -y @core && dnf install -y sudo nano wget curl git'

        mkdir -p $HomePWD/distrobox/debian
        distrobox-create -i debian:latest -n Debian-dx -H $HomePWD/distrobox/debian --pre-init-hooks 'apt update && apt upgrade -y && apt install -y libasound2 sudo nano wget curl git && apt install -f -y'

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
        docker build -t herrwinfried/dev_env:opensuse_tumbleweed . -f ./tw_developer.dockerfile 
        mkdir -p ~/.config/dockerHost
        chgrp wheel ~/.config/dockerHost
        ln -s ~/.config/dockerHost ~/dockerHost
        docker create -it --name tw_development -p 3256:22 -v ~/.config/dockerHost:/home/host:rw herrwinfried/dev_env:opensuse_tumbleweed
        cd $NowFinder
        unset NowFinder
    fi
