#!/bin/bash

if ! checkwsl; then

    #    Disk manager, Clock App, colord, Audio Recorder, Video Player
    packageKDE="partitionmanager kclock colord-kde krecorder dragonplayer"

    #  Mass renaming, Patch changes, Calendar, KDE Connect, Advanced Text Editor
    packageKDE+=" krename kdiff3 kalendar kdeconnect-kde kate"

    #   Search App, GPG GUI, Camera, Google Drive, discover flatpak support
    packageKDE+=" kfind kleopatra kamoso kio-gdrive discover-backend-flatpak"

    #   Paint(Like WinXP), Music Player, Dolphin extra plugin, nextcloud images for dolphin
    packageKDE+=" kolourpaint elisa dolphin-plugins nextcloud-desktop-dolphin"

    #   KDevelop App, KDevelop Additional Plugin Support, KDevelop PHP Plugin, KDevelop Python Plugin
    packageKDE+=" kdevelop5 kdevelop5-pg-qt kdevelop5-plugin-php kdevelop5-plugin-python3"

    sudo $Package $PackageInstall $packageKDE
fi
