#!/bin/bash

function a {

package="neofetch screenfetch hwinfo htop ffmpeg zsh git git-lfs curl wget lsb-release opi lzip unzip e2fsprogs nano"

if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" == "0xffffffff" ]; then
sudo $PackageName $PackageInstall $package
 
elif [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
packageFlatpak="org.telegram.desktop io.github.mimbrero.WhatsAppDesktop im.riot.Riot"
sudo $PackageName $PackageInstall $package
sudo $FlatpakInstall $packageFlatpak

sudo flatpak install -y kdeapps org.kde.xwaylandvideobridge

fi
}

function b {
package="brave-browser microsoft-edge-stable fetchmsttfonts powerline-fonts"
if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" == "0xffffffff" ]; then
sudo $PackageName $PackageInstall $package

elif [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
packageList+=" discord flameshot AdobeICCProfiles anydesk"
sudo $PackageName $PackageInstall $package

fi
}

function c {
if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
package="pinta lutris minetest gamemoded libgamemode0 libgamemodeauto0 obs-studio kdenlive"
packageFlatpak="org.onlyoffice.desktopeditors com.usebottles.bottles org.gtk.Gtk3theme.Adwaita-dark"
packageSnap="termius-app authy"

sudo $PackageName $PackageInstall $package
sudo $FlatpakInstall $packageFlatpak
sudo $SnapInstall $packageSnap

sudo flatpak override --filesystem=/usr/share/themes/
sudo flatpak override --env GTK_THEME=Adwaita-dark
fi
}

a
b
c