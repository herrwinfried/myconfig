#!/bin/bash

SUDO chmod +x $ScriptFolder1/dotfiles/scripts/*
SUDO cp -rf $ScriptFolder1/dotfiles/scripts/* /usr/local/bin/

if [ -f "$HomePWD/.config/MangoHud/MangoHud.conf" ]; then
/usr/local/bin/MangoHud-Switch
fi