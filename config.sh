#!/bin/bash
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

function file() {

sudo chmod +x script/*
###USER
su -l $home -c "cd $ScriptLocal/data/home; cp -r * $HomePWD/; cp -r .* $HomePWD/"
su -l $home -c "mkdir -p $HomePWD/.config"
su -l $home -c "mkdir -p $HomePWD/.config/powershell"
su -l $home -c "cd $ScriptLocal/data/powershell; cp -r * $HomePWD/.config/powershell/"
su -l $home -c "mkdir -p $HomePWD/.poshthemes"
su -l $home -c "cp -r $ScriptLocal/data/default.omp.json $HomePWD/.poshthemes"

### Root
cd $ScriptLocal/data/home; cp -r * /root/; cp -r .* /root/
mkdir -p /root/.config
mkdir -p /root/.config/powershell
cd $ScriptLocal/data/powershell; cp -r * /root/.config/powershell/

# mkdir -p /root/.poshthemes
# cp -r $ScriptLocal/data/default.omp.json /root/.poshthemes
sudo ln -s $HomePWD/.poshthemes /root/.poshthemes

if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
sudo chmod +x script/*
sudo cp script/* /usr/local/bin/
fi
}

function fonts() {
if [[ -f "MesloLGS NF Bold Italic.ttf" ]]; then
sudo rm -rf /usr/share/fonts/truetype/MesloLGS NF Bold Italic.ttf
fi

if [[ -f "MesloLGS NF Bold.ttf" ]]; then
sudo rm -rf /usr/share/fonts/truetype/MesloLGS NF Bold.ttf
fi

if [[ -f "MesloLGS NF Italic.ttf" ]]; then
sudo rm -rf /usr/share/fonts/truetype/MesloLGS NF Italic.ttf
fi

if [[ -f "MesloLGS NF Regular.ttf" ]]; then
sudo rm -rf /usr/share/fonts/truetype/MesloLGS NF Regular.ttf
fi
##### WGET
if [[ ! -f "MesloLGS NF Bold Italic.ttf" ]]; then
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P /usr/share/fonts/truetype
fi

if [[ ! -f "MesloLGS NF Bold.ttf" ]]; then
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P /usr/share/fonts/truetype
fi

if [[ ! -f "MesloLGS NF Italic.ttf" ]]; then
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P /usr/share/fonts/truetype
fi

if [[ ! -f "MesloLGS NF Regular.ttf" ]]; then
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P /usr/share/fonts/truetype
fi
fc-cache
}

function WSL_Theme() {
mkdir -p themeconfig
cd themeconfig
sudo zypper in -y libsass-3_6_5-1 sassc libostree appstream-glib
git clone https://github.com/vinceliuice/Fluent-gtk-theme.git
cd Fluent-gtk-theme
 ./install.sh -t -all -c -s -i
 ./install.sh --tweaks round
 ./install.sh --tweaks blur
 ./install.sh --tweaks square


cd ..
################
git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
cd Tela-circle-icon-theme
 ./install.sh -a
cd ..
###############
git clone https://github.com/vinceliuice/Fluent-icon-theme.git
cd Fluent-icon-theme
 ./install.sh -a -r
cd ..
###############

cd Fluent-icon-theme
cd cursors
 ./install.sh
cd ../..

gsettings set org.gnome.desktop.interface cursor-theme Fluent-cursors
gsettings set org.gnome.desktop.interface gtk-theme Fluent-Dark
gsettings set org.gnome.desktop.interface icon-theme Fluent-dark
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
}


cd data
pwdok="$(pwd)"
file
fonts
if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" == "0xffffffff" ]; then
cd $pwdok
sudo cp wsl.conf /etc/wsl.conf
WSL_Theme

fi
