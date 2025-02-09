#!/bin/bash

chmod 755 $GetDataDir/scripts/*
SUDO rsync -a --info=progress2 --force $GetDataDir/scripts/ /usr/local/bin/

if [ -f "$USERHOME/.config/MangoHud/MangoHud.conf" ]; then
    sleep 2
    cd .
    sleep 2
    /usr/local/bin/MangoHud-Switch
    /usr/local/bin/MangoHud-Switch
fi
##################################################################################################################
shopt -s dotglob

rsync -a --info=progress2 --force -L $GetDataDir/home/ $USERHOME/

SUDO su -c "rsync -a --info=progress2 --force -L $GetDataDir/root/ /root/"
SUDO su -c "rsync -a --info=progress2 --force -L $GetDataDir/home/ /root/"

shopt -u dotglob
##################################################################################################################
if [ -f "/bin/zsh" ]; then
    SUDO usermod -s /bin/zsh "$USERNAME"
fi

if [ -f "/bin/fish" ] && [ ! -x "$(command -v fisher)" ]; then
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source ; fisher install jorgebucaran/fisher"
fi

if systemctl status cups.service &> /dev/null; then
    #SUDO adduser $home lpadmin
    SUDO service cups start
    SUDO systemctl start cups
    SUDO systemctl enable cups
fi

if [ -x "$(command -v snapper)" ]; then
    SUDO snapper -c home create-config /home
    SUDO snapper -c home create --description "New config"
fi

if ! lsmod | grep -q ntfs3; then
SUDO /sbin/modprobe ntfs3
fi

mkdir -p $USERHOME/source
CreateDesktopEntry $USERHOME/source folder-build
mkdir -p $USERHOME/source/gitlab
mkdir -p $USERHOME/source/github
mkdir -p $XDG_VIDEOS_DIR/OBS
mkdir -p $XDG_VIDEOS_DIR/Kdenlive