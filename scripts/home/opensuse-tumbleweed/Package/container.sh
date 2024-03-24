#!/bin/bash

if ! checkwsl; then

Package_a="docker docker-compose podman distrobox"
Package_a_Flatpak="flathub io.podman_desktop.PodmanDesktop"

SUDO $Package $PackageInstall $Package_a
SUDO $FlatpakPackage $FlatpakPackageInstall $Package_a_Flatpak
    
SUDO usermod -G -a docker $USERNAME
        ######### DOCKER ROOTLESS ##############################
/usr/bin/dockerd-rootless-setuptool.sh install

fi