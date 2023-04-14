#!/bin/bash

### Root
#cd $ScriptLocal/data/home; cp -r * /root/; cp -r .* /root/
mkdir -p /root/.config
mkdir -p /root/.config/powershell
cp -r $ScriptLocal/data/home/.alias* /root/
cp -r $ScriptLocal/data/home/.config /root/.config

sudo ln -sf $HomePWD/.poshthemes /root/.poshthemes

if [ ! -f "/root/.bashrc" ]; then
sudo cp $ScriptLocal/data/home/.bashrc /root/.bashrc
fi

if [ ! -f "/root/.zshrc" ]; then
sudo cp $ScriptLocal/data/home/.zshrc /root/.zshrc
fi

###USER
#su -l $home -c "cd $ScriptLocal/data/home; cp -r * $HomePWD/; cp -r .* $HomePWD/"
su -l $home -c "mkdir -p $HomePWD/.config"
su -l $home -c "mkdir -p $HomePWD/.config/powershell"
su -l $home -c "cp -r $ScriptLocal/data/home/.alias* $HomePWD"
su -l $home -c "cp -r $ScriptLocal/data/home/.config $HomePWD/.config"
su -l $home -c "mkdir -p $HomePWD/.poshthemes"
su -l $home -c "cp -r $ScriptLocal/data/default.omp.json $HomePWD/.poshthemes"

su -l $home -c "mkdir -p $HomePWD/source"

su -l $home -c "ln -s /opt/lampp/htdocs $HomePWD/lamppHtdocs"

if [ ! -f "$HomePWD/.bashrc" ]; then
su -l $home -c "cp $ScriptLocal/data/home/.bashrc $HomePWD/.bashrc"
fi

if [ ! -f "$HomePWD/.zshrc" ]; then
su -l $home -c "cp $ScriptLocal/data/home/.zshrc $HomePWD/.zshrc"
fi