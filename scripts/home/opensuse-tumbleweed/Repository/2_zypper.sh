#!/bin/bash

function NVIDIA_ZYPP {
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
}
function PACKMAN_ZYPP {
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks ar -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/ packman-essentials
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks refresh
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks dup -y -l --from packman-essentials --allow-vendor-change
}
function ASUSCOMM_DNF_ZYPP {
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks ar --priority 50 -d https://download.opensuse.org/repositories/home:/luke_nukem:/asus/openSUSE_Tumbleweed/ asus-linux
    $SUDO rpm --import https://download.copr.fedorainfracloud.org/results/lukenukem/asus-linux/pubkey.gpg

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
" | $SUDO tee /etc/zypp/repos.d/asus-linux-fedora.repo
}

function BRAVE_ZYPP {
    $SUDO $Package $PackageInstall curl
    $SUDO rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks addrepo --refresh https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
}

function ANYDESK_ZYPP {
    echo -e "
[anydesk]
name=AnyDesk OpenSUSE - stable
baseurl=http://rpm.anydesk.com/opensuse/\$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
" | $SUDO tee /etc/zypp/repos.d/AnyDesk-OpenSUSE.repo
}

function TEAMVIWER_ZYPP {
    echo -e "
[teamviewer]
name=TeamViewer - \$basearch
enabled=1
autorefresh=0
baseurl=https://linux.teamviewer.com/yum/stable/main/binary-\$basearch/
type=rpm-md
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://linux.teamviewer.com/pubkey/currentkey.asc
keeppackages=0
" | $SUDO tee /etc/zypp/repos.d/teamviewer.repo
}

function MONGODB_ZYPP {
    $SUDO rpm --import https://www.mongodb.org/static/pgp/server-6.0.asc
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks addrepo --gpgcheck "https://repo.mongodb.org/zypper/suse/15/mongodb-org/6.0/x86_64/" mongodb
}

function MICROSOFT_ZYPP {
    $SUDO $Package $PackageInstall libicu
    $SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    wget https://packages.microsoft.com/config/opensuse/15/prod.repo
    $SUDO mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
    $SUDO chown root:root /etc/zypp/repos.d/microsoft-prod.repo
}

function GITHUB_UNOFFICIAL_ZYPP {
    $SUDO rpm --import https://rpm.packages.shiftkey.dev/gpg.key
    $SUDO sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/zypp/repos.d/shiftkey-packages.repo'
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks refresh
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks mr -n "GitHub Desktop" -d
}

function VSCODE_ZYPP {
    $SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    $SUDO sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
}

function SUBLIME_ZYPP {
    $SUDO rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    $SUDO zypper addrepo -d -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
}

function SNAPD_ZYPP {
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks addrepo -d https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
}

function MEGASYNC_ZYPP {
    $SUDO rpm --import https://mega.nz/linux/repo/openSUSE_Tumbleweed/repodata/repomd.xml.key
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks addrepo -d https://mega.nz/linux/repo/openSUSE_Tumbleweed/ MEGAsync
}

function CHROME_ZYPP {
    $SUDO rpm --import https://dl.google.com/linux/linux_signing_key.pub
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks addrepo -d http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
}

function EDGE_ZYPP {
    $SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks addrepo https://packages.microsoft.com/yumrepos/edge microsoft-edge
}

NVIDIA_ZYPP
PACKMAN_ZYPP
ASUSCOMM_DNF_ZYPP
BRAVE_ZYPP
ANYDESK_ZYPP
TEAMVIWER_ZYPP
MONGODB_ZYPP
MICROSOFT_ZYPP

GITHUB_UNOFFICIAL_ZYPP
VSCODE_ZYPP
SUBLIME_ZYPP

SNAPD_ZYPP

MEGASYNC_ZYPP

CHROME_ZYPP
EDGE_ZYPP

$SUDO $Package $PackageRefresh
$SUDO $Package $PackageUpdate
