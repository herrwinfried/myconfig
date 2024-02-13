#!/bin/bash

Package_a="hwinfo screenfetch neofetch htop git git-lfs curl wget"
Package_a+=" zsh bash-completion fish lsb-release opi e2fsprogs nano"
Package_a+=" lzip unrar unzip java-21-openjdk cnf-rs cnf-rs-bash cnf-rs-zsh cnf-rs-locale"
Package_a+=" rsync python311-pip wl-clipboard"

Package_a_Flatpak="flathub org.gtk.Gtk3theme.Breeze org.gtk.Gtk3theme.Adwaita-dark org.kde.KStyle.Adwaita//6.5 org.kde.PlatformTheme.QGnomePlatform//6.5"

Package_b="brave-browser microsoft-edge-stable fetchmsttfonts powerline-fonts"
Package_b+=" libreoffice libreoffice-l10n-tr poppler-tools"

Package_c="pinta minetest gamemoded libgamemode0 libgamemodeauto0 mangohud mangohud-32bit goverlay"
Package_c_Flatpak="flathub org.onlyoffice.desktopeditors com.obsproject.Studio com.github.tchx84.Flatseal com.authy.Authy"
Package_c_Flatpak+=" com.stremio.Stremio com.github.wwmm.easyeffects org.freedesktop.Platform.VulkanLayer.MangoHud//23.08"

if checkwsl; then
Package_b+=" libreoffice-gnome libreoffice-gtk3"
fi

if ! checkwsl; then   
    Package_a_Flatpak+=" org.telegram.desktop io.github.mimbrero.WhatsAppDesktop"
    Package_b+=" xwaylandvideobridge discord flameshot AdobeICCProfiles anydesk teamviewer-suse noisetorch memtest86+"
    Package_c+=" steam protontricks"
    Package_d_Flatpak="flathub net.lutris.Lutris com.usebottles.bottles com.heroicgameslauncher.hgl" 
    Package_d_Flatpak+=" io.github.trigg.discover_overlay net.davidotek.pupgui2"

fi
SUDO $Package $PackageInstall $Package_a

SUDO $FlatpakPackage $FlatpakPackageInstall $Package_a_Flatpak


SUDO $Package $PackageInstall $Package_b
#NOT WSL
if ! checkwsl; then
    
    SUDO $Package $PackageInstall $Package_c
    
    SUDO $FlatpakPackage $FlatpakPackageInstall $Package_c_Flatpak
    
    SUDO $FlatpakPackage $FlatpakPackageInstall $Package_d_Flatpak
fi
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
