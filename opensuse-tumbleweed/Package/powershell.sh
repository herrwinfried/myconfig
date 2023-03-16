#!/bin/bash

sudo $PackageName $UpdateArg
sudo $PackageName $PackageInstall curl tar libicu72 libopenssl1_0_0 jq
pwshcore=$(curl -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest| jq -r ".assets[] | select(.name | test(\"linux-x64.tar.gz\")) | .browser_download_url")

curl -L $pwshcore -o /tmp/powershell.tar.gz
sudo mkdir -p /opt/microsoft/powershell
sudo tar -xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/
sudo ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
sudo chmod +x /usr/bin/pwsh


#Oh My Posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

mkdir $HomePWD/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O $HomePWD/.poshthemes/themes.zip
unzip $HomePWD/.poshthemes/themes.zip -d $HomePWD/.poshthemes
chmod u+rw $HomePWD/.poshthemes/*.omp.*
rm $HomePWD/.poshthemes/themes.zip