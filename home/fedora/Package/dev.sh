#!/bin/bash

if ! checkwsl; then

    sudo $Package $PackageInstall curl tar
    curl -L "https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.27.1.13673.tar.gz" -o /tmp/jetbrains-toolbox.tar.gz
    sudoreq
    sudo tar -xzf /tmp/jetbrains-toolbox.tar.gz -C /opt
    sudo mv /opt/jetbrains-toolbox-* /opt/jetbrains-toolbox
    sudo $Package $PackageInstall code filezilla qt-creator rsync
fi
