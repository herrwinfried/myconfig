#!/bin/bash
function asus_community {
sudo $PackageName $PackageInstall asusctl asusctl-rog-gui
sudo systemctl enable --now supergfxd.service
sudo systemctl enable --now asusd.service
sudo systemctl start --now supergfxd.service
sudo systemctl start --now asusd.service
}
if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
asus_community
fi