#!/bin/bash
Package_a="hwinfo screenfetch neofetch htop git git-lfs curl wget"
Package_a+=" zsh bash-completion fish lsb-release opi e2fsprogs nano"
Package_a+=" lzip unrar unzip java-20-openjdk"

Package_a_Flatpak="flathub org.gtk.Gtk3theme.Adwaita-dark org.kde.KStyle.Adwaita//6.5 org.kde.PlatformTheme.QGnomePlatform//6.5"
Package_a_Flatpak2="kdeapps org.kde.xwaylandvideobridge"

Package_b="brave-browser microsoft-edge-stable fetchmsttfonts powerline-fonts"
Package_c="pinta minetest gamemoded libgamemode0 libgamemodeauto0"
Package_c_Flatpak="flathub org.onlyoffice.desktopeditors com.obsproject.Studio com.github.tchx84.Flatseal com.authy.Authy"

Package_d_Flatpak="flathub com.valvesoftware.Steam com.valvesoftware.Steam.CompatibilityTool.Proton com.valvesoftware.Steam.CompatibilityTool.Proton-GE net.lutris.Lutris com.usebottles.bottles com.heroicgameslauncher.hgl"
if ! checkwsl; then
    Package_a_Flatpak+=" org.telegram.desktop io.github.mimbrero.WhatsAppDesktop im.riot.Riot"
    Package_b+=" discord flameshot AdobeICCProfiles anydesk teamviewer-suse noisetorch memtest86+"
fi

sudoreq
sudo $Package $PackageInstall $Package_a
sudoreq
sudo $FlatpakPackage $FlatpakPackageInstall $Package_a_Flatpak
sudoreq

#NOT WSL
if ! checkwsl; then
    sudo $FlatpakPackage $FlatpakPackageInstall $Package_a_Flatpak2
fi
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

sudoreq
sudo $Package $PackageInstall $Package_b
#NOT WSL
if ! checkwsl; then
    sudoreq
    sudo $Package $PackageInstall $Package_c
    sudoreq
    sudo $FlatpakPackage $FlatpakPackageInstall $Package_c_Flatpak
    sudoreq
    sudo $FlatpakPackage $FlatpakPackageInstall $Package_d_Flatpak
fi
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^