#!/bin/bash

download_dir="$HomePWD/Downloads"
if [ ! -d "$download_dir" ]; then
    mkdir -p "$download_dir"
fi

rpm_file="$download_dir/binance-x86_64-linux.rpm"
if [ -f "$rpm_file" ]; then
    rm "$rpm_file"
fi

wget "https://download.binance.com/electron-desktop/linux/production/binance-x86_64-linux.rpm" -P "$download_dir"

chmod +x "$rpm_file"

SUDO $Package $PackageInstall "$rpm_file"

if command -v binance; then
    distrobox-export -a binance
fi