#!/bin/bash

if ! checkwsl; then
if [ -x "$(command -v noisetorch)" ]; then
Microphone_id_address=$(noisetorch -l |grep -E "input" | sed -E 's/DeviceID: //' | head -1)
cat << EOL > $HomePWD/.config/systemd/user/noisetorch.service
[Unit]
Description=Noisetorch Noise Cancelling
Requires=$DEVICEUNIT
After=$DEVICEUNIT
After=pipewire.service

[Service]
Type=simple
RemainAfterExit=yes
ExecStart=%h/.local/bin/noisetorch -i -s $Microphone_id_address -t 50
ExecStop=%h/.local/bin/noisetorch -u
Restart=on-failure
RestartSec=3

[Install]
WantedBy=default.target
EOL

systemctl --user daemon-reload
systemctl --user enable --now noisetorch
fi
fi