#!/bin/bash
    /opt/jetbrains-toolbox/jetbrains-toolbox & 
    sleep 5
    killall jetbrains-toolbox
    sleep 5
distrobox-export -a $HOME/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox
distrobox-export -a code
distrobox-export -a filezilla
distrobox-export -a qtcreator
distrobox-export -a okteta
distrobox-export -a ikona
distrobox-export -a kdevelop