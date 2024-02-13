test -s ~/.alias && . ~/.alias || true

if [ -f /etc/profile.d/bash_completion.sh ]; then
    . /etc/profile.d/bash_completion.sh
fi
