#!/bin/bash
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

function file() {

sudo chmod +x nvidia*
###USER
su -l $home -c "touch ~/.alias"
cat .alias > $HomePWD/.alias
su -l $home -c "mkdir -p ~/.config"
su -l $home -c "mkdir -p ~/.config/powershell"
su -l $home -c "touch ~/.config/powershell/Microsoft.PowerShell_profile.ps1"
cat Microsoft.PowerShell_profile.ps1 > $HomePWD/.config/powershell/Microsoft.PowerShell_profile.ps1
su -l $home -c "touch ~/.p10k.zsh"
cat .p10k.zsh > $HomePWD/.p10k.zsh
su -l $home -c "zsh -c 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k'"
sed -ie 's+ZSH_THEME="robbyrussell"+ZSH_THEME="powerlevel10k/powerlevel10k"+i' $HomePWD/.zshrc

### Root
touch ~/.alias
cat .alias > ~/.alias
mkdir -p ~/.config/
mkdir -p ~/.config/powershell
touch ~/.config/powershell/Microsoft.PowerShell_profile.ps1
cat Microsoft.PowerShell_profile.ps1 > ~/.config/powershell/Microsoft.PowerShell_profile.ps1
touch ~/.p10k.zsh
cat .p10k.zsh > ~/.p10k.zsh
zsh -c 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k'
sed -ie 's+ZSH_THEME="robbyrussell"+ZSH_THEME="powerlevel10k/powerlevel10k"+i' ~/.zshrc


if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
sudo cp nvidia_gamemoderun /usr/local/bin/nvidia_gamemoderun
sudo cp nvidia-run /usr/local/bin/nvidia-run
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