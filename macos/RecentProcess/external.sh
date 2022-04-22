#!/bin/bash

if [ ! -f "/Applications/Brave Browser.app" ]; then
wget "https://referrals.brave.com/latest/Brave-Browser.dmg" -O "/tmp/Brave Browser.dmg"
DMGInstall "/tmp/Brave Browser.dmg"
fi

if [ ! -f "/Applications/Visual Studio Code.app" ]; then
wget "https://code.visualstudio.com/sha/download?build=stable&os=darwin" -O /tmp/VSCode-darwin.zip
unzip /tmp/VSCode-darwin.zip -d /Applications
fi

if [ ! -f "/Applications/iTerm.app" ]; then
wget "https://iterm2.com/downloads/stable/iTerm2-3_4_19.zip" -O /tmp/iterm2.zip
unzip /tmp/iterm2.zip -d /Applications
fi

if [ ! -f "/Applications/AudioRelay.app" ]; then
wget "https://dl.audiorelay.net/setups/macos/AudioRelay-0.27.5.dmg" -O /tmp/AudioRelay.dmg
DMGInstall /tmp/AudioRelay.dmg
fi