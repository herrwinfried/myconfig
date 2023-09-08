FROM opensuse/tumbleweed

LABEL maintainer="Winfried <contact@herrwinfried.me>"
LABEL description="The dockerfile file I prepared to use the developer tools on openSUSE Tumbleweed"

# Username of the account to be created

ARG user=winfried

#The group(s) the user will be added to
#tested for a single group.
ARG group=wheel

# Specify a default terminal for ARG user.
ARG Terminal=/bin/zsh

#Enter a password for ARG User.
ARG password=1234

#Enter a password for Root/Super User
#If you want to make it the same as your user account, use ${password}
ARG rootPassword=${password}

#home directory of the user I created.
ARG HomePWD=/home/${user}

#for SSH port
EXPOSE 22

# HELP ME!!!
# docker build -t herrwinfried/dev_env:opensuse_tumbleweed . -f ./tw_developer.dockerfile 
# mkdir -p $XDG_PUBLICSHARE_DIR/dockerHost
# ln -s $XDG_PUBLICSHARE_DIR/dockerHost ~/dockerHost
# docker run -it --name tw_development -p 3256:22 -v $XDG_PUBLICSHARE_DIR/dockerHost:/home/host:rw herrwinfried/dev_env:opensuse_tumbleweed

# Repositories 
#Packman Repository
RUN zypper -n --gpg-auto-import-keys ar -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/ packman-essentials
RUN zypper -n --gpg-auto-import-keys refresh
RUN zypper -n --gpg-auto-import-keys dist-upgrade -y --from packman-essentials --allow-vendor-change

#Microsoft Repository
RUN zypper -n --gpg-auto-import-keys install -y libicu wget curl
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN wget https://packages.microsoft.com/config/opensuse/15/prod.repo
RUN mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
RUN chown root:root /etc/zypp/repos.d/microsoft-prod.repo

#MongoDB Repository
RUN rpm --import https://www.mongodb.org/static/pgp/server-6.0.asc
RUN zypper -n --gpg-auto-import-keys addrepo --gpgcheck "https://repo.mongodb.org/zypper/suse/15/mongodb-org/6.0/x86_64/" mongodb

RUN zypper -n --gpg-auto-import-keys refresh
RUN zypper -n --gpg-auto-import-keys dup -y -l
#^^^^^^^^^^^ Repositories ^^^^^^^^^^^

RUN zypper -n --gpg-auto-import-keys in -t pattern -y -l base

RUN zypper -n --gpg-auto-import-keys in -y -l which shadow hostname zsh fish bash-completion iputils net-tools net-tools-deprecated openssh

RUN zypper -n --gpg-auto-import-keys in -y -l neofetch screenfetch hwinfo htop ffmpeg git git-lfs curl wget lsb-release opi lzip unzip unrar e2fsprogs nano powerline-fonts sudo

RUN zypper -n --gpg-auto-import-keys in -y -l curl tar libicu73 libopenssl1_0_0 jq

#dnf --nogpgcheck Install
RUN zypper -n --gpg-auto-import-keys install -y dnf libdnf-repo-config-zypp python3-dnf-plugin-versionlock python3-dnf-plugins-core
RUN dnf -q --nogpgcheck makecache -y

RUN if [ "$(grep protect_running_kernel /etc/dnf/dnf.conf)" ]; then echo $red"protect_running_kernel is available. The value will not be written.$white"; else echo "protect_running_kernel=False" | tee -a /etc/dnf/dnf.conf; fi

RUN pwshcore=$(curl -s "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" | jq -r ".assets[] | select(.name | test(\"linux-x64.tar.gz\")) | .browser_download_url") ; curl -L $pwshcore -o /tmp/powershell.tar.gz
RUN mkdir -p /opt/microsoft/powershell
RUN tar -xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/
RUN ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
RUN chmod +x /usr/bin/pwsh

# generate an ssh key
RUN ssh-keygen -A
# allow root logins for ssh
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /usr/etc/ssh/sshd_config
# allow password login for ssh
RUN sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /usr/etc/ssh/sshd_config
RUN sed -i 's/#PermitEmptyPasswords/PermitEmptyPasswords/' /usr/etc/ssh/sshd_config
# ADD USER

RUN for out in ${group}; do if grep -q "^$out:" /etc/group; then echo "$out already exists."; else groupadd $out; fi; done
RUN useradd -m ${user} -G ${group} -s ${Terminal} -p ${password}
RUN echo "${user}:${password}" | chpasswd
RUN echo "root:${rootPassword}" | chpasswd

#HOMEBREW 
RUN mkdir -p /home/linuxbrew/.linuxbrew
RUN chown -R ${user} /home/linuxbrew/.linuxbrew
RUN su -l ${user} -c 'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" ; chmod -R go-w "$(brew --prefix)/share/zsh"'
# DEVELOPMENT
RUN dnf -q --nogpgcheck install --setopt=install_weak_deps=False -y patterns-devel-base-devel_basis patterns-devel-C-C++-devel_C_C++ 

RUN dnf -q --nogpgcheck install --setopt=install_weak_deps=False -y build gdb ninja llvm-clang gcc gcc-c++ cmake cmake-full extra-cmake-modules

RUN dnf -q --nogpgcheck install --setopt=install_weak_deps=False -y rust cargo

RUN dnf -q --nogpgcheck install --setopt=install_weak_deps=False -y dotnet-sdk-7.0

RUN dnf -q --nogpgcheck install -y patterns-devel-mono-devel_mono

RUN dnf -q --nogpgcheck install --setopt=install_weak_deps=False -y patterns-devel-base-devel_rpm_build

RUN dnf -q --nogpgcheck install --setopt=install_weak_deps=False -y rsync gtk3-devel java-20-openjdk nodejs-default npm-default python311
# CONFIG
RUN su -s /bin/bash -l ${user} -c 'if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; function brewInstall { /home/linuxbrew/.linuxbrew/bin/brew install $1 </dev/null; }; function brewInstallCask { /home/linuxbrew/.linuxbrew/bin/brew install --cask $1 </dev/null; }; brewInstall oh-my-posh; fi'

#${USER}
RUN su -l ${user} -c "mkdir -p ${HomePWD}/.poshthemes"
RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/default.omp.json -O ${HomePWD}/.poshthemes/default.omp.json"
RUN su -l ${user} -c "chmod u+rw ${HomePWD}/.poshthemes/*.omp.*"

RUN su -l ${user} -c "mkdir -p ${HomePWD}/.config"
RUN su -l ${user} -c "mkdir -p ${HomePWD}/.config/powershell"

RUN su -l ${user} -c "mkdir -p ${HomePWD}/.config/fish"

RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.alias -O ${HomePWD}/.alias"
RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.alias.ps1 -O ${HomePWD}/.alias.ps1"
RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.alias.fish -O ${HomePWD}/.alias.fish"
RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.bashrc -O ${HomePWD}/.bashrc"
RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.zshrc -O ${HomePWD}/.zshrc"

RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.config/powershell/Microsoft.PowerShell_profile.ps1 -O ${HomePWD}/.config/powershell/Microsoft.PowerShell_profile.ps1"

RUN su -l ${user} -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.config/fish/config.fish -O ${HomePWD}/.config/fish/config.fish"

RUN su -l ${user} -c "ln -s /home/host/.ssh ${HomePWD}/.ssh"

RUN su -s /bin/fish -l ${user} -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
RUN su -s /bin/fish -l ${user} -c "fisher install dracula/fish"
RUN su -l ${user} -c "touch ${HomePWD}/sshstart.sh"
RUN su -l ${user} -c "echo -e '#!/bin/bash\n/usr/sbin/sshd -D' | tee ${HomePWD}/sshstart.sh"
RUN su -l ${user} -c "chmod +x ${HomePWD}/sshstart.sh"

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

RUN ln -sf ${HomePWD}/sshstart.sh /root/sshstart.sh

RUN ln -sf ${HomePWD}/.poshthemes /root/.poshthemes

RUN mkdir -p /root/.config
RUN mkdir -p /root/.config/powershell

RUN mkdir -p /root/.config/fish

RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.alias -O /root/.alias
RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.alias.ps1 -O /root/.alias.ps1
RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.alias.fish -O /root/.alias.fish

RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.bashrc -O /root/.bashrc
RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.zshrc -O /root/.zshrc

RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.config/powershell/Microsoft.PowerShell_profile.ps1 -O /root/.config/powershell/Microsoft.PowerShell_profile.ps1

RUN wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.config/fish/config.fish -O /root/.config/fish/config.fish

RUN curl -L https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/scripts/SystemUpdate -o /usr/local/bin/SystemUpdate

#USER ${user}

#The reason for adding this is because strangely the user 
#I selected didn't add the USER variable.
ENV USER=${user}

CMD su -l ${USER}