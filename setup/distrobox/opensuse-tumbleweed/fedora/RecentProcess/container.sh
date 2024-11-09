#!/bin/bash
#bash
mkdir -p /etc/profile.d/
SUDO su -c "echo -e \"\n# this one is for my ohmyposh theme. If you don't want docker special marks to appear,\n# you need to delete the value directly. It will work as long as a value is kept in it.\nexport Docker_enabled=1\nexport Distrobox_enabled=1\nexport QT_QPA_PLATFORMTHEME=qt5ct\n\" | tee /etc/profile.d/distroboxenvimage.sh"

SUDO su -c "echo \"test -s /etc/profile.d/distroboxenvimage.sh && . /etc/profile.d/distroboxenvimage.sh\" | tee -a /etc/bash.bashrc"

SUDO su -c "echo \"test -s /etc/profile.d/distroboxenvimage.sh && . /etc/profile.d/distroboxenvimage.sh\" | tee -a /etc/zsh/zshrc"

#fish
mkdir -p /etc/fish/conf.d/ 
SUDO su -c "echo -e \"\n# this one is for my ohmyposh theme. If you don't want docker special marks to appear,\n# you need to delete the value directly. It will work as long as a value is kept in it.\nset -x Docker_enabled 1\nset -x Distrobox_enabled 1\nset -x QT_QPA_PLATFORMTHEME qt5ct\n\" | tee /etc/fish/conf.d/distroboxenvimage.fish"
