#!/bin/bash

### Fonts
termcols=$(tput cols)
bold="$(tput bold)"
fontnormal="$(tput init)"
fontreset="$(tput reset)"
underline="$(tput smul)"
standout="$(tput smso)"
normal="$(tput sgr0)"
black="$(tput setaf 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
magenta="$(tput setaf 5)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"
### Finish
if [[ $EUID -ne 0 ]]; then
   #echo "$red TUR:Süper Kullanıcı/Root Olmanız gerekiyor." 
     echo "$red ENG:You need to be Super User/Root. $white" 
       #echo "$red GER: Sie müssen Superuser/Root sein." 
   exit 1
fi
###################PACKAGE##############################################################
if ! [ -x "$(command -v lsb_release)" ]; then
if [ -x "$(command -v apt)" ]; then
echo "$red I couldn't find the lsb-release package. $green I'm uploading now. $white"
sudo apt install -y lsb-release
elif [ -x "$(command -v zypper)" ]; then
echo "$red I couldn't find the lsb-release package. $green I'm uploading now. $white"
 sudo zypper in -y lsb-release
elif [ ! -x "$(command -v zypper)" ] && [ -x "$(command -v dnf)" ]; then
echo "$red I couldn't find the redhat-lsb-core package. $green I'm uploading now. $white"
 sudo dnf install -y redhat-lsb-core
 else
  #echo "$red İşlem İptal: lsb_release Paketi Bulunmadığından işlem iptal edildi." >&2
  echo "$red Transaction Canceled: The operation was canceled because the lsb_release Package is Not Found. $white" >&2
  exit 1
fi
fi
####
if ! [ -x "$(command -v lsb_release)" ]; then
if [ -x "$(command -v apt)" ]; then
echo "$red I couldn't find the sudo package. $green I'm uploading now. $white"
sudo apt install -y sudo
elif [ -x "$(command -v zypper)" ]; then
echo "$red I couldn't find the sudo package. $green I'm uploading now. $white"
 sudo zypper in -y sudo
elif [ ! -x "$(command -v zypper)" ] && [ -x "$(command -v dnf)" ]; then
echo "$red I couldn't find the sudo package. $green I'm uploading now. $white"
 sudo dnf install -y sudo
 else
  #echo "$red İşlem İptal: sudo Paketi Bulunmadığından işlem iptal edildi." >&2
  echo "$red Transaction Canceled: The operation was canceled because the sudo Package is Not Found. $white" >&2
  exit 1
fi
fi
###############################PACKAGE FINISH##################

########################ARGS##################################
powershell=false;
zypperdnf=false;
guivalue=false;
zypperdnfgui=false;
#########################
i=1;
j=$#;
while [ $i -le $j ]
do

if [[ $1 == "--powershell" ]] || [[ $1 == "-ps" ]]; then
powershell=true;
elif [[ $1 == "--dnf" ]]; then
zypperdnf=true;
elif [[ $1 == "--gui" ]]; then
guivalue=true;
elif [[ $1 == "--guidnf" ]]; then
guivalue=false;
zypperdnfgui=true;
    else
    echo "$red Invalid argument-$i: $1 $white";
    fi
    i=$((i + 1));
    shift 1;
done

#######################ARGS FINISH#########################
function opensuse_tw {

if [[ $zypperdnf == true ]]; then
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
curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.2.0/powershell-7.2.0-linux-x64.tar.gz -o /tmp/powershell.tar.gz
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
sudo dnf install -y zsh curl neofetch screenfetch git opi lzip unzip e2fsprogs nano
sudo dnf install -y brave-browser-nightly
}

function developerpackage {
    sudo dnf install -y nodejs-default python38 python38-pip dotnet-sdk-5.0 llvm-clang icu gcc gcc-c++
     sudo zypper install -y --type  pattern devel_basis
}

else {

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
curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.2.0/powershell-7.2.0-linux-x64.tar.gz -o /tmp/powershell.tar.gz
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
sudo zypper install -y zsh curl neofetch screenfetch git opi lzip unzip e2fsprogs nano
sudo zypper install -y brave-browser-nightly
}

function developerpackage {
    sudo zypper install -y nodejs-default python38 python38-pip dotnet-sdk-5.0 llvm-clang icu gcc gcc-c++
     sudo zypper install -y --type  pattern devel_basis
}

}



update
repository
if [[ $powershell == true ]]; then
powershell
fi
dnfsetup
basepackage
developerpackage
#

if [[ $zypperdnfgui == true ]] && [[ $guivalue == false ]]; then
if [ ! -x "$(command -v dnf)" ]; then
$guivalue == true;
$zypperdnfgui == false;
else
sudo dnf install -y noto-sans-fonts gsettings-desktop-schemas xorg-x11-libs xorg-x11-server humanity-icon-theme patterns-fonts-fonts patterns-fonts-fonts_opt xorg-x11-fonts materia-gtk-theme gnome-tweaks
sudo dnf install -y Mesa-devel libOSMesa-devel libgthread-2_0-0 libts0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libevent-2_1-7 libminizip1 libpcre2-16-0
fi
fi

if [[ $zypperdnfgui == false ]] && [[ $guivalue == true ]]; then
sudo zypper --gpg-auto-import-keys in -y noto-sans-fonts gsettings-desktop-schemas xorg-x11-libs xorg-x11-server humanity-icon-theme patterns-fonts-fonts patterns-fonts-fonts_opt xorg-x11-fonts materia-gtk-theme gnome-tweaks
sudo zypper --gpg-auto-import-keys in -y Mesa-devel libOSMesa-devel libgthread-2_0-0 libts0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libevent-2_1-7 libminizip1 libpcre2-16-0
fi
} 
#

function fedora {

function update {
sudo dnf update --refresh -y
}
function repository {
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf update -y
}
function basepackage {
sudo dnf install -y passwd cracklib-dicts iputils util-linux-user
sudo dnf install -y git curl zsh wget dnf-plugins-core dnf-utils sudo neofetch screenfetch
}
function developerpackage {
    sudo dnf install -y swift-lang dotnet-sdk-5.0 nodejs python3
}

update
repository
basepackage
developerpackage

if [[ $guivalue == true ]]

echo "Soon."

fi

}

####OS SELECT
export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')
#########FINISH###################
unameout=$(uname -r | tr '[:upper:]' '[:lower:]')
[[ ! -f /proc/cpuinfo ]] && echo "I couldn't find the /proc/cpuinfo file so the process was aborted." && exit 1
if [[ "$unameout" == "*microsoft*" || "$unameout" == "*wsl*" ]] \
|| cat /proc/cpuinfo | grep "microcode" | grep "0xffffffff" &>/dev/null
then

if [ "$distroselect" == "openSUSE Tumbleweed" ]; then
opensuse_tw

elif [ "$distroselect" == "Fedora release 35 (Thirty Five)" ]; then
fedora
else
echo "$red Üzgünüm Bu Script Senin İşletim sistemin için uyarlanmadı."
fi

echo "$blue Script Bitti."
