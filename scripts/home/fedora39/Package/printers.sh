#!/bin/bash

Package_a="skanlite cups cups-client cups-filters cups-ipptool system-config-printer hplip"

if ! checkwsl; then
	SUDO $Package $PackageInstall $Package_a
	#SUDO adduser $home lpadmin
	SUDO service cups start
	SUDO systemctl start cups
	SUDO systemctl enable cups
fi
