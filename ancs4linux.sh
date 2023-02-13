git clone https://github.com/pzmarzly/ancs4linux

sed -ie 's+ExecStart=/usr/local/bin/ancs4linux-advertising+ExecStart=/usr/bin/ancs4linux-advertising+i' ./ancs4linux/autorun/ancs4linux-advertising.service
sed -ie 's+ExecStart=/usr/local/bin/ancs4linux-observer+ExecStart=/usr/bin/ancs4linux-observer+i' ./ancs4linux/autorun/ancs4linux-observer.service
sed -ie 's+ExecStart=/usr/local/bin/ancs4linux-desktop-integration+ExecStart=/usr/bin/ancs4linux-desktop-integration+i' ./ancs4linux/autorun/ancs4linux-desktop-integration.service

sudo ./ancs4linux/autorun/install.sh

systemctl --user daemon-reload
systemctl --user start ancs4linux-desktop-integration.service
ancs4linux-ctl enable-pairing