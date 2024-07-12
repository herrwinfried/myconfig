#!/bin/bash
if ! CheckWsl; then
    SUDO mkdir -p /boot/grub2.d
    SUDO mkdir -p /boot/grub2.d/themes
fi