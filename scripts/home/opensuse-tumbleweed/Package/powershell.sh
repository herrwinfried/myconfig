#!/bin/bash
function Install {
SUDO $Package $PackageInstall curl tar jq
if [[ -x $(command -v pwsh) ]]; then
    PWSH_REGEX="(\d+\.\d+\.\d+)"
    # shellcheck disable=SC2046
    # shellcheck disable=SC2005
    PWSH_VERSION=v$(echo $(pwsh --version) | grep -oP "$PWSH_REGEX")
    CURRENT_PWSH=$(curl -s "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" | jq -r ".tag_name")
fi

if [ -z "$PWSH_VERSION" ]; then
    Download
elif [[ $PWSH_VERSION != "$CURRENT_PWSH" ]]; then
    Download
elif [[ $PWSH_VERSION == "$CURRENT_PWSH" ]]; then
    echo -e "${Yellow}Powershell looks up to date. That's why it won't download. ${NoColor}"
fi
}

function Download {

    PWSH_URL=$(curl -s "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" | jq -r ".assets[] | select(.name | test(\"linux-x64.tar.gz\")) | .browser_download_url")
    test -d "/tmp/powershell.tar.gz" && SUDO rm -rf "/tmp/powershell*"
    test -d "/opt/microsoft/powershell" && SUDO rm -rf "/opt/microsoft/powershell"
    test -f /usr/bin/pwsh && SUDO rm -f "/usr/bin/pwsh"
    sleep 3; curl -L "$PWSH_URL" -o /tmp/powershell.tar.gz 
    SUDO mkdir -p /opt/microsoft/powershell
    SUDO tar -xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/
    SUDO ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
    SUDO chmod +x /usr/bin/pwsh
}

Install
