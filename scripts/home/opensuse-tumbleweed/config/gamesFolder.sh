#!/bin/bash

if ! checkwsl; then
mkdir -p $HomePWD/Games
echo -e "[Desktop Entry]\nIcon=folder-database" | tee $HomePWD/Games/.directory
mkdir -p $HomePWD/Games/Heroic
mkdir -p $HomePWD/Games/SteamData
mkdir -p $HomePWD/Games/Lutris

mkdir -p $HomePWD/Games/ProtonDocuments/
echo -e "[Desktop Entry]\nIcon=applications-games" | tee $HomePWD/Games/ProtonDocuments/.directory

echo -e "source=\$1\nScriptFolder=\$(cd -- \"\$(dirname -- \"\${BASH_SOURCE[0]}\")\" &>/dev/null && cd .. && pwd)\nif [[ -z \$source ]]; then\n  source=\"/run/media/winfried/OS/Users/winfried/Documents/\"\nelse\ncp -rf \"\$source\" \"\$ScriptFolder\"\nfi" | tee $HomePWD/Games/ProtonDocuments/WindowsDocumentsCopy.sh
echo -e "mkdir -p \$XDG_MUSIC_DIR/game_music\n\nif [ -d \"\$HOME/Games/ProtonDocuments/Euro Truck Simulator 2/music\" ]; then\n  rm -rf \"\$HOME/Games/ProtonDocuments/Euro Truck Simulator 2/music\"\nfi\n\nif [ -d \"\$HOME/Games/ProtonDocuments/American Truck Simulator/music\" ]; then\n  rm -rf \"\$HOME/Games/ProtonDocuments/American Truck Simulator/music\"\nfi\n\nif [ -d \"\$HOME/Games/ProtonDocuments/Rockstar Games/GTA V/User Music\" ]; then\n  rm -rf \"\$HOME/Games/ProtonDocuments/Rockstar Games/GTA V/User Music\"\nfi\n\nln -sf \"\$XDG_MUSIC_DIR/game_music\" \"\$HOME/Games/ProtonDocuments/American Truck Simulator/music\"\nln -sf \"\$XDG_MUSIC_DIR/game_music\" \"\$HOME/Games/ProtonDocuments/Euro Truck Simulator 2/music\"\nln -sf \"\$XDG_MUSIC_DIR/game_music\" \"\$HOME/Games/ProtonDocuments/Rockstar Games/GTA V/User Music\"\n" | tee $HomePWD/Games/ProtonDocuments/ets2_ats_gtav_music_link.sh

fi