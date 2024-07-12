#!/bin/bash

if ! checkwsl; then

mkdir -p $USERHOME/Games
CreateDesktopEntry $USERHOME/Games folder-database

mkdir -p $USERHOME/Games/Bottles
mkdir -p $USERHOME/Games/Heroic
mkdir -p $USERHOME/Games/SteamData
mkdir -p $USERHOME/Games/Lutris

mkdir -p $USERHOME/Games/ProtonDocuments/
CreateDesktopEntry $USERHOME/Games/ProtonDocuments/ applications-games

###############################################################################################################

mkdir -p "$XDG_MUSIC_DIR/game_music"

mkdir -p "$USERHOME/Games/ProtonDocuments/Euro Truck Simulator 2"
mkdir -p "$USERHOME/Games/ProtonDocuments/American Truck Simulator"

mkdir -p "$USERHOME/Games/ProtonDocuments/Rockstar Games"
mkdir -p "$USERHOME/Games/ProtonDocuments/Rockstar Games/GTA V"

if [ -d "$USERHOME/Games/ProtonDocuments/Euro Truck Simulator 2/music" ]; then
    rm -rf "$USERHOME/Games/ProtonDocuments/Euro Truck Simulator 2/music"
fi

if [ -d "$USERHOME/Games/ProtonDocuments/American Truck Simulator/music" ]; then
    rm -rf "$USERHOME/Games/ProtonDocuments/American Truck Simulator/music"
fi

if [ -d "$USERHOME/Games/ProtonDocuments/Rockstar Games/GTA V/User Music" ]; then
    rm -rf "$USERHOME/Games/ProtonDocuments/Rockstar Games/GTA V/User Music"
fi

ln -sf "$XDG_MUSIC_DIR/game_music" "$USERHOME/Games/ProtonDocuments/American Truck Simulator/music"
ln -sf "$XDG_MUSIC_DIR/game_music" "$USERHOME/Games/ProtonDocuments/Euro Truck Simulator 2/music"
ln -sf "$XDG_MUSIC_DIR/game_music" "$USERHOME/Games/ProtonDocuments/Rockstar Games/GTA V/User Music"

cat <<EOF | tee $USERHOME/Games/ProtonDocuments/WindowsDocumentsCopy.sh
#!/bin/bash

source=$1
ScriptFolder=$(cd -- "\$(dirname -- "\${BASH_SOURCE[0]}")" &>/dev/null && pwd)

if [[ -z \$source ]]; then
  if [[ -d "/run/media/winfried/OS/Users/winfried/Documents" ]]; then
    source="/run/media/winfried/OS/Users/winfried/Documents"
  else
    echo "ERROR! Not found \$source"
    exit 1
  fi
fi

if [[ ! -z \$source ]]; then
  echo \$ScriptFolder
  cp -rf "\$source"/* "\$ScriptFolder"
fi
EOF


cat <<EOF | tee $USERHOME/Games/ProtonDocuments/ets2_ats_gtav_music_link.sh
#!/bin/bash

source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs
mkdir -p $XDG_MUSIC_DIR/game_music

if [ -d "$HOME/Games/ProtonDocuments/Euro Truck Simulator 2/music" ]; then
  rm -rf "$HOME/Games/ProtonDocuments/Euro Truck Simulator 2/music"
fi

if [ -d "$HOME/Games/ProtonDocuments/American Truck Simulator/music" ]; then
  rm -rf "$HOME/Games/ProtonDocuments/American Truck Simulator/music"
fi

if [ -d "$HOME/Games/ProtonDocuments/Rockstar Games/GTA V/User Music" ]; then
  rm -rf "$HOME/Games/ProtonDocuments/Rockstar Games/GTA V/User Music"
fi

ln -sf "$XDG_MUSIC_DIR/game_music" "$HOME/Games/ProtonDocuments/American Truck Simulator/music"
ln -sf "$XDG_MUSIC_DIR/game_music" "$HOME/Games/ProtonDocuments/Euro Truck Simulator 2/music"
ln -sf "$XDG_MUSIC_DIR/game_music" "$HOME/Games/ProtonDocuments/Rockstar Games/GTA V/User Music"
EOF

function RUNPERM_CHATTR() {
    SUDO chmod +x "$1"
    SUDO chattr +i "$1"
}

RUNPERM_CHATTR $USERHOME/Games/ProtonDocuments/ets2_ats_gtav_music_link.sh
RUNPERM_CHATTR $USERHOME/Games/ProtonDocuments/WindowsDocumentsCopy.sh

fi