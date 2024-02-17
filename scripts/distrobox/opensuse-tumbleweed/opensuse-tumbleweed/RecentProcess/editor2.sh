#!/bin/bash
    /opt/jetbrains-toolbox/jetbrains-toolbox & 
    sleep 5
    killall jetbrains-toolbox
    sleep 5

function dboxexport {
distrobox-export -a "$1"
}
dboxexport $HOME/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox
dboxexport code
dboxexport filezilla
dboxexport okteta
dboxexport ikona
dboxexport kdevelop

dboxexport qtcreator
dboxexport designer6
dboxexport linguist6
dboxexport assistant6
dboxexport qdbusviewer6
