#!/bin/bash

if ! checkwsl; then

VT_D="intel_iommu=on"
IOMMU="iommu=pt"
GRUB_FILE="/etc/default/grub"
if [ -f "$GRUB_FILE" ]; then 
CURRENT_SETTINGS=$(grep -oP 'GRUB_CMDLINE_LINUX_DEFAULT="[^"]*"' $GRUB_FILE | cut -d'"' -f2)
    if [[ "$CURRENT_SETTINGS" != *"$VT_D"* ]] && [[ "$CURRENT_SETTINGS" != *"$IOMMU"* ]]; then
        NEW_SETTINGS="\"$CURRENT_SETTINGS $VT_D $IOMMU\""
       sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 $VT_D $IOMMU\"/" $GRUB_FILE && \
        echo $green"$VT_D and $IOMMU parameters have been added to the grub2 configuration file.$white"
    else
        echo $yellow"$VT_D and $IOMMU parameters are already included in the grub2 configuration file.$white"
    fi
else
    echo $red"Grub2 configuration file not found. Please check your operating system.$white"
fi

echo "$yellow"sudo sed -i "s/#user = "qemu"/user = "$(id -un)"/g" /etc/libvirt/qemu.conf $white
SUDO sed -i "s/#user = "qemu"/user = "$(id -un)"/g" /etc/libvirt/qemu.conf
echo "$yellow"sed -i "s/#group = "qemu"/group = "$(id -gn)"/g" /etc/libvirt/qemu.conf $white
SUDO sed -i "s/#group = "qemu"/group = "$(id -gn)"/g" /etc/libvirt/qemu.conf

echo $green"Adding $Username to kvm, libvirt, input groups...$cyan(sudo usermod -aG kvm,libvirt,input $Username)$white"
SUDO usermod -aG kvm,libvirt,input $Username 
fi
