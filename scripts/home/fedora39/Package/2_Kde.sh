#!/bin/bash

if ! checkwsl; then

    #    Disk manager, Clock App, colord, Audio Recorder, Photo Browser
    packageKDE="kde-partitionmanager kclock colord-kde krecorder koko"

    #  Mass renaming, Patch changes, Calendar, KDE Connect, Advanced Text Editor
    packageKDE+=" krename kdiff3 merkuro kdeconnectd kate"

    #   Search App, GPG GUI, Camera, Google Drive, discover flatpak support
    packageKDE+=" kfind kleopatra kamoso kio-gdrive plasma-discover-flatpak"

    #  Photo Browser, Matrix Client, RDP/VNC Remote Viewer, VNC Desktop Sharing, Color Picker
    packageKDE+=" gwenview neochat krdc krfb kcolorchooser"

    #   Paint(Like WinXP), Music Player, Dolphin extra plugin, nextcloud images for dolphin
    packageKDE+=" kolourpaint elisa-player dolphin-plugins nextcloud-client-dolphin"

    # Video edit
    packageKDE+=" kdenlive",

    #   KDevelop App, KDevelop Additional Plugin Support, KDevelop PHP Plugin, KDevelop Python Plugin
            #packageKDE+=" kdevelop kdevelop-pg-qt kdevelop-php"

    #   Icon Editor, HeX Editor
            #packageKDE+=" okteta ikona"

    SUDO $Package $PackageInstall $packageKDE
fi
