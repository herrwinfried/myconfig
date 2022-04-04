#!/bin/bash
function requirePackage () {

if [[ $1 -eq 0 ]]; then
if ! [ -x "$(command -v lsb_release)" ]; then
if [ -x "$(command -v apt)" ]; then
echo "$red I couldn't find the lsb-release package. $green I'm uploading now. $white"
sudo apt install -y lsb-release
elif [ -x "$(command -v zypper)" ]; then
echo "$red I couldn't find the lsb-release package. $green I'm uploading now. $white"
 sudo zypper in -y lsb-release
elif [ ! -x "$(command -v zypper)" ] && [ -x "$(command -v dnf)" ]; then
echo "$red I couldn't find the redhat-lsb-core package. $green I'm uploading now. $white"
 sudo dnf install -y redhat-lsb-core
 else
  #echo "$red İşlem İptal: lsb_release Paketi Bulunmadığından işlem iptal edildi." >&2
  echo "$red Transaction Canceled: The operation was canceled because the lsb_release Package is Not Found. $white" >&2
  exit 1
fi
fi
#
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
else
  echo "$green Skip $white" >&2
fi
}
