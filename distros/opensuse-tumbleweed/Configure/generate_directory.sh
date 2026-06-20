#!/usr/bin/env bash
# Configure/generate_directory.sh — Create project and game directory structure
# CreateDirectory function is defined in lib/utils.sh.
set -euo pipefail

# Source code directories
CreateDirectory "$HOME/source" folder-build
CreateDirectory "$HOME/source/gitlab"
CreateDirectory "$HOME/source/github"
CreateDirectory "$HOME/source/local"

# Video directories
CreateDirectory "${XDG_VIDEOS_DIR:-$HOME/Videos}/OBS"
CreateDirectory "${XDG_VIDEOS_DIR:-$HOME/Videos}/Kdenlive"
CreateDirectory "${XDG_VIDEOS_DIR:-$HOME/Videos}/davinci"

# Game directories
CreateDirectory "$HOME/Games" folder-database
CreateDirectory "$HOME/Games/Prefix" folder-windows

CreateDirectory "$HOME/Games/Prefix/compatdata" steam
CreateDirectory "$HOME/Games/Prefix/Bottles" com.usebottles.bottles-program
CreateDirectory "$HOME/Games/Prefix/Heroic" com.heroicgameslauncher.hgl
CreateDirectory "$HOME/Games/Prefix/Lutris" net.lutris.Lutris

CreateDirectory "$HOME/Games/Documents/" applications-games
CreateDirectory "$HOME/Games/Saved Games" geany-save-all-symbolic
CreateDirectory "$HOME/Games/MangoHud/" io.github.flightlessmango.mangohud

# Symbolic links
ln -sf "$HOME/.steam/steam" "$HOME/Games/Root Steam"
ln -sf "$HOME/Games/Documents/" "$HOME/Games/ProtonDocuments"