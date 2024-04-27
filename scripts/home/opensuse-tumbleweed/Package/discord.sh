#!/bin/bash
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
}
        Discord_Installer stable
        Discord_Installer ptb
        Discord_Installer canary
        Discord_Installer development

        /opt/DiscordPTB/DiscordPTB &
        sleep 150
        killall DiscordPTB

fi
