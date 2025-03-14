#!/bin/bash
. /etc/os-release

declare -A COLORS=(
    [Black]='\033[0;30m' [DarkBlue]='\033[0;34m' [DarkGreen]='\033[0;32m' [DarkCyan]='\033[0;36m'
    [DarkRed]='\033[0;31m' [DarkMagenta]='\033[0;35m' [DarkYellow]='\033[0;33m' [Gray]='\033[0;37m'
    [DarkGray]='\033[1;30m' [Blue]='\033[1;34m' [Green]='\033[1;32m' [Cyan]='\033[1;36m'
    [Red]='\033[1;31m' [Magenta]='\033[1;35m' [Yellow]='\033[1;33m' [White]='\033[1;37m'
    [NoColor]='\033[0m'
)

declare -A config
config["distro"]=$(echo $NAME $VERSION | tr '[:upper:]' '[:lower:]')
config["board_vendor"]=$(cat /sys/class/dmi/id/board_vendor 2>/dev/null | tr '[:upper:]' '[:lower:]')
config["external_package_dirs"]="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd .. && pwd)/files"
config["new_hostname"]="herrwinfried"
unset /etc/os-release