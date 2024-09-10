#!/bin/bash

if ! CheckWsl ; then 

URL="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
TMP_FILE="/tmp/firefox-developer.tar.bz2"
TARGET_DIR="/opt/FirefoxDeveloper"
FILE_NAME="firefox"
BIN_FILENAME="${FILE_NAME}-dev"

test -f $TMP_FILE && SUDO rm -f $TMP_FILE
wget -O $TMP_FILE $URL
test -d $TARGET_DIR && SUDO rm -rf $TARGET_DIR
SUDO mkdir -p $TARGET_DIR
SUDO tar -xjf $TMP_FILE -C $TARGET_DIR
SUDO mv $TARGET_DIR/${FILE_NAME}  $TARGET_DIR/${FILE_NAME}-folder
SUDO mv $TARGET_DIR/${FILE_NAME}-folder/* $TARGET_DIR
SUDO chmod +x $TARGET_DIR/$FILE_NAME
SUDO ln -sf $TARGET_DIR/$FILE_NAME /usr/bin/${BIN_FILENAME}
SUDO mkdir -p /usr/local/share/applications
SUDO cp -f /usr/share/applications/firefox.desktop /usr/local/share/applications/firefox-dev.desktop
SUDO sed -i 's/firefox/firefox-dev/g' /usr/local/share/applications/firefox-dev.desktop
SUDO sed -i 's/Firefox/Firefox-dev/g' /usr/local/share/applications/firefox-dev.desktop
SUDO sed -i 's/Icon=firefox-dev/Icon=\/opt\/FirefoxDeveloper\/browser\/chrome\/icons\/default\/default128.png/g' /usr/local/share/applications/firefox-dev.desktop

fi