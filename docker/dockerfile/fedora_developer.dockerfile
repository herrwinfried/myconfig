FROM fedora:38

LABEL maintainer="Winfried <contact@herrwinfried.me>"
LABEL description="The dockerfile file I prepared to use the developer tools on Fedora 38"

# Username of the account to be created

ARG user=winfried

#The group(s) the user will be added to
#tested for a single group.
ARG group=wheel

# Specify a default terminal for ARG user.
ARG Terminal=/bin/fish

#Enter a password for ARG User.
ARG password=1234

#Enter a password for Root/Super User
#If you want to make it the same as your user account, use ${password}
ARG rootPassword=${password}

#home directory of the user I created.
ARG HomePWD=/home/${user}

# HELP ME!!!
# docker build -t herrwinfried/dev_env:fedora38 . -f ./fedora_developer.dockerfile
# mkdir -p ~/.config/dockerHost
# ln -s ~/.config/dockerHost ~/dockerHost
# docker run -it --name fedora_development -v ~/.config/dockerHost:/home/host:rw herrwinfried/dev_env:fedora38

# Repositories
#RPMFusion Repository
RUN dnf --nogpgcheck install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#Powershell Repository
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo | tee /etc/yum.repos.d/microsoft.repo

#MongoDB Repository
RUN dnf --nogpgcheck install -y dnf-plugins-core dnf-utils
RUN rpm --import https://www.mongodb.org/static/pgp/server-6.0.asc
RUN dnf --nogpgcheck config-manager -y --add-repo https://repo.mongodb.org/yum/redhat/6/mongodb-org/6.0/x86_64/

RUN dnf --nogpgcheck makecache
RUN dnf --nogpgcheck update -y
#^^^^^^^^^^^ Repositories ^^^^^^^^^^^

RUN dnf --nogpgcheck install -y @core @base-x
RUN dnf --nogpgcheck install -y which shadow-utils hostname net-tools iputils zsh fish bash-completion

RUN dnf --nogpgcheck install -y neofetch screenfetch hwinfo htop zsh fish bash-completion git git-lfs curl wget redhat-lsb-core lzip unzip unrar e2fsprogs nano powershell sudo

RUN dnf --nogpgcheck install -y curl tar jq

# ADD USER

RUN for out in ${group}; do if grep -q "^$out:" /etc/group; then echo "$out already exists."; else groupadd $out; fi; done
RUN useradd -m ${user} -G ${group} -s ${Terminal} -p ${password}
RUN echo "${user}:${password}" | chpasswd
RUN echo "root:${rootPassword}" | chpasswd

#HOMEBREW 
RUN mkdir -p /home/linuxbrew/
RUN ln -s /home/homebrew/ /home/linuxbrew/.linuxbrew
RUN git clone https://github.com/Homebrew/brew /home/homebrew
RUN chown -R ${user} /home/homebrew
RUN su -l ${user} -c 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; brew update --force --quiet ; chmod -R go-w "$(brew --prefix)/share/zsh"'

# DEVELOPMENT
RUN dnf --nogpgcheck install -y @c-development

RUN dnf --nogpgcheck install -y build gdb ninja-build clang gcc gcc-c++ cmake

RUN dnf --nogpgcheck install -y rust cargo

RUN dnf --nogpgcheck install -y dotnet-sdk-7.0

RUN dnf --nogpgcheck install -y @rpm-development-tools

RUN dnf --nogpgcheck install -y @kf5-software-development qt5-qtbase-devel qt6-qtbase-devel

RUN dnf --nogpgcheck install -y rsync gtk3-devel java-19-openjdk nodejs nodejs-npm python3

# CONFIG
RUN su -s /bin/bash -l ${user} -c 'if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; function brewInstall { /home/linuxbrew/.linuxbrew/bin/brew install $1 </dev/null; }; function brewInstallCask { /home/linuxbrew/.linuxbrew/bin/brew install --cask $1 </dev/null; }; brewInstall oh-my-posh; fi'

#${USER}
RUN su -l ${user} -c "mkdir -p ${HomePWD}/.poshthemes"
RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/default.omp.json -O ${HomePWD}/.poshthemes/default.omp.json"
RUN su -l ${user} -c "chmod u+rw ${HomePWD}/.poshthemes/*.omp.*"

RUN su -l ${user} -c "mkdir -p ${HomePWD}/.config"
RUN su -l ${user} -c "mkdir -p ${HomePWD}/.config/powershell"

RUN su -l ${user} -c "mkdir -p ${HomePWD}/.config/fish"

RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias -O ${HomePWD}/.alias"
RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias.ps1 -O ${HomePWD}/.alias.ps1"
RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias.fish -O ${HomePWD}/.alias.fish"
RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.bashrc -O ${HomePWD}/.bashrc"
RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.zshrc -O ${HomePWD}/.zshrc"

RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.config/powershell/Microsoft.PowerShell_profile.ps1 -O ${HomePWD}/.config/powershell/Microsoft.PowerShell_profile.ps1"

RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.config/fish/config.fish -O ${HomePWD}/.config/fish/config.fish"

RUN su -l ${user} -c "ln -s /home/host/.ssh ${HomePWD}/.ssh"

RUN su -l ${user} -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
RUN su -l ${user} -c "fisher install dracula/fish"
RUN su -l ${user} -c 'fish_config theme choose "Dracula Official"'

# Root

# this one is for my ohmyposh theme. If you don't want docker special marks to appear,
# you need to delete the value directly. It will work as long as a value is kept in it.

#bash
RUN echo -e "\n# this one is for my ohmyposh theme. If you don't want docker special marks to appear,\n# you need to delete the value directly. It will work as long as a value is kept in it.\nexport Docker_enabled=1\n" | tee -a /etc/profile.d/dockerenvimage.sh
#fish
RUN echo -e "\n# this one is for my ohmyposh theme. If you don't want docker special marks to appear,\n# you need to delete the value directly. It will work as long as a value is kept in it.\nset -x Docker_enabled 1\n" | tee -a /etc/fish/conf.d/dockerenvimage.fish
#powershell core
SHELL [ "/bin/pwsh", "-Command"]
RUN "`n# this one is for my ohmyposh theme. If you don't want docker special marks to appear,`n# you need to delete the value directly. It will work as long as a value is kept in it.`n`$env:Docker_enabled = '1'`n" | Out-File -FilePath $PSHOME/Microsoft.Powershell_profile.ps1 -Append -Encoding UTF8
SHELL [ "/bin/sh", "-c"]

RUN ln -sf ${HomePWD}/.poshthemes /root/.poshthemes

RUN mkdir -p /root/.config
RUN mkdir -p /root/.config/powershell

RUN mkdir -p /root/.config/fish

RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias -O /root/.alias
RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias.ps1 -O /root/.alias.ps1
RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias.fish -O /root/.alias.fish

RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.bashrc -O /root/.bashrc
RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.zshrc -O /root/.zshrc

RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.config/powershell/Microsoft.PowerShell_profile.ps1 -O /root/.config/powershell/Microsoft.PowerShell_profile.ps1

RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.config/fish/config.fish -O /root/.config/fish/config.fish

RUN curl -L https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/scripts/SystemUpdate -o /usr/local/bin/SystemUpdate

#USER ${user}

#The reason for adding this is because strangely the user 
#I selected didn't add the USER variable.
ENV USER=${user}

CMD su -l ${USER}
