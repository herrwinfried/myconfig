#!/bin/bash
Package_a="docker docker-compose docker-compose-switch yast2-docker podman distrobox"
Package_a_Flatpak="flathub io.podman_desktop.PodmanDesktop"

if ! checkwsl; then

    if [[ ! -d "$XDG_DESKTOP_DIR/dotscript" ]]; then 
        mkdir -p "$XDG_DESKTOP_DIR/dotscript"
    fi
    SUDO $Package $PackageInstall $Package_a
    
    SUDO $FlatpakPackage $FlatpakPackageInstall $Package_a_Flatpak
    
    SUDO usermod -G docker -a $Username
    ######### DOCKER ROOTLESS ##############################
    /usr/bin/dockerd-rootless-setuptool.sh install
        #OR
        #curl -fsSL https://get.docker.com/rootless | sh
    touch $XDG_DESKTOP_DIR/dotscript/docker-user-socket.sh

    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    #                           "🌏 Docker Desktop file"
    echo "
#!/bin/bash
echo "export DOCKER_HOST=unix:///run/user/1000/docker.sock" >> $HomePWD/.alias
echo "export PATH=/home/$Username/bin:\$PATH" >> $HomePWD/.alias

systemctl --user enable --now docker.service
systemctl --user enable --now docker.socket

" > $XDG_DESKTOP_DIR/dotscript/docker-user-socket.sh
    chmod +x $XDG_DESKTOP_DIR/dotscript/docker-user-socket.sh
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    #                               "🌏 Podman Desktop file"
    touch $XDG_DESKTOP_DIR/dotscript/podman-user-socket.sh
    echo "
#!/bin/bash
systemctl --user enable --now podman.service podman.socket
" > $XDG_DESKTOP_DIR/dotscript/podman-user-socket.sh
    chmod +x $XDG_DESKTOP_DIR/dotscript/podman-user-socket.sh
fi
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^