#!/bin/bash

# Colors
termcols=$(tput cols)
bold="$(tput bold)"
fontnormal="$(tput init)"
fontreset="$(tput reset)"
underline="$(tput smul)"
standout="$(tput smso)"
normal="$(tput sgr0)"
black="$(tput setaf 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
magenta="$(tput setaf 5)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"
# Colors Finish
function checkroot {
if [[ $EUID -ne 0 ]]; then
   #echo "$red TUR:Süper Kullanıcı/Root Olmanız gerekiyor."
     echo "$red ENG:You need to be Super User/Root. $white"
       #echo "$red GER: Sie müssen Superuser/Root sein."
   exit 1
fi
}

function sleepwait () {
sleep $1
}