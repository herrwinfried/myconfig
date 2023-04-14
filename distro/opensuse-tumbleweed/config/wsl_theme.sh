#!/bin/bash
if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" == "0xffffffff" ]; then

mkdir -p themeconfig
cd themeconfig

sudo zypper in -y libsass-3_6_5-1 sassc libostree appstream-glib
git clone https://github.com/vinceliuice/Fluent-gtk-theme.git
cd Fluent-gtk-theme
 ./install.sh -t -all -c -s -i
 ./install.sh --tweaks round
 ./install.sh --tweaks blur
 ./install.sh --tweaks square


cd ..
################
git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
cd Tela-circle-icon-theme
 ./install.sh -a
cd ..
###############
git clone https://github.com/vinceliuice/Fluent-icon-theme.git
cd Fluent-icon-theme
 ./install.sh -a -r
cd ..
###############

cd Fluent-icon-theme
cd cursors
 ./install.sh
cd ../..

sleep 3

gsettings set org.gnome.desktop.interface cursor-theme Fluent-cursors
gsettings set org.gnome.desktop.interface gtk-theme Fluent-Dark
gsettings set org.gnome.desktop.interface icon-theme Fluent-dark
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

su -l $home -c "gsettings set org.gnome.desktop.interface cursor-theme Fluent-cursors"
su -l $home -c "gsettings set org.gnome.desktop.interface gtk-theme Fluent-Dark"
su -l $home -c "gsettings set org.gnome.desktop.interface icon-theme Fluent-dark"
su -l $home -c 'gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"'


sudo cp $ScriptLocal/data/wsl.conf /etc/wsl.conf

fi