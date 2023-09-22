#!/bin/bash

function PACKMAN_ZYPP {
    SUDO zypper --gpg-auto-import-keys --no-gpg-checks ar -n "Packman Essentials" -cfp 90 "https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/" packman-essentials
    SUDO zypper --gpg-auto-import-keys --no-gpg-checks refresh
    SUDO zypper --gpg-auto-import-keys --no-gpg-checks dup -y -l --from packman-essentials --allow-vendor-change
}

function MONGODB_ZYPP {
    SUDO rpm --import https://www.mongodb.org/static/pgp/server-6.0.asc
    SUDO zypper --gpg-auto-import-keys --no-gpg-checks addrepo -n "Mongodb" --gpgcheck "https://repo.mongodb.org/zypper/suse/15/mongodb-org/6.0/x86_64/" mongodb
}

function MICROSOFT_ZYPP {
    SUDO $Package $PackageInstall libicu
    SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    wget https://packages.microsoft.com/config/opensuse/15/prod.repo
    SUDO mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
    SUDO chown root:root /etc/zypp/repos.d/microsoft-prod.repo
}

function GITHUB_UNOFFICIAL_ZYPP {
    SUDO rpm --import https://rpm.packages.shiftkey.dev/gpg.key
    SUDO sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nenabled=0\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/zypp/repos.d/shiftkey-packages.repo'
}

function VSCODE_ZYPP {
    SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    SUDO sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
}

function SUBLIME_ZYPP {
    SUDO rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    SUDO zypper addrepo -d -g -f "https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo"
}

function SNAPD_ZYPP {
    SUDO zypper --gpg-auto-import-keys --no-gpg-checks addrepo -n "Snappy" -d "https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed" snappy
}



PACKMAN_ZYPP
MONGODB_ZYPP
MICROSOFT_ZYPP

GITHUB_UNOFFICIAL_ZYPP
VSCODE_ZYPP
SUBLIME_ZYPP

SNAPD_ZYPP

SUDO $Package $PackageRefresh
SUDO $Package $PackageUpdate
