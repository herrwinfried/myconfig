#!/bin/bash

function RepoFunc {
    SUDO sh -c "echo '$1' >> /etc/apt/sources.list.d/my-debian.list"
}
SUDO $Package $PackageInstall software-properties-common
SUDO apt-add-repository -y non-free
SUDO apt-add-repository -y non-free-firmware

#POWERSHELL
curl https://packages.microsoft.com/keys/microsoft.asc | SUDO gpg --yes --dearmor --output /usr/share/keyrings/microsoft.gpg
SUDO sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list'


