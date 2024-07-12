#!/bin/bash

Base="hwinfo fastfetch htop curl wget zsh fish nano"
Base+=" redhat-lsb-core java-21-openjdk rsync"
Base+=" bash-completion wl-clipboard jq"
Base_Flatpak="flathub org.gtk.Gtk3theme.Breeze org.gtk.Gtk3theme.Adwaita-dark org.kde.KStyle.Adwaita//6.6 org.kde.PlatformTheme.QGnomePlatform//6.6"
Base_Flatpak+=" com.github.tchx84.Flatseal"
if ! CheckWsl; then
    Base+=" wine-fonts $(echo google-noto-{sans,serif,emoji}\*fonts)"
    Base+=" memtest86+ xwaylandvideobridge colord-extra-profiles"
    
    Remote="teamviewer"
    Remote_Flatpak="flathub com.anydesk.Anydesk org.remmina.Remmina"
fi

Browser_Office="poppler-utils"

if ! CheckWsl; then
    Browser_Office+=" brave-browser microsoft-edge-stable $(echo libreoffice-{base,writer,calc,impress,math,langpack-tr})"
    Browser_Office_Flatpak="flathub org.onlyoffice.desktopeditors"
    Virtualization="$(echo libguestfs{,-appliance}) $(echo qemu{,-kvm}) libvirt @virtualization virtualbox"
    Printer="skanlite $(echo cups{,-filters}) avahi system-config-printer hplip"
    Tool_Game="mangohud goverlay gamemode steam protontricks"
    Tool_Game_Flatpak="flathub net.lutris.Lutris com.usebottles.bottles com.heroicgameslauncher.hgl"
    Tool_Game_Flatpak+=" io.github.trigg.discover_overlay net.davidotek.pupgui2 org.freedesktop.Platform.VulkanLayer.MangoHud//23.08"
    Tool_Game_Flatpak+=" org.freedesktop.Sdk.Extension.openjdk21//23.08 org.prismlauncher.PrismLauncher"

    Social_Flatpak="flathub org.telegram.desktop io.github.mimbrero.WhatsAppDesktop"

    Other="pinta yandex-disk onedrive @vlc"
    Other_Flatpak="flathub com.obsproject.Studio com.github.wwmm.easyeffects com.stremio.Stremio"

fi

BasePackageInstall "$Base"
BasePackageFlatpakInstall "$Base_Flatpak"

BasePackageInstall "$Remote"
BasePackageFlatpakInstall "$Remote_Flatpak"

BasePackageInstall "$Browser_Office"
BasePackageFlatpakInstall "$Browser_Office_Flatpak"

BasePackageInstall "$Social"
BasePackageFlatpakInstall "$Social_Flatpak"

BasePackageInstall "$Tool_Game"
BasePackageFlatpakInstall "$Tool_Game_Flatpak"

BasePackageInstall "$Other"
BasePackageFlatpakInstall "$Other_Flatpak"

BasePackageInstall "$Printer"

BasePackageInstall "$Virtualization"