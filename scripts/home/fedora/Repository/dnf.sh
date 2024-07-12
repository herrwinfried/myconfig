#!/bin/bash

function repo_rpmfusion_dnf {
    SUDO $Package $PackageInstall "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
}

function repo_asuscommunity_dnf {
    SUDO dnf copr enable -y lukenukem/asus-linux
}

function repo_bravebrowser_dnf {
    SUDO $Package $PackageInstall dnf-plugins-core
    SUDO dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    SUDO rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
}

function repo_chrome_dnf {
    SUDO rpm --import https://dl.google.com/linux/linux_signing_key.pub
    SUDO dnf config-manager --add-repo "http://dl.google.com/linux/chrome/rpm/stable/x86_64"
}

function repo_edge_dnf {
    SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    SUDO dnf config-manager --add-repo "https://packages.microsoft.com/yumrepos/edge"
}

function repo_teamviewer_dnf {
    SUDO rpm --import https://linux.teamviewer.com/pubkey/currentkey.asc
    SUDO dnf config-manager --add-repo "https://linux.teamviewer.com/yum/stable/main/binary-\$basearch/" teamviewer
}

function repo_docker_dnf {
    SUDO $Package $PackageInstall dnf-plugins-core
    SUDO dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
}

function repo_microsoft_dnf {
    SUDO $Package $PackageInstall libicu
    SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    curl -sSL -O https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm
    SUDO rpm -i packages-microsoft-prod.rpm
    SUDO rm packages-microsoft-prod.rpm
}

function repo_unofficial_githubdesktop_dnf {
    SUDO rpm --import https://rpm.packages.shiftkey.dev/gpg.key
    SUDO sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=0\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/yum.repos.d/shiftkey-packages.repo'
}

function repo_vscode_dnf {
    SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    SUDO sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
}

function repo_vscodium_dnf {
    SUDO rpm --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
    SUDO sh -c 'echo -e "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://download.vscodium.com/rpms/\nenabled=0\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" > /etc/yum.repos.d/vscodium.repo'
}

function repo_sublimetexteditor_dnf {
    SUDO rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    SUDO dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
}

function repo_megasync_dnf {
    SUDO rpm --import https://mega.nz/linux/repo/Fedora_40/repodata/repomd.xml.key
    SUDO dnf config-manager --add-repo "https://mega.nz/linux/repo/Fedora_40/"
}

function repo_yandexdisk_dnf {
    SUDO rpm --import http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG
    SUDO sh -c 'echo -e "[yandex]\nname=Yandex\nfailovermethod=priority\nbaseurl=http://repo.yandex.ru/yandex-disk/rpm/stable/\$basearch/\nenabled=1\nmetadata_expire=1d\ngpgcheck=1\ngpgkey=http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG" > /etc/yum.repos.d/yandex.repo'
}

SUDO dnf makecache -y

repo_rpmfusion_dnf
repo_asuscommunity_dnf

repo_bravebrowser_dnf
repo_chrome_dnf
repo_edge_dnf

repo_teamviewer_dnf

repo_docker_dnf
repo_microsoft_dnf

repo_unofficial_githubdesktop_dnf
repo_vscode_dnf
repo_vscodium_dnf
repo_sublimetexteditor_dnf

repo_megasync_dnf
repo_yandexdisk_dnf
