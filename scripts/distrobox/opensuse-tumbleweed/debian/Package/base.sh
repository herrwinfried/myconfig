#!/bin/bash

Package_a="hwinfo screenfetch neofetch htop git git-lfs curl wget"
Package_a+=" bash zsh bash-completion fish lsb-release e2fsprogs nano"
Package_a+=" lzip unrar-free unzip default-jre openssh-server xdg-user-dirs"

Package_b="breeze"

SUDO $Package $PackageInstall $Package_a
SUDO $Package $PackageInstall -f

SUDO $Package $PackageInstall $Package_b
