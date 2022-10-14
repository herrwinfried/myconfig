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
if [[ -f setup.sh.old ]]; then
rm -rf setup.old.sh
fi
if [[ -f setup.sh ]]; then
mv setup.sh setup.old.sh
fi
wget https://raw.githubusercontent.com/herrwinfried/myconfig/main/wsl/setup.sh -O setup.sh
if [[ -f varibles.sh.old ]]; then
rm -rf requirepackage.old.sh
fi
if [[ -f requirepackage.sh ]]; then
mv requirepackage.sh requirepackage.old.sh
fi
wget https://raw.githubusercontent.com/herrwinfried/myconfig/main/wsl/requirepackage.sh -O requirepackage.sh
if [[ -f varibles.sh.old ]]; then
rm -rf varibles.old.sh
fi
if [[ -f varibles.sh ]]; then
mv varibles.sh varibles.old.sh
fi
wget https://raw.githubusercontent.com/herrwinfried/myconfig/main/wsl/varibles.sh -O varibles.sh

if [[ -f ubuntu.sh.old ]]; then
rm -rf ubuntu.old.sh
fi
if [[ -f ubuntu.sh ]]; then
mv ubuntu.sh ubuntu.old.sh
fi
wget https://raw.githubusercontent.com/herrwinfried/myconfig/main/wsl/ubuntu.sh -O ubuntu.sh

if [[ -f opensuse.sh.old ]]; then
rm -rf opensuse.old.sh
fi
if [[ -f opensuse.sh ]]; then
mv opensuse.sh opensuse.old.sh
fi
wget https://raw.githubusercontent.com/herrwinfried/myconfig/main/wsl/opensuse.sh -O opensuse.sh

sudo cat <<EOF > /etc/wsl.conf
[boot]
systemd=true
EOF

sudo chmod +x setup.sh
sudo chmod +x requirepackage.sh
sudo chmod +x varibles.sh

sudo chmod +x ubuntu.sh
sudo chmod +x opensuse.sh
echo "Go to windows powershell enter command (wsl --shutdown) and open WSL distro"
echo "Go To SetupScript Folder"
echo "sudo ./setup [ARG]"
