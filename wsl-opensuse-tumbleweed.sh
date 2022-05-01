#!/bin/bash

ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

PackageName="zypper --gpg-auto-import-keys"
RPMArg="--no-gpg-checks"
PackageInstall="install -y -l"
UpdateArg="dup -y"
PackageRemove="remove -y"
onlywsl


function checkFolder {
mkdir -p $output
cd $output
}
function wsl_package {
sudo zypper install --recommends -y patterns-wsl-base patterns-wsl-gui patterns-wsl-systemd

sudo $PackageName $PackageInstall noto-sans-fonts gsettings-desktop-schemas xorg-x11-libs xorg-x11-server humanity-icon-theme materia-gtk-theme gnome-tweaks qt5ct \
Mesa-devel libOSMesa-devel libgthread-2_0-0 libts0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libevent-2_1-7 libminizip1 libpcre2-16-0 \
Mesa-libva

}
function rpms {

	checkFolder
    find . -iname '*.rpm' -exec chmod +x ./"{}" \;
	find . -iname '*.rpm' -exec $PackageName $RPMArg $PackageInstall ./"{}" \;
    sudo $PackageName $UpdateArg
}
function runs {
	checkFolder
	find . -iname '*.run' -exec chmod +x ./"{}" \;
	find . -iname '*.run' -exec sudo ./"{}" \;
}
function bundles {
	checkFolder
	find . -iname "*.bundle" -exec chmod +x ./"{}" \;
	find . -iname "*.bundle" -exec sudo ./"{}" \;

}
function appimages {

	checkFolder
	find . -iname "*.appimage" -exec chmod +x ./"{}" \;
	find . -iname "*.appimage" -exec sudo ./"{}" \;
}

function repository {
sudo zypper --gpg-auto-import-keys addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman
sudo zypper --gpg-auto-import-keys refresh
sudo zypper dist-upgrade -y --from packman --allow-vendor-change
#######################################################################################################
sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
#######################################################################################################
sudo zypper --gpg-auto-import-keys install -y curl
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo zypper --gpg-auto-import-keys addrepo --refresh https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
#######################################################################################################
sudo zypper --gpg-auto-import-keys install -y libicu
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
wget https://packages.microsoft.com/config/opensuse/15/prod.repo
sudo mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
sudo chown root:root /etc/zypp/repos.d/microsoft-prod.repo
#######################################################################################################
sudo rpm --import https://www.mongodb.org/static/pgp/server-6.0.asc
sudo zypper --gpg-auto-import-keys addrepo --gpgcheck "https://repo.mongodb.org/zypper/suse/15/mongodb-org/6.0/x86_64/" mongodb
#######################################################################################################
zypper --gpg-auto-import-keys --non-interactive --quiet addrepo --refresh -p 90  http://download.opensuse.org/repositories/server:database:postgresql/openSUSE_Tumbleweed/ PostgreSQL
#######################################################################################################
sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
}

function basepackage {
sudo zypper --gpg-auto-import-keys install -y --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full
    sudo $PackageName $PackageInstall dracula-gtk-theme fetchmsttfonts powerline-fonts \
neofetch screenfetch hwinfo htop ffmpeg zsh git curl wget lsb-release \
brave-browser \
zsh curl neofetch git opi lzip unzip e2fsprogs nano
}

function x_powershell {
sudo $PackageName $UpdateArg
sudo $PackageName $PackageInstall curl tar libicu72 libopenssl1_0_0 jq
pwshcore=$(curl -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest| jq -r ".assets[] | select(.name | test(\"linux-x64.tar.gz\")) | .browser_download_url")

curl -L $pwshcore -o /tmp/powershell.tar.gz
sudo mkdir -p /opt/microsoft/powershell
sudo tar -xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/
sudo ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
sudo chmod +x /usr/bin/pwsh
}

function x_ohmyposh {
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

mkdir $HomePWD/.poshthemes
wget https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/powerlevel10k_rainbow.omp.json -O $HomePWD/.poshthemes/powerlevel10k_rainbow.omp.json
chmod u+rw $HomePWD/.poshthemes/*.omp.*
}

function apple_device {
    sudo $PackageName $PackageInstall ifuse libimobiledevice-1_0-6 libimobiledevice-devel usbmuxd libimobiledevice-glue-1_0-0
}

function dnfsetup {
sudo zypper --gpg-auto-import-keys install -y dnf libdnf-repo-config-zypp
sudo dnf swap -y PackageKit-backend-zypp PackageKit-backend-dnf
sudo dnf makecache -y && sudo zypper --gpg-auto-import-keys refresh

}
function flatpakSetup {
sudo $PackageName $PackageInstall flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

function snapSetup {
  sudo $PackageName $PackageInstall snapd
  sudo systemctl enable --now snapd && sudo systemctl enable --now snapd.apparmor
  sudo systemctl start --now snapd && sudo systemctl start --now snapd.apparmor
}

function developerpackage {

sudo $PackageName $PackageInstall \
apache2 php8 php8-mysql apache2-mod_php8 mariadb mariadb-tools mongodb-org nodejs-default npm-default php-composer2 \
dotnet-sdk-6.0 llvm-clang gcc gcc-c++ cmake cmake-full extra-cmake-modules rsync gdb ninja \
patterns-devel-base-devel_basis patterns-devel-C-C++-devel_C_C++ \
gtk3-devel \
java-18-openjdk \
patterns-kde-devel_kde_frameworks patterns-kde-devel_qt5 desktop-file-utils #patterns-devel-base-devel_rpm_build #patterns-devel-mono-devel_mono
##Config

    mkdir -p ~/data/db
    a2enmod php8
    sudo echo "AddType application/x-httpd-php .php" >> /etc/apache2/mod_mime-defaults.conf

##Config FINISH
}
sudo $PackageName $UpdateArg
wsl_package

repository
dnfsetup
snapSetup
flatpakSetup

basepackage
apple_device

x_powershell
x_ohmyposh

rpms
runs
bundles
appimages



developerpackage
