#!/bin/bash

if ! checkwsl; then

mkdir -p $USERHOME/Games
create_desktop_entry $USERHOME/Games folder-database

mkdir -p $USERHOME/Games/Heroic
mkdir -p $USERHOME/Games/SteamData
mkdir -p $USERHOME/Games/Lutris

mkdir -p $USERHOME/Games/ProtonDocuments/
create_desktop_entry $USERHOME/Games/ProtonDocuments/ applications-games

fi