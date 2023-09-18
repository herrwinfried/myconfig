#!/bin/bash

if ! checkwsl; then

    if [[ $(hostname) == $NEW_HOSTNAME ]]; then
        echo $red"You have the same hostname. That's why I won't change it.$white"
    else
        SUDO hostnamectl set-hostname $NEW_HOSTNAME
    fi

fi
