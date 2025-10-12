#!/bin/bash

if ! isWsl; then

CreateDirectory /$HOME/Games folder-database
CreateDirectory /$HOME/Games/Bottles com.usebottles.bottles-program
CreateDirectory /$HOME/Games/Heroic com.heroicgameslauncher.hgl
CreateDirectory /$HOME/Games/SteamData steam
CreateDirectory /$HOME/Games/Lutris net.lutris.Lutris
CreateDirectory /$HOME/Games/ProtonDocuments/ applications-games
CreateDirectory /$HOME/Games/MangoHud/
fi