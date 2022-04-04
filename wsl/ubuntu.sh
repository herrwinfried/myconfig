#!/bin/bash

function ubuntu_20_04 {
# Ubuntu GUIVALUE POWERSHELLVALUE

# GUIVALUE = 0 | GUI DON'T SETUP
# GUIVALUE = 1 | GUI SETUP

# POWERSHELL = 1 | PWSH SETUP
# POWERSHELL = 0 | PWSH DON'T SETUP
ubuntu_guivalue=$1
ubuntu_pwshvalue=$2


sudo apt install -f -y
function update {
sudo apt update && sudo apt upgrade -y
}
function repository {
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm -rf packages-microsoft-prod.deb
##############
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
##############
sudo curl -fsSLo /usr/share/keyrings/brave-browser-nightly-archive-keyring.gpg https://brave-browser-apt-nightly.s3.brave.com/brave-browser-nightly-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-nightly-archive-keyring.gpg arch=amd64] https://brave-browser-apt-nightly.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-nightly.list
###
sudo apt update
}
function powershell {
sudo apt install -y powershell
}
function basepackage {
sudo apt install -y zsh curl neofetch screenfetch git lzip unzip nano
sudo apt install brave-browser-nightly -y
}
function developerpackage {
sudo apt install -y build-essential nodejs python3.9-full python3.9 python3-pip dotnet-sdk-6.0 rsync gdb
}

update
repository
if [[ $powershell == true ]]; then
powershell
fi
basepackage
developerpackage

##########
sleepwait 2
##########
if [[ $ubuntu_guivalue -eq 1 ]]; then
echo "$yellow Null Package $white"
fi


}