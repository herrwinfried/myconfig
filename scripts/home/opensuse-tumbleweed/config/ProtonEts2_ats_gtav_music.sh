#!/bin/bash

if ! checkwsl; then

mkdir -p $XDG_MUSIC_DIR/game_music

mkdir -p "$HomePWD/Documents/Euro Truck Simulator 2"
mkdir -p "$HomePWD/Documents/American Truck Simulator"

mkdir -p "$HomePWD/Documents/Rockstar Games"
mkdir -p "$HomePWD/Documents/Rockstar Games/GTA V"

if [ -d "$HomePWD/Games/ProtonDocuments/Euro Truck Simulator 2/music" ]; then
    rm -rf "$HomePWD/Games/ProtonDocuments/Euro Truck Simulator 2/music"
fi

if [ -d "$HomePWD/Games/ProtonDocuments/American Truck Simulator/music" ]; then
    rm -rf "$HomePWD/Games/ProtonDocuments/American Truck Simulator/music"
fi

if [ -d "$HomePWD/Games/ProtonDocuments/Rockstar Games/GTA V/User Music" ]; then
    rm -rf "$HomePWD/Games/ProtonDocuments/Rockstar Games/GTA V/User Music"
fi

ln -sf "$XDG_MUSIC_DIR/game_music" "$HomePWD/Games/ProtonDocuments/American Truck Simulator/music"
ln -sf "$XDG_MUSIC_DIR/game_music" "$HomePWD/Games/ProtonDocuments/Euro Truck Simulator 2/music"
ln -sf "$XDG_MUSIC_DIR/game_music" "$HomePWD/Games/ProtonDocuments/Rockstar Games/GTA V/User Music"
fi