#!/bin/bash
if ! lsmod | grep -q ntfs3; then
SUDO /sbin/modprobe ntfs3
fi