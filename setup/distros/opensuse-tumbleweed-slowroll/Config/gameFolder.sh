#!/bin/bash

if ! isWsl; then

mkdir -p /$HOME/Games
CreateDesktopEntry /$HOME/Games folder-database

mkdir -p /$HOME/Games/Bottles
CreateDesktopEntry /$HOME/Games/Bottles com.usebottles.bottles-program
mkdir -p /$HOME/Games/Heroic
CreateDesktopEntry /$HOME/Games/Heroic com.heroicgameslauncher.hgl
mkdir -p /$HOME/Games/SteamData
CreateDesktopEntry /$HOME/Games/SteamData steam
mkdir -p /$HOME/Games/Lutris
CreateDesktopEntry /$HOME/Games/Lutris net.lutris.Lutris

mkdir -p /$HOME/Games/ProtonDocuments/
CreateDesktopEntry /$HOME/Games/ProtonDocuments/ applications-games
mkdir -p /$HOME/Games/MangoHud/
fi