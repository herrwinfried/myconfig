#!/bin/bash

if ! checkwsl; then

    sudo $Package $PackageInstall curl tar
    curl -L "https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-1.28.1.15219.tar.gz" -o /tmp/jetbrains-toolbox.tar.gz
    
    sudo tar -xzf /tmp/jetbrains-toolbox.tar.gz -C /opt
    sudo mv /opt/jetbrains-toolbox-* /opt/jetbrains-toolbox
    sudo $Package $PackageInstall code filezilla qt6-creator rsync gh glab
fi
