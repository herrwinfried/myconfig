#!/bin/bash

if [ -x "$(command -v firewall-cmd)" ] && ! CheckLinux ; then

SUDO firewall-cmd --permanent --new-service=stremio --add-port=11470/tcp
SUDO firewall-cmd --permanent --zone=home --add-service=stremio

fi