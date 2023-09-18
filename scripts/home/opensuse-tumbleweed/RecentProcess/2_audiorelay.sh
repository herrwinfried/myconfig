#!/bin/bash

if ! checkwsl; then

    SUDO $Package $PackageInstall curl tar

    if [ -d "/tmp/audiorelay.tar.gz" ]; then
        SUDO rm -rf /tmp/audiorelay*
    fi

    if [ -d "/opt/audiorelay" ]; then
        SUDO rm -rf /opt/audiorelay
    fi
    sleep 3
    curl -L "https://dl.audiorelay.net/setups/linux/audiorelay-0.27.5.tar.gz" -o /tmp/audiorelay.tar.gz
    SUDO mkdir -p /opt/audiorelay
    SUDO tar -xzf /tmp/audiorelay.tar.gz -C /opt/audiorelay

    SUDO touch /usr/share/applications/audiorelay.desktop

    echo "[Desktop Entry]
Name=Audiorelay
StartupWMClass=audiorelay
Comment=Sound server
Exec=/opt/audiorelay/bin/AudioRelay
Icon=/opt/audiorelay/lib/AudioRelay.png
Type=Application
Categories=System
Path=/opt/audiorelay" | SUDO tee /usr/share/applications/audiorelay.desktop

fi
