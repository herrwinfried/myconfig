#!/bin/bash

if ! checkwsl; then

    if [ -x "$(command -v podman)" ]; then
        systemctl --user enable --now podman.service
        systemctl --user enable --now podman.socket
    fi

    if [ -x "$(command -v distrobox)" ] && [ -x "$(command -v podman)" ]; then
        
        mkdir -p $HomePWD/distrobox
        mkdir -p $HomePWD/distrobox/debian
        distrobox-create -i debian:latest -n Debian-dx -H $HomePWD/distrobox/debian --pre-init-hooks 'apt update && apt upgrade -y && apt install -y libasound2 && sudo apt install -f -y'
        

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
        
        docker build -t herrwinfried/dev_env:fedora38 . -f ./fedora_developer.dockerfile
        
        mkdir -p ~/.config/dockerHost
        ln -s ~/.config/dockerHost ~/dockerHost
        docker create -it --name fedora_development -v ~/.config/dockerHost:/home/host:rw herrwinfried/dev_env:fedora38
        cd $NowFinder
        unset NowFinder
    fi
