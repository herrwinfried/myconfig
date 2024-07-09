#!/bin/bash

if CheckWsl; then

    if [[ -d "$GetDataDir/rootWSL/" ]]; then
    SUDO rsync -a --info=progress2 --force -L$GetDataDir/rootWSL/ /
    fi


    function WSL_THEME() {
        mkdir -p my_themes
        cd my_themes

        SUDO zypper in -y sassc libostree appstream-glib
        git clone https://github.com/vinceliuice/Fluent-gtk-theme.git
        cd Fluent-gtk-theme
        SUDO ./install.sh -t all -c -s -i
        SUDO ./install.sh --tweaks round
        SUDO ./install.sh --tweaks blur
        SUDO ./install.sh --tweaks square

        cd ..
        ################
        git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
        cd Tela-circle-icon-theme
        SUDO ./install.sh -a
        cd ..
        ###############
        git clone https://github.com/vinceliuice/Fluent-icon-theme.git
        cd Fluent-icon-theme
        SUDO ./install.sh -a -r
        cd ..
        ###############

        cd Fluent-icon-theme
        cd cursors
        SUDO ./install.sh
        cd ../..

    }

    WSL_THEME
    sleep 3
    SUDO gsettings set org.gnome.desktop.interface cursor-theme Fluent-cursors
    SUDO gsettings set org.gnome.desktop.interface gtk-theme Fluent-Dark
    SUDO gsettings set org.gnome.desktop.interface icon-theme Fluent-dark
    SUDO gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

    gsettings set org.gnome.desktop.interface cursor-theme Fluent-cursors
    gsettings set org.gnome.desktop.interface gtk-theme Fluent-Dark
    gsettings set org.gnome.desktop.interface icon-theme Fluent-dark
    gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

fi