#!/bin/bash
sudo $Package $PackageInstall curl tar libicu73 libopenssl1_0_0 jq

pwshcore=$(curl -s "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" | jq -r ".assets[] | select(.name | test(\"linux-x64.tar.gz\")) | .browser_download_url")

if [ -d "/tmp/powershell.tar.gz" ]; then
    sudo rm -rf /tmp/powershell*
fi

if [ -d "/opt/microsoft/powershell" ]; then
    sudo rm -rf /opt/microsoft/powershell
fi
sleep 3

curl -L $pwshcore -o /tmp/powershell.tar.gz

sudo mkdir -p /opt/microsoft/powershell
sudo tar -xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/
sudo ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
sudo chmod +x /usr/bin/pwsh
