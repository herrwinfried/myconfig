#!/bin/bash

function RPMFusion {
    SUDO dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
}

function ASUSCOMM_DNF {
    SUDO dnf copr enable -y lukenukem/asus-linux
}

function BRAVE_DNF {
    SUDO dnf install -y dnf-plugins-core
    SUDO dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo -y
    SUDO rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
}

function TEAMVIWER_DNF {
    SUDO rpm --import https://linux.teamviewer.com/pubkey/currentkey.asc
    SUDO sh -c 'echo -e "[teamviewer]\nname=TeamViewer - \$basearch\nbaseurl=https://linux.teamviewer.com/yum/stable/main/binary-\$basearch/\ngpgkey=https://linux.teamviewer.com/pubkey/currentkey.asc\ngpgcheck=1\nrepo_gpgcheck=1\nenabled=1\ntype=rpm-md" > /etc/yum.repos.d/teamviewer.repo'
}

function MICROSOFT_DNF {
    SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    wget https://packages.microsoft.com/config/fedora/39/prod.repo
    SUDO mv prod.repo /etc/yum.repos.d/microsoft-prod.repo
    SUDO chown root:root /etc/yum.repos.d/microsoft-prod.repo
}

function GITHUB_UNOFFICIAL_DNF {
    SUDO rpm --import https://rpm.packages.shiftkey.dev/gpg.key
    SUDO sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/yum.repos.d/shiftkey-packages.repo'
}

function VSCODE_DNF {
    SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    SUDO sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
}

function SUBLIME_DNF {
    SUDO rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    SUDO dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
}

function MEGASYNC_ZYPP {
    SUDO rpm --import https://mega.nz/linux/repo/Fedora_$(rpm -E %fedora)/repodata/repomd.xml.key
    SUDO dnf config-manager --add-repo https://mega.nz/linux/repo/Fedora_$(rpm -E %fedora)/
}

function CHROME_DNF {
    SUDO rpm --import https://dl.google.com/linux/linux_signing_key.pub
    SUDO dnf config-manager --add-repo http://dl.google.com/linux/chrome/rpm/stable/x86_64
}

function EDGE_DNF {
    SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    SUDO dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
}

function POWERSHELL_DNF {
    SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    cat << EOL > /etc/yum.repos.d/microsoft-prod-rhel.repo
    [microsoft-rhel-90-prod]
    name=microsoft-rhel-90-prod
    baseurl=https://packages.microsoft.com/rhel/9.0/prod/
    enabled=1
    gpgcheck=1
    gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOL

    #curl -sSL -O https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm
    #SUDO rpm -i packages-microsoft-prod.rpm
    #rm packages-microsoft-prod.rpm
}

function DOCKER-CE_DNF {
    SUDO dnf -y install dnf-plugins-core
    SUDO dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
}

function NOISETORCH_UNOFFICIAL_DNF {
    SUDO dnf copr enable principis/NoiseTorch -y
}

RPMFusion
ASUSCOMM_DNF
BRAVE_DNF
TEAMVIWER_DNF
MICROSOFT_DNF
GITHUB_UNOFFICIAL_DNF
VSCODE_DNF
SUBLIME_DNF
MEGASYNC_ZYPP
CHROME_DNF
EDGE_DNF
POWERSHELL_DNF
DOCKER-CE_DNF
NOISETORCH_UNOFFICIAL_DNF

SUDO $Package $PackageRefresh
SUDO $Package $PackageUpdate
