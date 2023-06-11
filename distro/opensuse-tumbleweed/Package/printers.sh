#!/bin/bash

Package_a="patterns-server-printing skanlite cups cups-client cups-filters system-config-printer hplip"

if ! checkwsl ; then
sudo $Package $PackageInstall $Package_a
	#sudo adduser $home lpadmin
	sudo service cups start
	sudo systemctl start cups
	sudo systemctl enable cups
fi