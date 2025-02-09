#!/bin/bash

if ! CheckWsl && [ "$(echo $XDG_CURRENT_DESKTOP | tr '[:upper:]' '[:lower:]')" = "kde" ]; then

    #    Disk manager, Clock App, colord, Audio Recorder
    packageKDE="partitionmanager kclock colord-kde krecorder"

    #  Mass renaming, Patch changes, Calendar, KDE Connect, Advanced Text Editor
    packageKDE+=" krename kdiff3 merkuro kdeconnect-kde kate"

    #   Search App, GPG GUI, Camera, Google Drive, discover flatpak support
    packageKDE+=" kfind kleopatra kamoso kio-gdrive discover-backend-flatpak"

    #  Photo Browser, Color Picker, Sound Mixer
    packageKDE+=" gwenview kcolorchooser kmix"

    #   Paint(Like WinXP), Music Player, Dolphin extra plugin, nextcloud images for dolphin
    packageKDE+=" kolourpaint elisa dolphin-plugins nextcloud-desktop-dolphin"

    # Video edit , KDE Games, File Usage viewer, Flatpak Theme xdg desktop portal
    packageKDE+=" kdenlive patterns-kde-kde_games filelight qt6-platformtheme-xdgdesktopportal"

    SUDO $Package $PackageInstall $packageKDE
fi
