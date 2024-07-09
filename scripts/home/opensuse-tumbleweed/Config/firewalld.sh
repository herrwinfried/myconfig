#!/bin/bash

if [ -x "$(command -v firewall-cmd)" ] && ! CheckWsl ; then
SUDO firewall-cmd --permanent --new-service=stremio --add-port=11470/tcp
SUDO firewall-cmd --permanent --zone=home --add-service=stremio

SUDO firewall-cmd --permanent --new-service=krfbcustom
SUDO firewall-cmd --permanent --service=krfbcustom --add-port=5900/tcp
SUDO firewall-cmd --permanent --service=krfbcustom --add-port=5963/tcp
SUDO firewall-cmd --permanent --zone=home --add-service=krfbcustom

fi