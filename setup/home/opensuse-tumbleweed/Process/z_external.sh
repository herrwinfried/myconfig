#!/bin/bash


function FireFox-Dev_install {
  if ! CheckWsl ; then 
  
  URL="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
  TMP_FILE="/tmp/firefox-developer.tar.bz2"
  TARGET_DIR="/opt/FirefoxDeveloper"
  FILE_NAME="firefox"
  BIN_FILENAME="${FILE_NAME}-dev"
  
  test -f $TMP_FILE && SUDO rm -f $TMP_FILE
  wget -O $TMP_FILE "$URL"
  test -d $TARGET_DIR && SUDO rm -rf $TARGET_DIR
  SUDO mkdir -p $TARGET_DIR
  SUDO tar -xjf $TMP_FILE -C $TARGET_DIR
  SUDO mv $TARGET_DIR/${FILE_NAME}  $TARGET_DIR/${FILE_NAME}-folder
  SUDO mv $TARGET_DIR/${FILE_NAME}-folder/* $TARGET_DIR
  SUDO chmod +x $TARGET_DIR/$FILE_NAME
  SUDO ln -sf $TARGET_DIR/$FILE_NAME /usr/bin/${BIN_FILENAME}
  SUDO mkdir -p /usr/local/share/applications
  SUDO cp -f /usr/share/applications/firefox.desktop /usr/local/share/applications/firefox-dev.desktop
  SUDO sed -i 's/firefox/firefox-dev/g' /usr/local/share/applications/firefox-dev.desktop
  SUDO sed -i 's/Firefox/Firefox-dev/g' /usr/local/share/applications/firefox-dev.desktop
  SUDO sed -i 's/Icon=firefox-dev/Icon=\/opt\/FirefoxDeveloper\/browser\/chrome\/icons\/default\/default128.png/g' /usr/local/share/applications/firefox-dev.desktop
  
  fi
}

function Discord_install {
  if ! CheckWsl ; then
  function Discord_Installer {
      SUDO $Package $PackageInstall curl tar jq
      function errorHelp {
          echo "ERROR! Example: $0 PTB"
          echo "development, canary, ptb, stable"
          exit 1
      }
  
      if [ $# -eq 0 ]; then
          errorHelp
          exit 1
      fi
  
      n1=$(echo "$1" | tr '[:upper:]' '[:lower:]')
      if [ "$n1" == "development" ]; then
          Version="development"
          AppName="DiscordDevelopment"
      elif [ "$n1" == "canary" ]; then
          Version="canary"
          AppName="DiscordCanary"
      elif [ "$n1" == "ptb" ]; then
          Version="ptb"
          AppName="DiscordPTB"
      elif [ "$n1" == "stable" ]; then
          Version=""
          AppName="Discord"
      fi
      
      InternetCheck no "https://discord.com"
      if [ $? -ne 0 ]; then
  
      test -d "/opt/${AppName}" && SUDO rm -rf "/opt/${AppName}"
      test -f "/tmp/${AppName}.tar.gz" && SUDO rm -rf "/tmp/${AppName}.tar.gz"
  
  
      if [[ -z $Version ]]; then 
      # shellcheck disable=SC2086
      curl -L "https://discord.com/api/download?platform=linux&format=tar.gz" -o "/tmp/${AppName}.tar.gz"
      else
      # shellcheck disable=SC2086
      curl -L "https://discord.com/api/download/$Version?platform=linux&format=tar.gz" -o "/tmp/${AppName}.tar.gz"
      fi
  
      SUDO mkdir -p "/opt/${AppName}"
      sleep 3
  
      # shellcheck disable=SC2086
      SUDO tar -xzf "/tmp/${AppName}.tar.gz" -C /opt/
  
      SUDO su -c "echo \"[Desktop Entry]
      Name=${AppName}
      StartupWMClass=${AppName}
      Comment=All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.
      GenericName=Internet Messenger
      Exec=/opt/${AppName}/${AppName}
      Icon=/opt/${AppName}/discord.png
      Type=Application
      Categories=Network;InstantMessaging;
      Path=/opt/${AppName}\" | tee /usr/share/applications/${AppName}.desktop"
  
      SUDO chmod -R 777 "/opt/${AppName}"
      fi
  }
          Discord_Installer stable
          Discord_Installer ptb
          Discord_Installer canary
  fi
}

function Powershell_install {
  function Install {
  SUDO $Package $PackageInstall curl tar jq
  if [[ -x $(command -v pwsh) ]]; then
      PWSH_REGEX="(\d+\.\d+\.\d+)"
      # shellcheck disable=SC2046
      # shellcheck disable=SC2005
      PWSH_VERSION=v$(echo $(pwsh --version) | grep -oP "$PWSH_REGEX")
      CURRENT_PWSH=$(curl -s "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" | jq -r ".tag_name")
  fi
  
  if [ -z "$PWSH_VERSION" ]; then
      Download
  elif [[ $PWSH_VERSION != "$CURRENT_PWSH" ]]; then
      Download
  elif [[ $PWSH_VERSION == "$CURRENT_PWSH" ]]; then
      echo -e "${Yellow}Powershell looks up to date. That's why it won't download. ${NoColor}"
  fi
  }
  
  function Download {
  
      PWSH_URL=$(curl -s "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" | jq -r ".assets[] | select(.name | test(\"linux-x64.tar.gz\")) | .browser_download_url")
      test -d "/tmp/powershell.tar.gz" && SUDO rm -rf "/tmp/powershell*"
      test -d "/opt/microsoft/powershell" && SUDO rm -rf "/opt/microsoft/powershell"
      test -f /usr/bin/pwsh && SUDO rm -f "/usr/bin/pwsh"
      sleep 3; curl -L "$PWSH_URL" -o /tmp/powershell.tar.gz 
      SUDO mkdir -p /opt/microsoft/powershell
      SUDO tar -xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/
      SUDO ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
      SUDO chmod +x /usr/bin/pwsh
  }
  
  Install
}

Powershell_install
FireFox-Dev_install
Discord_install
ExternalPackage
