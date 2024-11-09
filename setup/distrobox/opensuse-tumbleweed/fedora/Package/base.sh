#!/bin/bash

Base="hwinfo screenfetch neofetch htop git git-lfs curl wget"
Base+=" bash zsh bash-completion fish redhat-lsb-core e2fsprogs nano"
Base+=" lzip unrar unzip java-latest-openjdk openssh-server cracklib-dicts xdg-user-dirs"

BaseTheme="plasma-breeze"

BasePackageInstall "$Base"
BasePackageInstall "$BaseTheme"

