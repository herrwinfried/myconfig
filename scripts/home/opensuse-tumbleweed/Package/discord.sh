if ! checkwsl ; then

function Discord_Installer {
function errorHelp {
    echo "ERROR! Example: $0 PTB"
    echo "development, canary, ptb, stable"
    exit 1
}

if [ $# -eq 0 ]; then
    errorHelp
fi

n1=$(echo $1 | tr '[:upper:]' '[:lower:]')

if [ $n1 == "development" ]; then
    Version="development"
    ExecCom="DiscordDevelopment"
elif [ $n1 == "canary" ]; then
    Version="canary"
    ExecCom="DiscordCanary"
elif [ $n1 == "ptb" ]; then
    Version="ptb"
    ExecCom="DiscordPTB"
elif [ $n1 == "stable" ]; then
    Version=""
    ExecCom="Discord"
else
    errorHelp
fi

SUDO $Package $PackageInstall curl tar

sudo su -c "echo \"[Desktop Entry]
Name=Discord $Version
StartupWMClass=discord$Version
Comment=All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.
GenericName=Internet Messenger
Exec=/opt/$ExecCom/$ExecCom
Icon=/opt/$ExecCom/discord.png
Type=Application
Categories=Network;InstantMessaging;
Path=/opt/$ExecCom\" | tee /usr/share/applications/discord-$Version.desktop"

if [ -z $Version ]; then
curl -L "https://discord.com/api/download?platform=linux&format=tar.gz" -o /tmp/discord.tar.gz
else
curl -L "https://discord.com/api/download/$Version?platform=linux&format=tar.gz" -o /tmp/discord$Version.tar.gz
fi

SUDO mkdir -p /opt/$ExecCom

if [ -d "/tmp/discord$Version.tar.gz" ]; then
    SUDO rm -rf /tmp/discord*
fi

if [ -d "/opt/$ExecCom" ]; then
    SUDO rm -rf /opt/$ExecCom
fi

sleep 3

SUDO tar -xzf /tmp/discord$Version.tar.gz -C /opt/
SUDO chmod 777 /opt/$ExecCom
SUDO chmod 777 /opt/$ExecCom/*
}


        Discord_Installer stable
        Discord_Installer ptb
        Discord_Installer canary
        Discord_Installer development

        /opt/DiscordPTB/DiscordPTB &
        sleep 5
        killall DiscordPTB


fi
