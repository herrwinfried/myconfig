#!/bin/bash

if [ -f "/usr/local/bin/brew" ]; then
eval "$(/usr/local/bin/brew shellenv)"

brewInstall oh-my-posh 
brewInstall git 
brewInstallCask powershell 
#brewInstallCask dotnet 
brewInstall gnupg 
brewInstall wget 
brewInstall mas 
else

echo "Brew yüklü mü? İşlem iptal edildi..."
exit 1
fi