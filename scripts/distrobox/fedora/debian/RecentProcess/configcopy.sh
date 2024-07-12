#!/bin/bash
MAINUSERHOME="$USERHOME/../"
mkdir -p $MAINUSERHOME/distrobox/config
cp -rf $MAINUSERHOME/.config/{gtk-3.0,gtk-4.0,gtkrc-2.0,gtkrc,kdeglobals,systemsettingsrc} $MAINUSERHOME/distrobox/config
cp -rf $MAINUSERHOME/distrobox/config/* ~/.config