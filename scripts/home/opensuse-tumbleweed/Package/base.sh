#!/bin/bash

Package_a="hwinfo screenfetch neofetch htop git git-lfs curl wget"
Package_a+=" zsh bash-completion fish lsb-release opi e2fsprogs nano"
Package_a+=" lzip unrar unzip java-20-openjdk"

Package_a_Flatpak="flathub org.gtk.Gtk3theme.Breeze org.gtk.Gtk3theme.Adwaita-dark org.kde.KStyle.Adwaita//6.5 org.kde.PlatformTheme.QGnomePlatform//6.5"
Package_a_Flatpak2="kdeapps org.kde.xwaylandvideobridge"

Package_b="brave-browser microsoft-edge-stable fetchmsttfonts powerline-fonts"
Package_c="pinta minetest gamemoded libgamemode0 libgamemodeauto0 mangohud mangohud-32bit goverlay"
Package_c_Flatpak="flathub org.onlyoffice.desktopeditors com.obsproject.Studio com.github.tchx84.Flatseal com.authy.Authy im.riot.Riot"
Package_c_Flatpak+=" org.freedesktop.Platform.VulkanLayer.MangoHud//22.08 org.freedesktop.Platform.VulkanLayer.MangoHud//21.08"


if ! checkwsl; then   
    Package_a_Flatpak+=" org.telegram.desktop io.github.mimbrero.WhatsAppDesktop"
    
    Package_b+=" discord flameshot AdobeICCProfiles anydesk teamviewer-suse noisetorch memtest86+ python311-pipx"

    Package_d_Flatpak="flathub com.valvesoftware.Steam net.lutris.Lutris com.usebottles.bottles com.heroicgameslauncher.hgl io.github.trigg.discover_overlay net.davidotek.pupgui2"
    Package_d_Flatpak+=" com.valvesoftware.Steam.CompatibilityTool.Proton com.valvesoftware.Steam.CompatibilityTool.Proton-GE com.valvesoftware.Steam.Utility.MangoHud"
fi
$SUDO $Package $PackageInstall $Package_a

$SUDO $FlatpakPackage $FlatpakPackageInstall $Package_a_Flatpak


#NOT WSL
if ! checkwsl; then
    $SUDO $FlatpakPackage $FlatpakPackageInstall $Package_a_Flatpak2
fi
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


$SUDO $Package $PackageInstall $Package_b
#NOT WSL
if ! checkwsl; then
    
    $SUDO $Package $PackageInstall $Package_c
    
    $SUDO $FlatpakPackage $FlatpakPackageInstall $Package_c_Flatpak
    
    $SUDO $FlatpakPackage $FlatpakPackageInstall $Package_d_Flatpak
fi
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^