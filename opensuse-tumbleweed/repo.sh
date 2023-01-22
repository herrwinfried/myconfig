#!/bin/bash

function packmanrepo {
sudo zypper --gpg-auto-import-keys addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman
sudo zypper --gpg-auto-import-keys refresh
sudo zypper dist-upgrade -y --from packman --allow-vendor-change
}
function nvidiarepo {
sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA   
}
function bravebrowser {
    sudo zypper --gpg-auto-import-keys install -y curl
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo zypper --gpg-auto-import-keys addrepo --refresh https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
}
function microsoft {
sudo zypper --gpg-auto-import-keys install -y libicu
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
wget https://packages.microsoft.com/config/opensuse/15/prod.repo
sudo mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
sudo chown root:root /etc/zypp/repos.d/microsoft-prod.repo
}
function mongodbrepo {
sudo rpm --import https://www.mongodb.org/static/pgp/server-6.0.asc
sudo zypper addrepo --gpgcheck "https://repo.mongodb.org/zypper/suse/15/mongodb-org/6.0/x86_64/" mongodb
}
function pssqlrepo {
sudo zypper --non-interactive --quiet addrepo --refresh -p 90  http://download.opensuse.org/repositories/server:database:postgresql/openSUSE_Tumbleweed/ PostgreSQL
}
function vscode {
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
}
function anydeskrepo {
cat > AnyDesk-OpenSUSE.repo << "EOF"
[anydesk]
name=AnyDesk OpenSUSE - stable
baseurl=http://rpm.anydesk.com/opensuse/$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
EOF
sudo zypper --gpg-auto-import-keys addrepo --repo AnyDesk-OpenSUSE.repo
}
function asuscommunity {
sudo zypper ar --priority 50 --refresh https://download.opensuse.org/repositories/home:/luke_nukem:/asus/openSUSE_Tumbleweed/ asus-linux
}
function snaprepo {
sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
}
function chromerepo {
sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub
sudo zypper addrepo http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
}

packmanrepo
nvidiarepo
asuscommunity
snaprepo
bravebrowser
microsoft
mongodbrepo
pssqlrepo
vscode

#chromerepo

sudo zypper --gpg-auto-import-keys refresh