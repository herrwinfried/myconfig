#!/bin/bash

if [ -x "$(command -v firewall-cmd)" ] && ! CheckLinux ; then

firewall-cmd --permanent --new-service=stremio --add-port=11470/tcp
firewall-cmd --permanent --zone=home --add-service=stremio

fi