#!/bin/bash
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

function file() {

cat .alias > $HomePWD/.alias 
sudo cat .alias >  ~/.alias 
sudo mkdir -p ~/.config/powershell 
sudo touch ~/.config/powershell/Microsoft.PowerShell_profile.ps1
su -l $home -c "mkdir -p ~/.config/powershell; touch ~/.config/powershell/Microsoft.PowerShell_profile.ps1"
cat Microsoft.PowerShell_profile.ps1 > $HomePWD/.config/powershell/Microsoft.PowerShell_profile.ps1
cat Microsoft.PowerShell_profile.ps1 > ~/.config/powershell/Microsoft.PowerShell_profile.ps1
if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
sudo cp nvidia_gamemoderun /usr/local/bin/nvidia_gamemoderun
sudo cp nvidia-run /usr/local/bin/nvidia-run
fi
}

function fonts() {
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P /usr/share/fonts/truetype
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P /usr/share/fonts/truetype
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P /usr/share/fonts/truetype
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P /usr/share/fonts/truetype
fc-cache
}

function WSL_Theme() {
mkdir -p themeconfig
cd themeconfig
##GTK THEME
wget https://github.com/dracula/gtk/archive/master.zip
unzip master.zip
mv gtk-master dracula
mv dracula /usr/share/themes
rm -rf *.zip
##GTK ICON
wget https://github.com/dracula/gtk/files/5214870/Dracula.zip
unzip Dracula.zip
mv Dracula /usr/share/icons/
rm -rf *.zip
##QT COLOR
git clone https://github.com/dracula/qt5.git
sudo cp -r qt5/Dracula.conf /usr/share/qt5ct/colors
rm -rf qt5
####################################################
##Cursor
sudo git clone https://github.com/dracula/gtk.git
sudo cp -r gtk/kde/cursors/Dracula-cursors /usr/share/icons/ 
sudo rm -rf gtk
###########################################################
gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
gsettings set org.gnome.desktop.interface icon-theme "Dracula"
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