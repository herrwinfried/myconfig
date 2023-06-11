FROM opensuse/tumbleweed

LABEL maintainer="Winfried <contact@herrwinfried.me>"
LABEL description="The dockerfile file I prepared to use the developer tools on openSUSE Tumbleweed"

ARG user=winfried-dc
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
# docker build -t winfried-opensuse-tw_development . -f ./tw_developer.dockerfile 
# mkdir -p ~/.config/dockerHost
# ln -s ~/.config/dockerHost ~/dockerHost
# docker run -it --name tw_development -v ~/.config/dockerHost:/home/host:rw winfried-opensuse-tw_development

# Repositories 
#Packman Repository
RUN zypper --gpg-auto-import-keys ar -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/ packman-essentials
RUN zypper --gpg-auto-import-keys refresh
RUN zypper --gpg-auto-import-keys dist-upgrade -y --from packman-essentials --allow-vendor-change

#Microsoft Repository
RUN zypper --gpg-auto-import-keys install -y libicu wget curl
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN wget https://packages.microsoft.com/config/opensuse/15/prod.repo
RUN mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
RUN chown root:root /etc/zypp/repos.d/microsoft-prod.repo

#MongoDB Repository
RUN rpm --import https://www.mongodb.org/static/pgp/server-6.0.asc
RUN zypper --gpg-auto-import-keys addrepo --gpgcheck "https://repo.mongodb.org/zypper/suse/15/mongodb-org/6.0/x86_64/" mongodb

#FileSystem Repository
RUN zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/filesystems/openSUSE_Tumbleweed/filesystems.repo

RUN zypper --gpg-auto-import-keys refresh
RUN zypper --gpg-auto-import-keys dup -y -l
#^^^^^^^^^^^ Repositories ^^^^^^^^^^^

RUN zypper --gpg-auto-import-keys in -t pattern -y -l base

RUN zypper --gpg-auto-import-keys in -y -l which shadow hostname busybox-net-tools zsh fish bash-completion

RUN zypper --gpg-auto-import-keys in -y -l neofetch screenfetch hwinfo htop ffmpeg git git-lfs curl wget lsb-release opi lzip unzip unrar e2fsprogs nano powerline-fonts

RUN zypper --gpg-auto-import-keys in -y -l curl tar libicu73 libopenssl1_0_0 jq

#DNF Install
RUN zypper --gpg-auto-import-keys install -y dnf libdnf-repo-config-zypp python3-dnf-plugin-versionlock python3-dnf-plugins-core
RUN dnf makecache -y
RUN if [ "$(cat /etc/dnf/dnf.conf | grep protect_running_kernel)" ]; then echo $red"protect_running_kernel is available. The value will be not written.$white"; else echo "protect_running_kernel=False" >> /etc/dnf/dnf.conf; fi

RUN pwshcore=$(curl -s "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" | jq -r ".assets[] | select(.name | test(\"linux-x64.tar.gz\")) | .browser_download_url") ; curl -L $pwshcore -o /tmp/powershell.tar.gz
RUN mkdir -p /opt/microsoft/powershell
RUN tar -xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/
RUN ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
RUN chmod +x /usr/bin/pwsh

RUN curl -s https://ohmyposh.dev/install.sh | bash -s

#CODECS / just in case
#RUN zypper --gpg-auto-import-keys install -y --from packman-essentials ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full


# DEVELOPMENT
RUN zypper --gpg-auto-import-keys in -y -l patterns-devel-base-devel_basis patterns-devel-C-C++-devel_C_C++ 

RUN zypper --gpg-auto-import-keys in -y -l build gdb ninja llvm-clang gcc gcc-c++ cmake cmake-full extra-cmake-modules

RUN zypper --gpg-auto-import-keys in -y -l dotnet-sdk-7.0

RUN zypper --gpg-auto-import-keys in -y -l --recommends patterns-devel-base-devel_rpm_build

RUN zypper --gpg-auto-import-keys in -t pattern -y -l --recommends devel_qt6 devel_kde_frameworks devel_qt5

RUN zypper --gpg-auto-import-keys in -y -l rsync gtk3-devel java-19-openjdk nodejs-default npm-default python311

# ADD USER

RUN groupadd ${group}
RUN useradd -m ${user} -G ${group} -s ${Terminal} -p ${password}

RUN echo "root:${rootPassword}" | chpasswd
# CONFIG

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

RUN sudo ln -sf ${HomePWD}/.poshthemes /root/.poshthemes

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

RUN curl -L https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/scripts/SystemUpdate -o $ScriptLocal/SystemUpdate

USER ${user}

#The reason for adding this is because strangely the user 
#I selected didn't add the USER variable.
ENV USER=${user}
