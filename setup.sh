#!/bin/bash
ScriptFolder=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

if [[ $distro = *opensuse\ tumbleweed* ]]; then
openSUSETW_ALIAS

sudoreq
. ./distro/opensuse-tumbleweed.sh
sudofinish
else
echo "It is currently not compatible with your Operating system." && exit 1
fi
