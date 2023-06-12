#!/bin/bash
if checkwsl; then

    mkdir -p themeconfig
    cd themeconfig

    sudo zypper in -y libsass-3_6_5-1 sassc libostree appstream-glib
    git clone https://github.com/vinceliuice/Fluent-gtk-theme.git
    cd Fluent-gtk-theme
    sudo ./install.sh -t -all -c -s -i
    sudo ./install.sh --tweaks round
    sudo ./install.sh --tweaks blur
    sudo ./install.sh --tweaks square

    cd ..
    ################
    git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
    cd Tela-circle-icon-theme
    sudo ./install.sh -a
    cd ..
    ###############
    git clone https://github.com/vinceliuice/Fluent-icon-theme.git
    cd Fluent-icon-theme
    sudo ./install.sh -a -r
    cd ..
    ###############

    cd Fluent-icon-theme
    cd cursors
    sudo ./install.sh
    cd ../..

    sleep 3

    sudo gsettings set org.gnome.desktop.interface cursor-theme Fluent-cursors
    sudo gsettings set org.gnome.desktop.interface gtk-theme Fluent-Dark
    sudo gsettings set org.gnome.desktop.interface icon-theme Fluent-dark
    sudo gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

    gsettings set org.gnome.desktop.interface cursor-theme Fluent-cursors
    gsettings set org.gnome.desktop.interface gtk-theme Fluent-Dark
    gsettings set org.gnome.desktop.interface icon-theme Fluent-dark
    gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

    sudo cp $ScriptFolder/data/wsl.conf /etc/wsl.conf

fi
