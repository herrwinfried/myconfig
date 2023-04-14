#!/bin/bash
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

checkroot
requirepackage

distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')

if [ "$distroselect" == "openSUSE Tumbleweed" ]; then
. ./distro/opensuse-tumbleweed.sh
##OPENSUSE FINISH
fi
