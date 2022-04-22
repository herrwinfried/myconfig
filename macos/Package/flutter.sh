#!/bin/bash
mkdir -p $HomePWD/development
wget "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.10.1-stable.zip" -O flutter.zip
unzip flutter.zip -d $HomePWD/development
