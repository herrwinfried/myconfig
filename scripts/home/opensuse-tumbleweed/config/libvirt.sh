#!/bin/bash
if ! CheckWsl; then

VT_D="intel_iommu=on"
IOMMU="iommu=pt"
GRUB_FILE="/etc/default/grub"
if [ -f "$GRUB_FILE" ]; then 
CURRENT_SETTINGS=$(grep -oP 'GRUB_CMDLINE_LINUX_DEFAULT="[^"]*"' $GRUB_FILE | cut -d'"' -f2)
    if [[ "$CURRENT_SETTINGS" != *"$VT_D"* ]] && [[ "$CURRENT_SETTINGS" != *"$IOMMU"* ]]; then
        NEW_SETTINGS="\"$CURRENT_SETTINGS $VT_D $IOMMU\""
       sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 $VT_D $IOMMU\"/" $GRUB_FILE && \
        echo -e "${Green}${VT_D} and ${IOMMU} parameters have been added to the grub2 configuration file.${NoColor}"
    else
        echo -e "${Yellow}${VT_D} and ${IOMMU} parameters are already included in the grub2 configuration file.${NoColor}"
    fi
else
    echo -e "${Red}Grub2 configuration file not found. Please check your operating system.${NoColor}"
fi
if rpm -q libvirt ; then
echo -e "${Yellow}sed -i "s/#/user = \"qemu\"/user = \"$(id -gn)\"/g" /etc/libvirt/qemu.conf${NoColor}"
SUDO sed -i "s/#user = \"qemu\"/user = \"$(id -gn)\"/g" /etc/libvirt/qemu.conf
echo -e "${Yellow}sed -i "s/#group = \"qemu\"/group = \"$(id -gn)\"/g" /etc/libvirt/qemu.conf${NoColor}"
SUDO sed -i "s/#group = \"qemu\"/group = \"$(id -gn)\"/g" /etc/libvirt/qemu.conf
SUDO grub2-mkconfig -o /boot/grub2/grub.cfg
echo -e "${Green}sudo usermod -aG kvm,libvirt,input ${USERNAME} ${NoColor}"
SUDO usermod -aG kvm,libvirt,input $USERNAME 
fi
fi
