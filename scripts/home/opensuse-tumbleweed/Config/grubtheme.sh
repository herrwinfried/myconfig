#!/bin/bash

if [[ $BOARD_VENDOR == *"asus"* ]]; then
SUDO $Package $PackageInstall curl tar jq

asustheme=$(curl -s "https://api.github.com/repos/AdisonCavani/distro-grub-themes/releases/latest" | jq -r ".assets[] | select(.name | test(\"asus.tar\")) | .browser_download_url")
DEFAULT_GRUB_THEME="GRUB_THEME=/boot/grub2/themes/openSUSE/theme.txt"
if [ -d "/tmp/asus.tar" ]; then
    SUDO rm -rf /tmp/asus*
fi

if [ -d "/boot/grub2.d/themes/asus" ]; then
    echo -e "${Yellow}Removing the /boot/grub2.d/themes/asus folder..${NoColor}"
    SUDO rm -rf /boot/grub2.d/themes/asus
    if [ "$current_grub_theme" != "$DEFAULT_GRUB_THEME" ]; then
    SUDO sed -i "s|^GRUB_THEME=.*|$DEFAULT_GRUB_THEME|" /etc/default/grub
    echo -e "${Green}GRUB_THEME value successfully reverted to its initial state.${NoColor}"
fi
fi
sleep 3

curl -L "$asustheme" -o "/tmp/asus.tar"

SUDO mkdir -p /boot/grub2.d/themes/asus
SUDO tar -xf "/tmp/asus.tar" -C /boot/grub2.d/themes/asus

new_grub_theme="GRUB_THEME=/boot/grub2.d/themes/asus/theme.txt"
current_grub_theme=$(grep -E "^GRUB_THEME=" /etc/default/grub)

if [ "$current_grub_theme" != "$new_grub_theme" ]; then
    SUDO sed -i "s|^GRUB_THEME=.*|$new_grub_theme|" /etc/default/grub
    SUDO grub2-mkconfig -o /boot/grub2/grub.cfg
    echo -e "${Green}GRUB_THEME value successfully modified and Grub updated.${NoColor}"
fi

fi