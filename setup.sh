#!/bin/bash
ScriptFolder=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
. ./VARIBLES.sh

if [[ $distro = *opensuse\ tumbleweed* ]]; then
    openSUSETW_ALIAS

    sudoreq
    . ./home/opensuse-tumbleweed.sh
    sudofinish

elif [[ $distro = *fedora\ linux* ]]; then
    fedora_ALIAS

    sudoreq
    . ./home/fedora.sh
    sudofinish
else
    echo "It is currently not compatible with your Operating system." && exit 1
fi
