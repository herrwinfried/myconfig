#!/bin/bash

if ! CheckWsl; then
    if rpm -q virtualbox; then
        SUDO groupadd vboxusers
        SUDO usermod -aG vboxusers $USERNAME
    fi
fi