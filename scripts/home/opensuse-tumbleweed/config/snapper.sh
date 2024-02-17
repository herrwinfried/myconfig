#!/bin/bash

if [ -x "$(command -v snapper)" ]; then
    SUDO snapper -c home create-config /home
    SUDO snapper -c home create --description "New config"

fi
