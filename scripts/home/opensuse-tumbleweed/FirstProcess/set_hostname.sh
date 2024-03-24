#!/bin/bash

if ! checkwsl; then

    if [[ $(hostname) == $NEW_HOSTNAME ]]; then
        echo $red" $LANG_ALREADY_HOSTNAME $white"
    else
        SUDO hostnamectl set-hostname $NEW_HOSTNAME
    fi

fi