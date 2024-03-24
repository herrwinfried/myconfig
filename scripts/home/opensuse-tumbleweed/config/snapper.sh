#!/bin/bash

if [ -x "$(command -v snapper)" ]; then
    if ! snapper -c home list-configs &> /dev/null; then
    SUDO snapper -c home create-config /home
    SUDO snapper -c home create --description "New config"
    fi
fi
