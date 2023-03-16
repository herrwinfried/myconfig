#!/bin/bash

function printers {
sudo $PackageName $PackageInstall skanlite cups cups-client cups-filters system-config-printer # hplip
	#sudo adduser $home lpadmin
	sudo service cups start
	sudo systemctl start cups
	sudo systemctl enable cups
}

if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
printers
fi