#!/bin/bash
<< "com"
if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
    desktopGitURL=$(curl -s https://api.github.com/repos/shiftkey/desktop/releases/latest | jq -r ".assets[] | select(.name | test(\".rpm\")) | .browser_download_url")
curl -L $desktopGitURL -o $output/GitHubDesktop.rpm
fi
com