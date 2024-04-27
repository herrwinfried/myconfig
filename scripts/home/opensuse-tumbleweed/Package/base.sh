#!/bin/bash

Base="hwinfo screenfetch neofetch htop curl wget zsh fish opi nano"
Base+=" lsb-release e2fsprogs java-22-openjdk rsync"
Base+=" bash-completion wl-clipboard jq"
Base+=" fetchmsttfonts powerline-fonts google-noto-sans*"
Base_Flatpak="flathub org.gtk.Gtk3theme.Breeze org.gtk.Gtk3theme.Adwaita-dark org.kde.KStyle.Adwaita//6.6 org.kde.PlatformTheme.QGnomePlatform//6.6"
Base_Flatpak+=" com.github.tchx84.Flatseal"
if ! CheckWsl; then
    Base+=" memtest86+ xwaylandvideobridge AdobeICCProfiles"
    Remote="anydesk teamviewer-suse"
fi


Browser_Office="brave-browser microsoft-edge-stable libreoffice libreoffice-l10n-tr poppler-tools"
Browser_Office_Flatpak="flathub org.onlyoffice.desktopeditors"
if CheckWsl; then
    Browser_Office+=" libreoffice-gnome libreoffice-gtk3"
fi

if ! CheckWsl; then
    Virtualization="libguestfs libguestfs-appliance qemu libvirt patterns-server-kvm_server patterns-server-kvm_tools virtualbox"
    Printer="patterns-server-printing skanlite cups cups-client cups-filters cups-airprint system-config-printer hplip"
    Tool_Game="mangohud mangohud-32bit goverlay gamemode steam protontricks qbittorrent"
    Tool_Game_Flatpak="flathub net.lutris.Lutris com.usebottles.bottles com.heroicgameslauncher.hgl"
    Tool_Game_Flatpak+=" io.github.trigg.discover_overlay net.davidotek.pupgui2 org.freedesktop.Platform.VulkanLayer.MangoHud//23.08"

    Social_Flatpak="flathub org.telegram.desktop io.github.mimbrero.WhatsAppDesktop"

    Other="pinta yandex-disk onedrive"
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
