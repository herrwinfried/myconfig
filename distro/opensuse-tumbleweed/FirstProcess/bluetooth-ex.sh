#!/bin/bash


if ! checkwsl ; then
# sudo zypper in -y bluez-auto-enable-devices
#sed -i "s/#Experimental = false/Experimental = true/" /etc/bluetooth/main.conf
################################################################################


if [ "$(cat /etc/systemd/system/bluetooth.service.d/override.conf | grep 'ExecStart=/usr/libexec/bluetooth/bluetoothd -E')" ]; then
echo $red"bluetoothd -E is available. The value will be not written.$white"
else
sudo mkdir -p /etc/systemd/system/bluetooth.service.d
sudo touch /etc/systemd/system/bluetooth.service.d/override.conf
echo "[Service]
ExecStart=
ExecStart=/usr/libexec/bluetooth/bluetoothd -E" | sudo tee /etc/systemd/system/bluetooth.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart bluetooth
fi


fi
