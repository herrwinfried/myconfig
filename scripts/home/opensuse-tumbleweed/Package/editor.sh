#!/bin/bash
    if ! checkwsl; then
        Package_a=" code filezilla qt6-tools qt6-creator"
        Package_a+=" qt6-tools-assistant qt6-tools-designer qt6-tools-linguist qt6-tools-qdbus qt6-translations"
        Package_a+=" okteta ikona"
        SUDO $Package $PackageInstall $Package_a
    fi
