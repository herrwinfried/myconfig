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
PackageRemove="remove -y"
FlatpakInstall="flatpak install -y flathub"
SnapInstall="snap install"
#
function repository {

#######################################################################################################
sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
#######################################################################################################
sudo zypper ar --priority 50 --refresh https://download.opensuse.org/repositories/home:/luke_nukem:/asus/openSUSE_Tumbleweed/ asus-linux
}

function a_asus {

sudo $PackageName $PackageRemove suse-prime tlp
sudo $PackageName $PackageInstall asusctl asusctl-rog-gui supergfxctl power-profiles-daemon
sudo systemctl enable --now supergfxd.service
sudo systemctl enable --now asusd.service
sudo systemctl start --now supergfxd.service
sudo systemctl start --now asusd.service
}
function x_package {
    sudo $PackageName $PackageInstall nvidia-glG06 x11-video-nvidiaG06 #xf86-video-intel bbswitch
    #sudo prime-select intel
   #sudo prime-select offload-set intel
  #sudo prime-select offload
#sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service
}
function flatpakSetup {
sudo $PackageName $PackageInstall flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

groupadd wheel
usermod -aG wheel winfried

repository
x_package
a_asus
flatpakSetup

else
echo "Şuan için senin İşletim sisteminle uyumlu değil." && exit 1
fi

