#!/bin/bash

if ! checkwsl; then
mkdir -p $HomePWD/Games
echo -e "[Desktop Entry]\nIcon=folder-database" | tee $HomePWD/Games/.directory
mkdir -p $HomePWD/Games/Heroic
mkdir -p $HomePWD/Games/SteamData
mkdir -p $HomePWD/Games/Lutris

mkdir -p $HomePWD/Games/ProtonDocuments/
echo -e "[Desktop Entry]\nIcon=applications-games" | tee $HomePWD/Games/ProtonDocuments/.directory

echo -e "#!/bin/bash\nsource=\$1\nScriptFolder=\$(cd -- \"\$(dirname -- \"\${BASH_SOURCE[0]}\")\" &>/dev/null && pwd)\nif [[ -z \$source ]]; then\n  if [[ -d \"/run/media/winfried/OS/Users/winfried/Documents\" ]]; then\n    source=\"/run/media/winfried/OS/Users/winfried/Documents\"\n  else\n    echo \"HATA! \$source BULUNAMADI\"\n    exit 1\n  fi\nfi\n\nif [[ ! -z \$source ]]; then\necho \$ScriptFolder\ncp -rf \"\$source\"/* \"\$ScriptFolder\"\nfi" | tee $HomePWD/Games/ProtonDocuments/WindowsDocumentsCopy.sh
echo -e "#!/bin/bash\nsource \${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs\nmkdir -p \$XDG_MUSIC_DIR/game_music\n\nif [ -d \"\$HOME/Games/ProtonDocuments/Euro Truck Simulator 2/music\" ]; then\n  rm -rf \"\$HOME/Games/ProtonDocuments/Euro Truck Simulator 2/music\"\nfi\n\nif [ -d \"\$HOME/Games/ProtonDocuments/American Truck Simulator/music\" ]; then\n  rm -rf \"\$HOME/Games/ProtonDocuments/American Truck Simulator/music\"\nfi\n\nif [ -d \"\$HOME/Games/ProtonDocuments/Rockstar Games/GTA V/User Music\" ]; then\n  rm -rf \"\$HOME/Games/ProtonDocuments/Rockstar Games/GTA V/User Music\"\nfi\n\nln -sf \"\$XDG_MUSIC_DIR/game_music\" \"\$HOME/Games/ProtonDocuments/American Truck Simulator/music\"\nln -sf \"\$XDG_MUSIC_DIR/game_music\" \"\$HOME/Games/ProtonDocuments/Euro Truck Simulator 2/music\"\nln -sf \"\$XDG_MUSIC_DIR/game_music\" \"\$HOME/Games/ProtonDocuments/Rockstar Games/GTA V/User Music\"" | tee $HomePWD/Games/ProtonDocuments/ets2_ats_gtav_music_link.sh

SUDO chattr +i $HomePWD/Games/ProtonDocuments/ets2_ats_gtav_music_link.sh
SUDO chattr +i $HomePWD/Games/ProtonDocuments/WindowsDocumentsCopy.sh

fi