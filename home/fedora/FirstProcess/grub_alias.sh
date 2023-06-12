#!/bin/bash
if ! checkwsl; then
    sudo mkdir -p /boot/grub2.d
    sudo mkdir -p /boot/grub2.d/themes
fi
