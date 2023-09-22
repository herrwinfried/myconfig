#!/bin/bash

if ! checkwsl; then

    #    Disk manager, Clock App, colord, Audio Recorder, Photo Browser
    packageKDE="partitionmanager kclock colord-kde krecorder koko"

    #  Mass renaming, Patch changes, Calendar, KDE Connect, Advanced Text Editor
    packageKDE+=" krename kdiff3 merkuro kdeconnect-kde kate"

    #   Search App, GPG GUI, Camera, Google Drive, discover flatpak support
    packageKDE+=" kfind kleopatra kamoso kio-gdrive discover-backend-flatpak"

    #  Photo Browser, Matrix Client, RDP/VNC Remote Viewer, VNC Desktop Sharing, Color Picker
    packageKDE+=" gwenview neochat krdc krfb kcolorchooser"

    #   Paint(Like WinXP), Music Player, Dolphin extra plugin, nextcloud images for dolphin
    packageKDE+=" kolourpaint elisa dolphin-plugins nextcloud-desktop-dolphin"

    #   KDevelop App, KDevelop Additional Plugin Support, KDevelop PHP Plugin, KDevelop Python Plugin
            #packageKDE+=" kdevelop5 kdevelop5-pg-qt kdevelop5-plugin-php kdevelop5-plugin-python3"

    #   Icon Editor, HeX Editor
            #packageKDE+=" okteta ikona"

    SUDO $Package $PackageInstall $packageKDE
fi
