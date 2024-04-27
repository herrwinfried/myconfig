#!/bin/bash
. /etc/os-release

DISTRO=$(echo $NAME $VERSION | tr '[:upper:]' '[:lower:]')
# shellcheck disable=SC2002
BOARD_VENDOR=$(cat /sys/class/dmi/id/board_vendor 2>/dev/null | tr '[:upper:]' '[:lower:]')
USERNAME=$USER
USERHOME=$HOME
EXTERNAL_PACKAGE_DIRS="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd .. && pwd)/files"
NEW_HOSTNAME="herrwinfried"
unset /etc/os-release
