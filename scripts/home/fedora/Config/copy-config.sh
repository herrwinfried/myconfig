#!/bin/bash

chmod 755 $GetDataDir/scripts/*
SUDO cp -rf $GetDataDir/scripts/* /usr/local/bin/

if [ -f "$USERHOME/.config/MangoHud/MangoHud.conf" ]; then
    sleep 2
    cd .
    sleep 2
    /usr/local/bin/MangoHud-Switch
fi
##################################################################################################################
shopt -s dotglob

rsync -a --info=progress2 --force -L $GetDataDir/home/ $USERHOME/

SUDO rsync -a --info=progress2 --force -L $GetDataDir/root/ /root/

shopt -u dotglob
##################################################################################################################
if [ -f "/bin/zsh" ]; then
    SUDO usermod -s /bin/zsh "$USERNAME"
fi

if [ -f "/bin/fish" ] && [ ! -x "$(command -v fisher)" ]; then
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source ; fisher install jorgebucaran/fisher"
fi
