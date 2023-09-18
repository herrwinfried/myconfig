#!/bin/bash

if [ -x "$(command -v snapper)" ]; then
    SUDO snapper -c home create-config /home
    SUDO snapper -c home create --description "New config"

    SUDO snapper -c home create-config /opt
    SUDO snapper -c home create --description "New config"
else
    echo $red"NOT FOUND SNAPPER$white"
fi
