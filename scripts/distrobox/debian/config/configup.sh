#!/bin/bash
SUDO su -c "echo -e \"mkdir -p /home/winfried/distrobox/config\ncp -rf /home/winfried/.config/{gtk-3.0,gtk-4.0,gtkrc-2.0,gtkrc,kdeglobals,systemsettingsrc} /home/winfried/distrobox/config\ncp -rf /home/winfried/distrobox/config/* ~/.config\" | tee /usr/local/bin/configupdate"
SUDO chmod +x /usr/local/bin/configupdate