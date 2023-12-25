#!/bin/bash

pwsh_version=$(pwsh --version)
version_regex="(\d+\.\d+\.\d+)"
version_number=v$(echo $pwsh_version | grep -oP "$version_regex")
pwshcore_version=$(curl -s "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" | jq -r ".tag_name")


if [[ $version_number != $pwshcore_version ]]; then
SUDO $Package $PackageInstall curl tar libicu libopenssl1_0_0 jq

pwshcore=$(curl -s "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" | jq -r ".assets[] | select(.name | test(\"linux-x64.tar.gz\")) | .browser_download_url")

if [ -d "/tmp/powershell.tar.gz" ]; then
    SUDO rm -rf /tmp/powershell*
fi

if [ -d "/opt/microsoft/powershell" ]; then
    SUDO rm -rf /opt/microsoft/powershell
fi
sleep 3

curl -L $pwshcore -o /tmp/powershell.tar.gz

SUDO mkdir -p /opt/microsoft/powershell
SUDO tar -xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/
SUDO ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
SUDO chmod +x /usr/bin/pwsh
else
echo $yellow"Powershell looks up to date. That's why it won't download.$white"
fi