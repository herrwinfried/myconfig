#!/bin/bash

function opensuse_tw () {
# TW DNFVALUE GUIVALUE POWERSHELLVALUE

# DNF VALUE=0 | ZYPPER 
# DNF VALUE=1 | DNF

# GUIVALUE = 0 | GUI SETUP NONE
# GUIVALUE = 1 |ZYPPER
# GUIVALUE = 2 | DNF

# POWERSHELL = 1 | PWSH SETUP
# POWERSHELL = 0 | PWSH DON'T SETUP

tw_dnf=$1
tw_gui=$2
tw_pwsh=$3

if [[ $tw_dnf -eq 1 ]]; then
tw_package=dnf
else
tw_package="zypper --gpg-auto-import-keys"
fi
###########################################
if [[ $tw_gui -eq 2 ]]; then
tw_gui_package=dnf
elif [[ $tw_gui -eq 1 ]]; then
tw_gui_package="zypper --gpg-auto-import-keys"
fi
###########################################
function update {
sudo zypper --gpg-auto-import-keys dup -y
}
function repository {
sudo zypper --gpg-auto-import-keys addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman
sudo zypper --gpg-auto-import-keys refresh
sudo zypper --gpg-auto-import-keys dist-upgrade -y --from packman --allow-vendor-change
#################################
sudo zypper --gpg-auto-import-keys install -y libicu
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
wget https://packages.microsoft.com/config/opensuse/15/prod.repo
sudo mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
sudo chown root:root /etc/zypp/repos.d/microsoft-prod.repo
##########################################
sudo rpm --import https://brave-browser-rpm-nightly.s3.brave.com/brave-core-nightly.asc
sudo zypper addrepo https://brave-browser-rpm-nightly.s3.brave.com/x86_64/ brave-browser-nightly
##########################################
sudo zypper --gpg-auto-import-keys refresh
}
function powershell {
sudo zypper update
sudo zypper in -y curl tar libicu60_2 libopenssl1_0_0
curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.2.2/powershell-7.2.2-linux-x64.tar.gz -o /tmp/powershell.tar.gz
sudo mkdir -p /opt/microsoft/powershell
sudo tar -xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/
sudo ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
sudo chmod +x /usr/bin/pwsh
}

function dnfsetup {
sudo zypper --gpg-auto-import-keys install -y dnf rpm-repos-openSUSE
sudo dnf swap -y PackageKit-backend-zypp PackageKit-backend-dnf
sudo zypper --gpg-auto-import-keys refresh && sudo dnf makecache -y
}

function basepackage {
sudo zypper --gpg-auto-import-keys install -y --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full
sudo $tw_package install -y zsh curl neofetch screenfetch git opi lzip unzip e2fsprogs nano
sudo $tw_package install -y brave-browser-nightly
}

function developerpackage {
    sudo $tw_package install -y nodejs-default npm-default python39 python39-pip dotnet-sdk-6.0 llvm-clang icu gcc gcc-c++ cmake rsync gdb ninja
     sudo zypper install -y --type  pattern devel_basis
}

update
repository
if [[ $tw_pwsh -eq 1 ]]; then
powershell
fi
dnfsetup
basepackage
developerpackage

##########
sleepwait 2
##########

if [[ $tw_gui -eq 2 ]]; then
if [ ! -x "$(command -v dnf)" ]; then
tw_gui=1
tw_gui_package="zypper --gpg-auto-import-keys"
fi
fi
if [[ $tw_gui -eq 2 ]] || [[ $tw_gui -eq 1 ]]; then
sudo $tw_gui_package install -y noto-sans-fonts gsettings-desktop-schemas xorg-x11-libs xorg-x11-server humanity-icon-theme patterns-fonts-fonts patterns-fonts-fonts_opt xorg-x11-fonts materia-gtk-theme gnome-tweaks
sudo $tw_gui_package install -y Mesa-devel libOSMesa-devel libgthread-2_0-0 libts0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libevent-2_1-7 libminizip1 libpcre2-16-0

fi

}

