#!/bin/bash
    SUDO $Package $PackageInstall curl tar
    curl -L "https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.0.4.17212.tar.gz" -o /tmp/jetbrains-toolbox.tar.gz
    
    SUDO tar -xzf /tmp/jetbrains-toolbox.tar.gz -C /opt
    SUDO mv /opt/jetbrains-toolbox-* /opt/jetbrains-toolbox

    Package_a="gh glab"
    Package_a+=" code filezilla qt6-creator"
    Package_a+=" okteta ikona kdevelop5 kdevelop5-pg-qt kdevelop5-plugin-php kdevelop5-plugin-python3"
    SUDO $Package $PackageInstall --no-recommends $Package_a

