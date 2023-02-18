#!/bin/bash

if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" == "0xffffffff" ]; then

function one {
package1="neofetch screenfetch hwinfo htop ffmpeg zsh git git-lfs curl wget lsb-release opi lzip unzip e2fsprogs nano"
sudo $PackageName $PackageInstall $package1
}
function two {
package2="brave-browser fetchmsttfonts powerline-fonts AdobeICCProfiles"
sudo $PackageName $PackageInstall $package2
}
###########################
#what i want downloaded first...
one
#what i want downloaded two...
two


elif [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then

function one {
package1="neofetch screenfetch hwinfo htop ffmpeg zsh git git-lfs curl wget lsb-release opi lzip unzip e2fsprogs nano"
packageFlatpak="org.telegram.desktop io.github.mimbrero.WhatsAppDesktop"
sudo $PackageName $PackageInstall $package1
sudo $FlatpakInstall $packageFlatpak
}
function two {
package2="discord brave-browser flameshot fetchmsttfonts powerline-fonts AdobeICCProfiles"
sudo $PackageName $PackageInstall $package2
}
function other {
package3="pinta lutris minetest steam gamemoded libgamemode0 libgamemodeauto0 obs-studio kdenlive"
packageFlatpak="org.onlyoffice.desktopeditors com.usebottles.bottles org.gtk.Gtk3theme.Adwaita-dark"
packageSnap="termius-app authy"
sudo $PackageName $PackageInstall $package3
sudo $FlatpakInstall $packageFlatpak
sudo $SnapInstall $packageSnap

sudo flatpak override --filesystem=/usr/share/themes/
sudo flatpak override --env GTK_THEME=Adwaita-dark
}

###########################
#what i want downloaded first...
one
#what i want downloaded two...
two
other


fi