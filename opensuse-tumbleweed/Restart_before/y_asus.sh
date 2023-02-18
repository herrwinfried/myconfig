#!/bin/bash
function asus_community {
sudo $PackageName $PackageRemove suse-prime tlp
sudo $PackageName $PackageInstall asusctl asusctl-rog-gui supergfxctl power-profiles-daemon git zsh
sudo systemctl enable --now supergfxd.service
sudo systemctl enable --now asusd.service
}
if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
asus_community
fi