#!/bin/bash
ScriptFolder=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

. ./VARIBLES.sh

if [[ $distro = *opensuse\ tumbleweed* ]]; then
    openSUSETW_ALIAS

    sudoreq
    for forScriptFile in $(ls $ScriptFolder/home/opensuse-tumbleweed/config); do
        chmod +x $ScriptFolder/home/opensuse-tumbleweed/config/$forScriptFile
        . $ScriptFolder/home/opensuse-tumbleweed/config/$forScriptFile
    done
    sudofinish
elif [[ $distro = *fedora\ linux* ]]; then
    fedora_ALIAS
    
    sudoreq
    for forScriptFile in $(ls $ScriptFolder/home/fedora/config); do
        chmod +x $ScriptFolder/home/fedora/config/$forScriptFile
        . $ScriptFolder/home/fedora/config/$forScriptFile
    done
    sudofinish
else
    echo "It is currently not compatible with your Operating system." && exit 1
fi
