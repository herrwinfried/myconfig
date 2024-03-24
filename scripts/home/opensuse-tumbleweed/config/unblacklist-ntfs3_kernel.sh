#!/bin/bash
if ! lsmod | grep -q ntfs3; then
SUDO install ntfs3 /usr/lib/module-init-tools/unblacklist ntfs3; SUDO /sbin/modprobe --ignore-install ntfs3
fi