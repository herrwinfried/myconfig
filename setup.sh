#!/bin/bash
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

checkroot
requirepackage

export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')
if [ "$distroselect" == "openSUSE Tumbleweed" ]; then
if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" == "0xffffffff" ]; then
. ./wsl-opensuse-tumbleweed.sh
elif [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
. ./opensuse-tumbleweed.sh
fi

#



##OPENSUSE TALİMATLARI BİTTİ
fi