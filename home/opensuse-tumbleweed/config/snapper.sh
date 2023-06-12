#!/bin/bash

if [ -x "$(command -v snapper)" ]; then
    sudo snapper -c home create-config /home
    sudo snapper -c home create --description "New config"

    sudo snapper -c home create-config /opt
    sudo snapper -c home create --description "New config"
else
    echo $red"NOT FOUND SNAPPER$white"
fi
