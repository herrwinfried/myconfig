#!/bin/bash
if systemctl status cups.service &> /dev/null; then
    #SUDO adduser $home lpadmin
    SUDO service cups start
    SUDO systemctl start cups
    SUDO systemctl enable cups
fi