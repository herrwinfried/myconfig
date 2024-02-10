#!/bin/bash

Package_a="patterns-server-printing skanlite cups cups-client cups-filters cups-airprint system-config-printer hplip"

if ! checkwsl; then
	SUDO $Package $PackageInstall $Package_a
	#SUDO adduser $home lpadmin
	SUDO service cups start
	SUDO systemctl start cups
	SUDO systemctl enable cups
fi
