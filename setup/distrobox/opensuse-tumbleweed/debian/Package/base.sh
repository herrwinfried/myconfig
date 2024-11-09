#!/bin/bash

Base="hwinfo screenfetch neofetch htop git git-lfs curl wget"
Base+=" bash zsh bash-completion fish lsb-release e2fsprogs nano"
Base+=" lzip unrar-free unzip default-jre openssh-server xdg-user-dirs"

BaseTheme="breeze"

BasePackageInstall "$Base"
SUDO $Package $PackageInstall -f
BasePackageInstall "$BaseTheme"

