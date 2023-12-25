#!/bin/bash

if ! checkwsl; then
    # SUDO zypper in -y bluez-auto-enable-devices
    #SUDO sed -i "s/#Experimental = false/Experimental = true/" /etc/bluetooth/main.conf
    ################################################################################

    if [ "$(cat /etc/systemd/system/bluetooth.service.d/override.conf | grep 'ExecStart=/usr/libexec/bluetooth/bluetoothd -E')" ]; then
        echo $red"bluetoothd -E is available. The value will be not written.$white"
    else
        SUDO mkdir -p /etc/systemd/system/bluetooth.service.d
        SUDO touch /etc/systemd/system/bluetooth.service.d/override.conf
        echo "[Service]
ExecStart=
ExecStart=/usr/libexec/bluetooth/bluetoothd -E" | SUDO tee /etc/systemd/system/bluetooth.service.d/override.conf
        SUDO systemctl daemon-reload
        SUDO systemctl restart bluetooth
    fi

fi
