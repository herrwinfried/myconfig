#!/bin/bash

function nvidiarepo {
    sudo $Package addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
}

function packmanrepo {
    sudo $Package ar -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/ packman-essentials
    #sudo $Package addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman
    sudo $Package $PackageRefresh
    sudo $Package $PackageUpdate --from packman-essentials --allow-vendor-change
    #sudo $Package $PackageUpdate --from packman --allow-vendor-change
}

function asuscommunity {
    sudo $Package ar --priority 50 -d https://download.opensuse.org/repositories/home:/luke_nukem:/asus/openSUSE_Tumbleweed/ asus-linux
    sudo rpm --import https://download.copr.fedorainfracloud.org/results/lukenukem/asus-linux/pubkey.gpg

    echo -e "
[asus-linux-FEDORA]
name=Asus Linux (Fedora 38)
enabled=1
autorefresh=1
baseurl=https://download.copr.fedorainfracloud.org/results/lukenukem/asus-linux/fedora-38-x86_64/
type=rpm-md
priority=50
keeppackages=0
gpgkey=https://download.copr.fedorainfracloud.org/results/lukenukem/asus-linux/pubkey.gpg
" | sudo tee /etc/zypp/repos.d/asus-linux-fedora.repo
}

function bravebrowser {
    sudo $Package $PackageInstall curl
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo $Package addrepo --refresh https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
}

function anydeskrepo {
    echo -e "
[anydesk]
name=AnyDesk OpenSUSE - stable
baseurl=http://rpm.anydesk.com/opensuse/$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
" | sudo tee /etc/zypp/repos.d/AnyDesk-OpenSUSE.repo
}

function teamviewerrepo {
    echo -e "
[teamviewer]
name=TeamViewer - $basearch
enabled=1
autorefresh=0
baseurl=https://linux.teamviewer.com/yum/stable/main/binary-$basearch/
type=rpm-md
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://linux.teamviewer.com/pubkey/currentkey.asc
keeppackages=0
" | sudo tee /etc/zypp/repos.d/teamviewer.repo
}

function mongodbrepo {
    sudo rpm --import https://www.mongodb.org/static/pgp/server-6.0.asc
    sudo $Package addrepo --gpgcheck "https://repo.mongodb.org/zypper/suse/15/mongodb-org/6.0/x86_64/" mongodb
}

function microsoft {
    sudo $Package $PackageInstall libicu
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    wget https://packages.microsoft.com/config/opensuse/15/prod.repo
    sudo mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
    sudo chown root:root /etc/zypp/repos.d/microsoft-prod.repo
}


function vscode {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
}

function snaprepo {
    sudo $Package addrepo -d https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
}

function megaSYNCrepo {
    sudo rpm --import https://mega.nz/linux/repo/openSUSE_Tumbleweed/repodata/repomd.xml.key
    sudo $Package addrepo -d https://mega.nz/linux/repo/openSUSE_Tumbleweed/ MEGAsync
}

function chromerepo {
    sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub
    sudo $Package addrepo -d http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
}

function edgerepo {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo $Package addrepo https://packages.microsoft.com/yumrepos/edge microsoft-edge
}

nvidiarepo
packmanrepo
asuscommunity
bravebrowser
anydeskrepo
teamviewerrepo
mongodbrepo
microsoft

vscode

snaprepo

megaSYNCrepo

chromerepo
edgerepo

sudo $Package $PackageRefresh
sudo $Package $PackageUpdate
