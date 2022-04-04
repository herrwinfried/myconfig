#!/bin/bash

if ! [ -x "$(command -v wget)" ]; then
if [ -x "$(command -v apt)" ]; then
echo "$red I couldn't find the wget package. $green I'm uploading now. $white"
sudo apt install -y wget
elif [ -x "$(command -v zypper)" ]; then
echo "$red I couldn't find the wget package. $green I'm uploading now. $white"
 sudo zypper in -y wget
elif [ ! -x "$(command -v zypper)" ] && [ -x "$(command -v dnf)" ]; then
echo "$red I couldn't find the wget package. $green I'm uploading now. $white"
 sudo dnf install -y wget
 else
  #echo "$red İşlem İptal: lsb_release Paketi Bulunmadığından işlem iptal edildi." >&2
  echo "$red Transaction Canceled: The operation was canceled because the wget Package is Not Found. $white" >&2
  exit 1
fi
fi

mkdir SetupScript
cd SetupScript

wget https://raw.githubusercontent.com/herrwinfried/myconfig/main/wsl/setup.sh -O setup.sh
wget https://raw.githubusercontent.com/herrwinfried/myconfig/main/wsl/requirepackage.sh -O requirepackage.sh
wget https://raw.githubusercontent.com/herrwinfried/myconfig/main/wsl/varibles.sh -O varibles.sh

wget https://raw.githubusercontent.com/herrwinfried/myconfig/main/wsl/ubuntu.sh -O ubuntu.sh
wget https://raw.githubusercontent.com/herrwinfried/myconfig/main/wsl/opensuse.sh -O opensuse.sh

sudo chmod +x setup.sh
sudo chmod +x requirepackage.sh
sudo chmod +x varibles.sh

sudo chmod +x ubuntu.sh
sudo chmod +x opensuse.sh