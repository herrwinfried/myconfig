#!/bin/bash

if ! checkwsl; then

    #    Disk manager, Clock App, colord, Audio Recorder, Video Player
    packageKDE="kde-partitionmanager kclock colord-kde krecorder dragon"

    #  Mass renaming, Patch changes, Calendar, KDE Connect, Advanced Text Editor
    packageKDE+=" krename kdiff3 kalendar kdeconnectd kate"

    #   Search App, GPG GUI, Camera, Google Drive, discover flatpak support
    packageKDE+=" kfind kleopatra kamoso kio-gdrive plasma-discover-flatpak"

    #   Paint(Like WinXP), Music Player, Dolphin extra plugin, nextcloud images for dolphin
    packageKDE+=" kolourpaint elisa-player dolphin-plugins nextcloud-client-dolphin"

    #   KDevelop App, KDevelop Additional Plugin Support, KDevelop PHP Plugin, QT HEIF Support
    packageKDE+=" kdevelop5 kdevelop5-pg-qt kdevelop5-php qt-heif-image-plugin"

    sudo $Package $PackageInstall $packageKDE
fi
