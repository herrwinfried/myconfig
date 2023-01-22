#!/bin/bash
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

onlypc
checkroot
requirepackage

export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')
if [ "$distroselect" == "openSUSE Tumbleweed" ]; then
PackageName="zypper --gpg-auto-import-keys"
RPMArg="--no-gpg-checks"
PackageInstall="install -y -l"
UpdateArg="dup -y"
#
function repository {

#######################################################################################################
sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
#######################################################################################################

}
function x_package {
    sudo $PackageName $PackageInstall nvidia-glG06 x11-video-nvidiaG06 #xf86-video-intel bbswitch
    #sudo prime-select intel
   #sudo prime-select offload-set intel
  #  sudo prime-select offload
  #  sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service
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

repository
x_package
flatpakSetup
snapSetup
else
echo "Şuan için senin İşletim sisteminle uyumlu değil." && exit 1
fi

