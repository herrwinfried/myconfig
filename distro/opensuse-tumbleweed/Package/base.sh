#!/bin/bash

Package_a="neofetch screenfetch hwinfo htop ffmpeg zsh zsh fish bash-completion git git-lfs curl wget lsb-release opi lzip unzip unrar e2fsprogs nano"
Package_a_Flatpak="flathub org.gtk.Gtk3theme.Adwaita-dark org.kde.KStyle.Adwaita//6.5 org.kde.PlatformTheme.QGnomePlatform//6.5"
if ! checkwsl ; then
Package_a_Flatpak+=" org.telegram.desktop io.github.mimbrero.WhatsAppDesktop im.riot.Riot"
fi

Package_a_Flatpak2="kdeapps org.kde.xwaylandvideobridge"

Package_b="brave-browser microsoft-edge-stable fetchmsttfonts powerline-fonts java-19-openjdk"

if ! checkwsl ; then
Package_b+=" discord flameshot AdobeICCProfiles anydesk noisetorch memtest86+"
fi

Package_c="pinta lutris minetest gamemoded libgamemode0 libgamemodeauto0"
Package_c_Flatpak="flathub org.onlyoffice.desktopeditors com.usebottles.bottles com.obsproject.Studio com.github.tchx84.Flatseal com.authy.Authy"




sudo $Package $PackageInstall $Package_a
sudoreq
sudo $FlatpakPackage $FlatpakPackageInstall $Package_a_Flatpak
sudoreq
sudo $FlatpakPackage $FlatpakPackageInstall $Package_a_Flatpak2

sudoreq
sudo $Package $PackageInstall $Package_b

#NOT WSL
if ! checkwsl ; then
sudoreq
sudo $Package $PackageInstall $Package_c
sudoreq
sudo $FlatpakPackage $FlatpakPackageInstall $Package_c_Flatpak
fi
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
