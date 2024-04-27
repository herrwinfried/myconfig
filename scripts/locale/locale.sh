#!/bin/bash

GetScriptDir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
GetScriptName=$(basename "${BASH_SOURCE[0]}")

Black='\033[0;30m'
DarkBlue='\033[0;34m'
DarkGreen='\033[0;32m'
DarkCyan='\033[0;36m'
DarkRed='\033[0;31m'
DarkMagenta='\033[0;35m'
DarkYellow='\033[0;33m'
Gray='\033[0;37m'
DarkGray='\033[1;30m'
Blue='\033[1;34m'
Green='\033[1;32m'
Cyan='\033[1;36m'
Red='\033[1;31m'
Magenta='\033[1;35m'
Yellow='\033[1;33m'
White='\033[1;37m'
NoColor='\033[0m' # No Color

if [[ ! -x $(command -v msgfmt) ]]; then
echo -e "${Red}Not Found msgfmt ${NoColor}\n"
exit 1
fi

echo -n -e "${Yellow}Which script would you like to modify? (For example, install.sh) ${NoColor}"
read LocaleScriptName

echo -n -e "${Magenta}Please enter the location of the language file (for example, /path/to/lang/en.po) ${NoColor}"
read UnCompiledFile

echo -n -e "${Blue}What is the language? (for example, en_US): ${NoColor}"
read LocaleName

test -f "${GetScriptDir}/${LocaleName}/LC_MESSAGES/${LocaleScriptName}.mo" && mv -f "${GetScriptDir}/${LocaleName}/LC_MESSAGES/${LocaleScriptName}.mo" "${GetScriptDir}/${LocaleName}/LC_MESSAGES/${LocaleScriptName}.mo.OLD"

if [[ -f $UnCompiledFile ]]; then
mkdir -p "${GetScriptDir}/${LocaleName}/LC_MESSAGES/"
msgfmt -o "${GetScriptDir}/${LocaleName}/LC_MESSAGES/${LocaleScriptName}.mo" "${UnCompiledFile}"
else
echo -e "${Red}Not Found File...${NoColor}"
echo "${UnCompiledFile}"
exit 1
fi
