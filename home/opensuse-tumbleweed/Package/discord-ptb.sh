#!/bin/bash

if ! checkwsl; then

    sudo $Package $PackageInstall curl tar

    echo "[Desktop Entry]
Name=Discord PTB
StartupWMClass=discord
Comment=All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.
GenericName=Internet Messenger
Exec=/opt/DiscordPTB/DiscordPTB
Icon=discord-ptb
Type=Application
Categories=Network;InstantMessaging;
Path=/opt/DiscordPTB" | sudo tee /usr/share/applications/discord-ptb.desktop

    curl -L "https://discord.com/api/download/ptb?platform=linux&format=tar.gz" -o /tmp/discordptb.tar.gz
    
    sudo mkdir -p /opt/DiscordPTB
    sudo tar -xzf /tmp/discordptb.tar.gz -C /opt/
    sudo chmod 777 /opt/DiscordPTB
    sudo chmod 777 /opt/DiscordPTB/*

fi
