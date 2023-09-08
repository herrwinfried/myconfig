#!/bin/bash

if ! checkwsl; then

    $SUDO $Package $PackageInstall curl tar
    curl -L "https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-1.28.1.15219.tar.gz" -o /tmp/jetbrains-toolbox.tar.gz
    
    $SUDO tar -xzf /tmp/jetbrains-toolbox.tar.gz -C /opt
    $SUDO mv /opt/jetbrains-toolbox-* /opt/jetbrains-toolbox
    $SUDO $Package $PackageInstall code filezilla qt6-creator rsync gh glab
fi
