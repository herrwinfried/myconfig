#!/bin/bash

chmod 771 $ScriptFolder1/data/scripts/*
SUDO cp -rf $ScriptFolder1/data/scripts/* /usr/local/bin/

if [ -f "$USERHOME/.config/MangoHud/MangoHud.conf" ]; then
sleep 2
cd .
sleep 2
/usr/local/bin/MangoHud-Switch
fi