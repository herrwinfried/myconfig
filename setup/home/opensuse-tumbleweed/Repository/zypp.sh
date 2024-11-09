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

function repo_cloudflarewarp_zypp {
    SUDO rpm --import https://pkg.cloudflareclient.com/pubkey.gpg
    SUDO su -c 'curl -fsSl https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo | tee /etc/zypp/repos.d/cloudflare-warp.repo'
}

function repo_vscode_zypp {
SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc
SUDO su -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" |sudo tee /etc/zypp/repos.d/vscode.repo > /dev/null'
}

function repo_vscodium_zypp {
    SUDO rpm --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
    SUDO su -c 'tee -a /etc/zypp/repos.d/vscodium.repo << "EOF"
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=0
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF
'
}

function repo_sublimetexteditor_zypp {
    SUDO rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    SUDO zypper addrepo -d -g -f "https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo"
}

function repo_megasync_zypp {
    SUDO rpm --import https://mega.nz/linux/repo/openSUSE_Tumbleweed/repodata/repomd.xml.key
    SUDO zypper --gpg-auto-import-keys addrepo -d -n "MEGAsync" "https://mega.nz/linux/repo/openSUSE_Tumbleweed/" MEGAsync
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
repo_cloudflarewarp_zypp

repo_microsoft_zypp

repo_vscode_zypp
repo_vscodium_zypp
repo_sublimetexteditor_zypp

repo_megasync_zypp
