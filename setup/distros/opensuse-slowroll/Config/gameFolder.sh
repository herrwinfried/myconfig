#!/bin/bash

if ! isWsl; then
CreateDirectory /$HOME/Games folder-database
CreateDirectory /$HOME/Games/Prefix folder-windows

CreateDirectory /$HOME/Games/Prefix/compatdata steam
CreateDirectory /$HOME/Games/Prefix/Bottles com.usebottles.bottles-program
CreateDirectory /$HOME/Games/Prefix/Heroic com.heroicgameslauncher.hgl
CreateDirectory /$HOME/Games/Prefix/Lutris net.lutris.Lutris

CreateDirectory /$HOME/Games/Documents/ applications-games
CreateDirectory "/$HOME/Games/Saved Games" geany-save-all-symbolic
CreateDirectory /$HOME/Games/MangoHud/ io.github.flightlessmango.mangohud
ln -sf "/$HOME/.steam/steam" "/$HOME/Games/Root Steam"
ln -sf /$HOME/Games/Documents/ /$HOME/Games/ProtonDocuments
fi