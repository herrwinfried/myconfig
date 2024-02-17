#!/bin/bash

download_dir="$HomePWD/Downloads"
if [ ! -d "$download_dir" ]; then
    mkdir -p "$download_dir"
fi

deb_file="$download_dir/Termius.deb"
if [ -f "$deb_file" ]; then
    rm "$deb_file"
fi

wget "https://www.termius.com/download/linux/Termius.deb" -P "$download_dir"

chmod +x "$deb_file"

SUDO dpkg -i "$deb_file"

SUDO $Package $PackageInstall -f

if command -v termius; then
    distrobox-export -a termius
fi