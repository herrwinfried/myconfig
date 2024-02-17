#!/bin/bash

Package_a="hwinfo screenfetch neofetch htop git git-lfs curl wget"
Package_a+=" zsh bash-completion fish redhat-lsb-core e2fsprogs nano"
Package_a+=" lzip unrar unzip java-latest-openjdk"
Package_a+=" rsync python3-pip"

Package_a_Flatpak="flathub org.gtk.Gtk3theme.Breeze org.gtk.Gtk3theme.Adwaita-dark org.kde.KStyle.Adwaita//6.5 org.kde.PlatformTheme.QGnomePlatform//6.5"
Package_a_Flatpak2="kdeapps org.kde.xwaylandvideobridge"

Package_b="brave-browser microsoft-edge-stable powerline-fonts"
Package_b+=" libreoffice libreoffice-langpack-tr poppler"

Package_c="pinta minetest gamemode mangohud.x86_64 mangohud.i686 goverlay"
Package_c_Flatpak="flathub org.onlyoffice.desktopeditors com.obsproject.Studio com.github.tchx84.Flatseal com.authy.Authy im.riot.Riot"
Package_c_Flatpak+=" org.freedesktop.Platform.VulkanLayer.MangoHud//23.08"

if checkwsl; then
Package_b+=" libreoffice-gtk3 libreoffice-gtk4"
fi

if ! checkwsl; then   
    Package_a_Flatpak+=" org.telegram.desktop io.github.mimbrero.WhatsAppDesktop com.github.wwmm.easyeffects"
    
    Package_b+=" discord flameshot colord-extra-profiles teamviewer rnnoise noisetorch memtest86+ waydroid"
    Package_c+=" steam protontricks"
    Package_d_Flatpak="flathub com.anydesk.Anydesk net.lutris.Lutris com.usebottles.bottles com.heroicgameslauncher.hgl io.github.trigg.discover_overlay net.davidotek.pupgui2"

fi
SUDO $Package $PackageInstall $Package_a

SUDO $FlatpakPackage $FlatpakPackageInstall $Package_a_Flatpak


#NOT WSL
if ! checkwsl; then
    SUDO $FlatpakPackage $FlatpakPackageInstall $Package_a_Flatpak2
fi
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


SUDO $Package $PackageInstall $Package_b
#NOT WSL
if ! checkwsl; then
    
    SUDO $Package $PackageInstall $Package_c
    
    SUDO $FlatpakPackage $FlatpakPackageInstall $Package_c_Flatpak
    
    SUDO $FlatpakPackage $FlatpakPackageInstall $Package_d_Flatpak
fi
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
