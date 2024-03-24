if ! checkwsl ; then
    if [ -f /usr/local/bin/discord-installer ]; then
        /usr/local/bin/discord-installer ptb
        /usr/local/bin/discord-installer canary

        /opt/DiscordPTB/DiscordPTB & 
        sleep 5
        killall DiscordPTB
    fi
fi