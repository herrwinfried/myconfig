#!/bin/bash
ScriptFolder=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
. ./VARIBLES.sh

if [[ $distro = *opensuse\ tumbleweed* ]]; then
    openSUSETW_ALIAS

    sudoreq
    for forScriptFile in $(ls $ScriptFolder/home/opensuse-tumbleweed/Repository); do
        chmod +x $ScriptFolder/home/opensuse-tumbleweed/Repository/$forScriptFile
        . $ScriptFolder/home/opensuse-tumbleweed/Repository/$forScriptFile
    done

    for forScriptFile in $(ls $ScriptFolder/home/opensuse-tumbleweed/Presetup); do
        chmod +x $ScriptFolder/home/opensuse-tumbleweed/Presetup/$forScriptFile
        . $ScriptFolder/home/opensuse-tumbleweed/Presetup/$forScriptFile
    done

    sudofinish
elif [[ $distro = *fedora\ linux* ]]; then
    fedora_ALIAS
    sudoreq
    for forScriptFile in $(ls $ScriptFolder/home/fedora/Repository); do
        chmod +x $ScriptFolder/home/fedora/Repository/$forScriptFile
        . $ScriptFolder/home/fedora/Repository/$forScriptFile
    done

    for forScriptFile in $(ls $ScriptFolder/home/fedora/Presetup); do
        chmod +x $ScriptFolder/home/fedora/Presetup/$forScriptFile
        . $ScriptFolder/home/fedora/Presetup/$forScriptFile
    done
    sudofinish
else
    echo "It is currently not compatible with your Operating system." && exit 1
fi
