#!/bin/bash

if [ -f "/usr/local/bin/mas" ]; then


mas install 497799835 #xcode

else

echo "MAS yüklü mü? İşlem iptal edildi..."
exit 1
fi