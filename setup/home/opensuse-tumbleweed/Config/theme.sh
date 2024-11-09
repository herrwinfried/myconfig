#!/bin/bash

function grubTheme {
  if [[ $BOARD_VENDOR == *"asus"* ]]; then
  SUDO $Package $PackageInstall curl tar jq
  
  asustheme=$(curl -s "https://api.github.com/repos/AdisonCavani/distro-grub-themes/releases/latest" | jq -r ".assets[] | select(.name | test(\"asus.tar\")) | .browser_download_url")
  DEFAULT_GRUB_THEME="GRUB_THEME=/boot/grub2/themes/openSUSE/theme.txt"
  if [ -d "/tmp/asus.tar" ]; then
      SUDO rm -rf /tmp/asus*
  fi
  
  if [ -d "/boot/grub2.d/themes/asus" ]; then
      echo -e "${Yellow}Removing the /boot/grub2.d/themes/asus folder..${NoColor}"
      SUDO rm -rf /boot/grub2.d/themes/asus
      if [ "$current_grub_theme" != "$DEFAULT_GRUB_THEME" ]; then
      SUDO sed -i "s|^GRUB_THEME=.*|$DEFAULT_GRUB_THEME|" /etc/default/grub
      echo -e "${Green}GRUB_THEME value successfully reverted to its initial state.${NoColor}"
  fi
  fi
  sleep 3
  
  curl -L "$asustheme" -o "/tmp/asus.tar"
  
  SUDO mkdir -p /boot/grub2.d/themes/asus
  SUDO tar -xf "/tmp/asus.tar" -C /boot/grub2.d/themes/asus
  
  new_grub_theme="GRUB_THEME=/boot/grub2.d/themes/asus/theme.txt"
  current_grub_theme=$(grep -E "^GRUB_THEME=" /etc/default/grub)
  
  if [ "$current_grub_theme" != "$new_grub_theme" ]; then
      SUDO sed -i "s|^GRUB_THEME=.*|$new_grub_theme|" /etc/default/grub
      SUDO grub2-mkconfig -o /boot/grub2/grub.cfg
      echo -e "${Green}GRUB_THEME value successfully modified and Grub updated.${NoColor}"
  fi
  
  fi
}

function WSLTheme {
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
}

grubTheme
WSLTheme