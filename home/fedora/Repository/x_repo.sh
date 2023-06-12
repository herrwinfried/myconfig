#!/bin/bash

function rpmfusion {
    sudo $Package $PackageInstall https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
}

function bravebrowser {
    sudo $Package $PackageInstall dnf-plugins-core
    sudo $Package config-manager -y --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
}

function mongodbrepo {
    sudo rpm --import https://www.mongodb.org/static/pgp/server-6.0.asc
    sudo $Package config-manager -y --set-name MongoDB --add-repo https://repo.mongodb.org/yum/redhat/6/mongodb-org/6.0/x86_64/
}
function powershell {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
}

function vscode {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
}

function asuscommunity {
    sudo $Package copr enable -y lukenukem/asus-linux
}

function megaSYNCrepo {
    sudo rpm --import https://mega.nz/linux/repo/openSUSE_Tumbleweed/repodata/repomd.xml.key
    sudo $Package config-manager -y --set-disabled --set-name MEGAsync --add-repo https://mega.nz/linux/repo/Fedora_38
}

function chromerepo {
    sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub
    sudo $Package config-manager -y --set-disabled --set-name Google-Chrome --add-repo http://dl.google.com/linux/chrome/rpm/stable/x86_64
}

function edgerepo {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo $Package config-manager -y --set-name microsoft-edge --add-repo https://packages.microsoft.com/yumrepos/edge
}

rpmfusion
asuscommunity
bravebrowser
mongodbrepo
vscode
powershell

megaSYNCrepo
chromerepo
edgerepo

sudo $Package $PackageRefresh
sudo $Package $PackageUpdate
