#!/bin/bash

if ! CheckWsl; then

    #    Disk manager, Clock App, colord, Audio Recorder, Photo Browser
    packageKDE="kde-partitionmanager kclock colord-kde krecorder koko"

    #  Mass renaming, Patch changes, Calendar, KDE Connect, Advanced Text Editor
    packageKDE+=" krename kdiff3 merkuro kdeconnect-kde kate"

    #   Search App, GPG GUI, Camera, Google Drive, discover flatpak support
    packageKDE+=" kfind kleopatra kamoso kio-gdrive discover-backend-flatpak"

    #  Photo Browser, Matrix Client, Color Picker, Sound Mixer
    packageKDE+=" gwenview neochat kcolorchooser kmix"

    #   Paint(Like WinXP), Music Player, Dolphin extra plugin, nextcloud images for dolphin
    packageKDE+=" kolourpaint elisa dolphin-plugins nextcloud-desktop-dolphin"

    # Video edit , Kde System Settings for RDP, Screen Sharing for VNC
    packageKDE+=" kdenlive krdp krfb"

    SUDO $Package $PackageInstall $packageKDE
fi
