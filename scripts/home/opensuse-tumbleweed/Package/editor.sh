#!/bin/bash
    if ! checkwsl; then
        SUDO $Package $PackageInstall curl tar
        curl -L "https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-2.2.1.19765.tar.gz" -o /tmp/jetbrains-toolbox.tar.gz
        
        SUDO tar -xzf /tmp/jetbrains-toolbox.tar.gz -C /opt
        SUDO mv /opt/jetbrains-toolbox-* /opt/jetbrains-toolbox

        Package_a=" code filezilla qt6-tools qt6-creator"
        Package_a+=" qt6-tools-assistant qt6-tools-designer qt6-tools-linguist qt6-tools-qdbus qt6-translations"
        Package_a+=" okteta ikona"
        SUDO $Package $PackageInstall $Package_a
    fi
