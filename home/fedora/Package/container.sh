#!/bin/bash
Package_a="docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin https://desktop.docker.com/linux/main/amd64/docker-desktop-4.20.1-x86_64.rpm?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64"
Package_a+=" podman"
Package_a+=" distrobox"
Package_a_Flatpak="flathub io.podman_desktop.PodmanDesktop"

if ! checkwsl; then

    sudo $Package $PackageInstall $Package_a
    
    sudo $FlatpakPackage $FlatpakPackageInstall $Package_a_Flatpak
    
    sudo usermod -G docker -a $Username
    ######### DOCKER ROOTLESS ##############################
    curl -fsSL https://get.docker.com/rootless | sh
    touch $XDG_DESKTOP_DIR/docker-user-socket.sh

    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    #                           "🌏 Docker Desktop file"
    echo "
#!/bin/bash
echo "export DOCKER_HOST=unix:///run/user/1000/docker.sock" >> $HomePWD/.alias
echo "export PATH=/home/$Username/bin:\$PATH" >> $HomePWD/.alias

systemctl --user enable --now docker.service
systemctl --user enable --now docker.socket

" >$HomePWD/Masaüstü/docker-user-socket.sh
    chmod +x $HomePWD/Masaüstü/docker-user-socket.sh
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    #                               "🌏 Podman Desktop file"
    touch $XDG_DESKTOP_DIR/podman-user-socket.sh
    echo "
#!/bin/bash
systemctl --user enable --now podman.service podman.socket
" >$HomePWD/Masaüstü/podman-user-socket.sh
    chmod +x $HomePWD/Masaüstü/podman-user-socket.sh
fi
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
