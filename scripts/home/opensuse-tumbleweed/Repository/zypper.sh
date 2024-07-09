#!/bin/bash

function repo_nvidia_zypp {
    SUDO $Package $PackageInstall openSUSE-repos-Tumbleweed-NVIDIA
}

function repo_packman_zypp {
    SUDO zypper --gpg-auto-import-keys ar -n "Packman Essentials" -cfp 90 "https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/" packman-essentials
    SUDO zypper --gpg-auto-import-keys dup -y -l --from packman-essentials --allow-vendor-change
}

function repo_snapd_zypp {
    SUDO zypper --gpg-auto-import-keys addrepo -d -n "Snappy" "https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed" snappy
}

function repo_asuscommunity_dnf_zypp () {
    SUDO rpm --import https://download.copr.fedorainfracloud.org/results/lukenukem/asus-linux/pubkey.gpg
    SUDO zypper --gpg-auto-import-keys ar -p 50 -d -n "Asus Linux" "https://download.opensuse.org/repositories/home:/luke_nukem:/asus/openSUSE_Tumbleweed/" asus-linux
    SUDO zypper --gpg-auto-import-keys ar --gpgcheck-allow-unsigned-repo -p 50 -f -n "Asus Linux (Fedora 40)" "https://download.copr.fedorainfracloud.org/results/lukenukem/asus-linux/fedora-40-x86_64/" asus-linux-fedora
}
function repo_bravebrowser_zypp {
    SUDO $Package $PackageInstall curl
    SUDO rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    SUDO zypper --gpg-auto-import-keys addrepo -n "Brave Browser" -f "https://brave-browser-rpm-release.s3.brave.com/x86_64/" brave-browser
}

function repo_chrome_zypp {
    SUDO rpm --import https://dl.google.com/linux/linux_signing_key.pub
    SUDO zypper --gpg-auto-import-keys addrepo -n "Google Chrome" "http://dl.google.com/linux/chrome/rpm/stable/x86_64" Google-Chrome
}

function repo_edge_zypp {
    SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    SUDO zypper --gpg-auto-import-keys addrepo -n "Microsoft Edge" "https://packages.microsoft.com/yumrepos/edge" microsoft-edge
}

function repo_anydesk_zypp {
    SUDO rpm --import https://keys.anydesk.com/repos/RPM-GPG-KEY
    SUDO zypper --gpg-auto-import-keys addrepo -n "AnyDesk OpenSUSE - stable" -f "http://rpm.anydesk.com/opensuse/\$basearch/" anydesk
}

function repo_teamviewer_zypp {
SUDO rpm --import https://linux.teamviewer.com/pubkey/currentkey.asc
SUDO zypper --gpg-auto-import-keys addrepo --gpgcheck -n "TeamViewer - \$basearch" "https://linux.teamviewer.com/yum/stable/main/binary-\$basearch/" teamviewer
}

function repo_microsoft_zypp {
    SUDO $Package $PackageInstall libicu
    SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    wget https://packages.microsoft.com/config/opensuse/15/prod.repo
    SUDO mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
    SUDO chown root:root /etc/zypp/repos.d/microsoft-prod.repo
}

function repo_unofficial_githubdesktop_zypp {
    SUDO rpm --import https://rpm.packages.shiftkey.dev/gpg.key
    SUDO sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=0\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/zypp/repos.d/shiftkey-packages.repo'
}

function repo_vscode_zypp {
    SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    SUDO sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
}

function repo_vscodium_zypp {
    SUDO rpm --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
    SUDO sh -c 'echo -e "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://download.vscodium.com/rpms/\nenabled=0\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" > /etc/zypp/repos.d/vscodium.repo'
}

function repo_sublimetexteditor_zypp {
    SUDO rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    SUDO zypper addrepo -d -g -f "https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo"
}

function repo_megasync_zypp {
    SUDO rpm --import https://mega.nz/linux/repo/openSUSE_Tumbleweed/repodata/repomd.xml.key
    SUDO zypper --gpg-auto-import-keys addrepo -d -n "MEGAsync" "https://mega.nz/linux/repo/openSUSE_Tumbleweed/" MEGAsync
}

function repo_yandexdisk_zypp {
    SUDO rpm --import http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG
    SUDO sh -c 'echo -e "[yandex]\nname=Yandex\nfailovermethod=priority\nbaseurl=http://repo.yandex.ru/yandex-disk/rpm/stable/\$basearch/\nenabled=1\nmetadata_expire=1d\ngpgcheck=1\ngpgkey=http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG" > /etc/zypp/repos.d/yandex.repo'
}

SUDO zypper --gpg-auto-import-keys refresh

repo_nvidia_zypp
repo_asuscommunity_dnf_zypp

repo_packman_zypp
repo_snapd_zypp

repo_bravebrowser_zypp
repo_chrome_zypp
repo_edge_zypp

repo_anydesk_zypp
repo_teamviewer_zypp

repo_microsoft_zypp

repo_unofficial_githubdesktop_zypp
repo_vscode_zypp
repo_vscodium_zypp
repo_sublimetexteditor_zypp

repo_megasync_zypp
repo_yandexdisk_zypp
