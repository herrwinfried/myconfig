#!/bin/bash
ScriptFolder=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
. ./VARIBLES.sh

if [[ $distro = *opensuse\ tumbleweed* ]]; then
    openSUSETW_ALIAS

rootpassword || {
        echo -e $red"Cancel..."$white
        exit 1
    }
    . ./home/opensuse-tumbleweed.sh
    sudofinish

elif [[ $distro = *fedora\ linux* ]]; then
    fedora_ALIAS

 rootpassword || {
        echo -e $red"Cancel..."$white
        exit 1
    }
    . ./home/fedora.sh
    sudofinish
else
    echo "It is currently not compatible with your Operating system." && exit 1
fi
