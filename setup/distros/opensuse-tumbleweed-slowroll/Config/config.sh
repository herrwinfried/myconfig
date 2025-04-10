#!/bin/bash

chmod 755 $GetDataDir/scripts/*
SUDO rsync -a --info=progress2 --force $GetDataDir/scripts/ /usr/local/bin/

##################################################################################################################
shopt -s dotglob

rsync -a --info=progress2 --force -L $GetDataDir/home/ $HOME/

SUDO su -c "rsync -a --info=progress2 --force -L $GetDataDir/root/ /root/"

shopt -u dotglob

##################################################################################################################

if [ -f $XDG_DESKTOP_DIR/trash.desktop ]; then
    SUDO chattr +i $XDG_DESKTOP_DIR/trash.desktop
fi

if ! isWsl; then
    SUDO mkdir -p /boot/grub2.d
    SUDO mkdir -p /boot/grub2.d/themes
    if [[ $(hostname) == "${config[new_hostname]}" ]]; then
        echo "${COLORS[Red]}${LANG_ALREADY_HOSTNAME}${COLORS[NoColor]}"
    else
        SUDO hostnamectl set-hostname "${config[new_hostname]}"
    fi

    if is_command semanage; then
        SUDO semanage fcontext -a -t textrel_shlib_t "~/.local/share/Steam/compatibilitytools.d(/.*)?"
        SUDO restorecon -Rv ~/.local/share/Steam/compatibilitytools.d
        SUDO semanage fcontext -a -t textrel_shlib_t "~/Games(/.*)?"
        SUDO restorecon -Rv ~/Games
    fi
    if is_command setsebool; then
    SUDO setsebool -P selinuxuser_execmod 1
    SUDO setsebool -P selinuxuser_execstack 1
    fi
fi

if [ -f "/bin/zsh" ]; then
    SUDO usermod -s /bin/zsh "$USER"
fi

if rpm -q systemd-zram-service &>/dev/null; then
    if [ -f /usr/lib/systemd/system/zramswap.service ]; then
        SUDO systemctl enable --now zramswap
    fi
fi

if [ -f "/bin/fish" ] && [ ! -x "$(command -v fisher)" ]; then
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source ; fisher install jorgebucaran/fisher"
fi

if systemctl status cups.service &>/dev/null; then
    #SUDO adduser $home lpadmin
    SUDO service cups start
    SUDO systemctl start cups
    SUDO systemctl enable cups
fi

if [ -x "$(command -v snapper)" ]; then
    SUDO snapper -c home create-config /home
    SUDO snapper -c home create --description "New config"
fi

if ! lsmod | grep -q ntfs3; then
    SUDO /sbin/modprobe ntfs3
fi

mkdir -p $HOME/source
CreateDesktopEntry $HOME/source folder-build
mkdir -p $HOME/source/gitlab
mkdir -p $HOME/source/github
mkdir -p $XDG_VIDEOS_DIR/OBS
mkdir -p $XDG_VIDEOS_DIR/Kdenlive
mkdir -p $XDG_VIDEOS_DIR/MangoHud
