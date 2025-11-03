#!/bin/bash

if is_command firewall-cmd; then
  SUDO firewall-cmd --permanent --new-service=stremio
  SUDO firewall-cmd --permanent --service=stremio --add-port=11470/tcp
  SUDO firewall-cmd --permanent --service=stremio --add-port=12470/tcp
  SUDO firewall-cmd --permanent --zone=home --add-service=stremio

  SUDO firewall-cmd --permanent --new-service=localsend
  SUDO firewall-cmd --permanent --service=localsend --add-port=53317/tcp
  SUDO firewall-cmd --permanent --zone=home --add-service=localsend
fi