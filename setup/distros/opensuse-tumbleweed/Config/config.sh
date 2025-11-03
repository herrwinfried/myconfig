#!/bin/bash

chmod 755 $GetDataDir/scripts/*
SUDO rsync -a --info=progress2 --force $GetDataDir/scripts/ /usr/local/bin/

shopt -s dotglob

rsync -a --info=progress2 --force -L $GetDataDir/home/ $HOME/
SUDO su -c "rsync -a --info=progress2 --force -L $GetDataDir/home/ /root/"

SUDO su -c "rsync -a --info=progress2 --force -L $GetDataDir/root/ /root/"

if isWsl; then
    SUDO su -c "rsync -a --info=progress2 --force -L $GetDataDir/rootWSL/ /"
fi

shopt -u dotglob

if [ -f $XDG_DESKTOP_DIR/trash.desktop ]; then
    SUDO chattr +i $XDG_DESKTOP_DIR/trash.desktop
fi

if ! isWsl; then

    if [[ $(hostname) == "${config[new_hostname]}" ]]; then
        red_message "$(GetLanguage ALREADY_HOSTNAME)"
    else
        SUDO hostnamectl set-hostname "${config[new_hostname]}" || {
            echo "${config[new_hostname]}" | sudo tee /etc/hostname
        }

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

    SUDO usermod -aG video $USER
fi

if [ -f "/bin/zsh" ]; then
    SUDO usermod -s /bin/zsh "$USER"
fi

if rpm -q systemd-zram-service &>/dev/null; then
    if [ -f /usr/lib/systemd/system/zramswap.service ]; then
        SUDO systemctl enable --now zramswap
    fi
fi

if systemctl status cups.service &>/dev/null; then
    #SUDO adduser $home lpadmin
    SUDO service cups start
    SUDO systemctl enable --now cups
fi

if systemctl status cockpit.socket &>/dev/null; then
    SUDO systemctl enable --now cockpit.socket
fi

# KDE
if ! isWsl && [ "$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')" = "kde" ]; then
    mkdir -p ~/.config/environment.d
    echo -e '[Environment]\nKWIN_IM_SHOW_ALWAYS=1' | tee ~/.config/environment.d/kwin_virtualkeyboard.conf
fi

CreateDirectory $HOME/source folder-build
CreateDirectory $HOME/source/gitlab
CreateDirectory $HOME/source/github
CreateDirectory $HOME/source/local

if ! isWsl; then
mkdir -p $XDG_VIDEOS_DIR/OBS
mkdir -p $XDG_VIDEOS_DIR/Kdenlive
mkdir -p $XDG_VIDEOS_DIR/davinci
fi