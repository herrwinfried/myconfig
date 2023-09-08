#!/bin/bash

if ! checkwsl; then

if [ -x "$(command -v grubby)" ]; then
$SUDO grubby --update-kernel=ALL --args="intel_iommu=on"
$SUDO grubby --update-kernel=ALL --args="iommu=pt" 
else 
echo "$yellow""No parameters were added because$red Grubby was not found.$white Please add manually"
sleep 5
echo "$cyan""intel_iommu=on"
echo "$cyan""iommu=pt"
sleep 10
fi
echo $green"Adding $Username to kvm, libvirt, input groups...$cyan(sudo usermod -aG kvm,libvirt,input $Username)$white"
$SUDO usermod -aG kvm,libvirt,input $Username 

fi