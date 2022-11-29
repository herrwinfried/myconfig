#!/bin/bash
PackageName="dnf"
PackageInstall="install -y"
UpdateArg="update -y"


FolderName="myscripts_1"
FolderScript="files"


#######COLOR###################
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
#######FINISH###################


################REQUIRED##################################################################
if [[ $EUID -ne 0 ]]; then
   echo "$red Süper Kullanıcı/Root Olmanız gerekiyor."
   exit 1
fi
if ! [ -x "$(command -v lsb_release)" ]; then
    echo "$yellow Dikkat ! redhat-lsb-core Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo dnf install -y redhat-lsb-core
fi

if ! [ -x "$(command -v git)" ]; then
    echo "$yellow Dikkat ! git Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo dnf install -y git
fi

if ! [ -x "$(command -v wget)" ]; then
    echo "$yellow Dikkat ! wget Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo dnf install -y wget
fi


################REQUIRED FINISH##################################################################
export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')


if [ "$distroselect" == "Fedora release 37 (Thirty Seven)" ]; then
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
#
function repository {

#######################################################################################################
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
#######################################################################################################

}
function basepackage {
    sudo $PackageName $PackageInstall akmod-nvidia xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-cuda-libs
    sudo $PackageName $PackageInstall xorg-x11-drv-nvidia-power vdpauinfo libva-vdpau-driver libva-utils
    sudo systemctl enable nvidia-{suspend,resume,hibernate}
}

repository
basepackage
else
echo "Şuan için senin İşletim sisteminle uyumlu değil." && exit 1
fi

