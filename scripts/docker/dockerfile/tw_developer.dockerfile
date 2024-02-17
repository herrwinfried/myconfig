FROM registry.opensuse.org/opensuse/tumbleweed:latest

LABEL maintainer="Winfried <contact@herrwinfried.me>"
LABEL description="The dockerfile file I prepared to use the developer tools on openSUSE Tumbleweed"

# If you want the user account and root password to be changed,
# set the value to "0"; otherwise, set it to "1".

ARG enable_account=0

# Installs the packages required for the distrobox.
# 1 = disable , 0 = enable
ARG distroboxPackage=1

# Username of the account to be created

ARG Username=winfried

#The group(s) the user will be added to
#tested for a single group.
ARG Groups=wheel

# Specify a default terminal for ARG user.
ARG Terminal=/bin/zsh

#Enter a password for ARG User.
ARG password=1234

#Enter a password for Root/Super User
#If you want to make it the same as your user account, use ${password}
ARG rootPassword=${password}

#home directory of the user I created.
ARG HomePWD=/home/${Username}

#for SSH port
EXPOSE 22

# HELP ME!!!
    # mkdir -p $XDG_PUBLICSHARE_DIR/dockerHost
    # ln -s $XDG_PUBLICSHARE_DIR/dockerHost ~/dockerHost
    #Podman
        # podman build --format docker -t herrwinfried/dev_env:opensuse_tumbleweed . -f ./tw_developer.dockerfile
        # podman run -it --name tw_development -p 3256:22 -v $XDG_PUBLICSHARE_DIR/dockerHost:/mnt/dockerHost:rw herrwinfried/dev_env:opensuse_tumbleweed
    #Docker
        # docker build -t herrwinfried/dev_env:opensuse_tumbleweed . -f ./tw_developer.dockerfile
        # docker run -it --name tw_development -p 3256:22 -v $XDG_PUBLICSHARE_DIR/dockerHost:/mnt/dockerHost:rw herrwinfried/dev_env:opensuse_tumbleweed
    # Distrobox
        # docker build --build-arg enable_account=1 --build-arg distroboxPackage=0 -t herrwinfried/dev_env:distrobox_osusetw . -f ./tw_developer.dockerfile
        # podman build --format docker --build-arg enable_account=1 --build-arg distroboxPackage=0 -t herrwinfried/dev_env:distrobox_osusetw . -f ./tw_developer.dockerfile

# Repositories

    # Packman Essentials
        RUN zypper -n --gpg-auto-import-keys --no-gpg-checks ar -n "Packman Essentials" -cfp 90 "https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/" packman-essentials
        RUN zypper -n --gpg-auto-import-keys --no-gpg-checks refresh
        RUN zypper -n --gpg-auto-import-keys --no-gpg-checks dup -y -l --from packman-essentials --allow-vendor-change
    # MongoDB
        RUN rpm --import https://www.mongodb.org/static/pgp/server-6.0.asc
        RUN zypper -n --gpg-auto-import-keys --no-gpg-checks addrepo -n "Mongodb" --gpgcheck "https://repo.mongodb.org/zypper/suse/15/mongodb-org/6.0/x86_64/" mongodb
    # Microsoft Repository
        RUN zypper -n --gpg-auto-import-keys --no-gpg-checks in -y -l libicu wget
        RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
        RUN wget https://packages.microsoft.com/config/opensuse/15/prod.repo
        RUN mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
        RUN chown root:root /etc/zypp/repos.d/microsoft-prod.repo
    # Snapd
        RUN zypper -n --gpg-auto-import-keys --no-gpg-checks addrepo -n "Snappy" -d "https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed" snappy
    # PostreSQL
        RUN zypper -n --gpg-auto-import-keys --no-gpg-checks addrepo -n "PostgreSQL" --refresh -p 90  http://download.opensuse.org/repositories/server:database:postgresql/openSUSE_Tumbleweed/ PostgreSQL

# END Repositories

# Package Download & Install

        RUN zypper -n --gpg-auto-import-keys in -t pattern -y -l base

        RUN zypper -n --gpg-auto-import-keys in -y -l \
            psmisc which shadow hostname iputils net-tools wget curl \
            nano lsb-release xdg-user-dirs openssh-server \
            zsh bash-completion fish lzip unrar unzip \
            cnf-rs cnf-rs-bash cnf-rs-zsh java-21-openjdk \
            neofetch screenfetch htop git git-lfs

    #DNF

        RUN zypper -n --gpg-auto-import-keys install -y dnf libdnf-repo-config-zypp python3-dnf-plugin-versionlock python3-dnf-plugins-core
        RUN dnf -q --nogpgcheck makecache -y
        RUN if [ "$(grep protect_running_kernel /etc/dnf/dnf.conf)" ]; then echo $red"protect_running_kernel is available. The value will not be written.$white"; else echo "protect_running_kernel=False" | tee -a /etc/dnf/dnf.conf; fi

    # Powershell Core
        RUN zypper -n --gpg-auto-import-keys in -y -l curl tar libicu73 libopenssl1_0_0 jq
        RUN pwshcore=$(curl -s "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" | jq -r ".assets[] | select(.name | test(\"linux-x64.tar.gz\")) | .browser_download_url") ; curl -L $pwshcore -o /tmp/powershell.tar.gz
        RUN mkdir -p /opt/microsoft/powershell
        RUN tar -xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/
        RUN ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
        RUN chmod +x /usr/bin/pwsh

    # Development #--no-recommends

        RUN zypper -n --gpg-auto-import-keys install -y -l \
            patterns-devel-C-C++-devel_C_C++ gdb llvm-clang gcc gcc-c++ \
            cmake cmake-full extra-cmake-modules \
            #qt6-base-devel qt6-declarative-devel \
            rust cargo \
            dotnet-sdk-7.0 patterns-devel-mono-devel_mono \
            patterns-devel-base-devel_rpm_build \
            nodejs-default npm-default \
            #gtk3-devel \
            python311 python311-pip rsync build ninja
        RUN if [ "$distroboxPackage" -eq 0 ]; then \
        zypper --non-interactive install --no-recommends bash Mesa-dri bash-completion bc bzip2 curl diffutils findutils glibc-locale glibc-locale-base gnupg hostname iputils keyutils less libvte-2_91-0 libvulkan1 libvulkan_intel libvulkan_radeon lsof man man-pages mtr ncurses nss-mdns openSUSE-release openssh-clients pam pam-extra pigz pinentry procps rsync shadow sudo system-group-wheel systemd time timezone tree unzip util-linux util-linux-systemd vte wget words xauth zip && zypper al parallel-printer-support && zypper clean && sed -i 's/.*solver.onlyRequires.*/solver.onlyRequires = false/g' /etc/zypp/zypp.conf && sed -i 's/.*rpm.install.excludedocs.*/rpm.install.excludedocs = no/g' /etc/zypp/zypp.conf; \
        fi
# END Package Download & Install

# SSH

    # generate an ssh key
        RUN ssh-keygen -A
    # allow root logins for ssh
        RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /usr/etc/ssh/sshd_config
    # allow password login for ssh
        RUN sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /usr/etc/ssh/sshd_config
        RUN sed -i 's/#PermitEmptyPasswords/PermitEmptyPasswords/' /usr/etc/ssh/sshd_config

# END SSH

# User
    # Create User
        RUN if [ "$enable_account" -eq 0 ]; then \
            for out in $Groups; do if grep -q "^$out:" /etc/group; then echo "$out already exists."; else groupadd $out; fi; done ; \
            useradd -m $Username -G $Groups -s $Terminal -p $password ; \
            echo "$Username:$password" | chpasswd ; \
            echo "root:$rootPassword" | chpasswd ;\
        fi
    # HomeBrew
        RUN if [ "$enable_account" -eq 0 ]; then \
            mkdir -p /home/linuxbrew/.linuxbrew ;\
            chown -R $Username /home/linuxbrew/.linuxbrew ;\
            su -l $Username -c 'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" ; chmod -R go-w "$(brew --prefix)/share/zsh"' ;\
            su -s /bin/bash -l $Username -c 'if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; function brewInstall { /home/linuxbrew/.linuxbrew/bin/brew install $1 </dev/null; }; function brewInstallCask { /home/linuxbrew/.linuxbrew/bin/brew install --cask $1 </dev/null; }; brewInstall oh-my-posh; fi' ;\
        else \
        touch /usr/local/bin/homebrewInstall ;\
        echo -e '#!/bin/bash\nNONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" ; chmod -R go-w "$(brew --prefix)/share/zsh"' | tee /usr/local/bin/homebrewInstall ;\
        chmod +x /usr/local/bin/homebrewInstall ;\
        fi
    # Config
        RUN if [ "$enable_account" -eq 0 ]; then \
            su -l $Username -c "mkdir -p $HomePWD/.poshthemes" ;\
            su -l $Username -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/default.omp.json -O $HomePWD/.poshthemes/default.omp.json" ;\
            su -l $Username -c "chmod u+rw $HomePWD/.poshthemes/*.omp.*" ;\
            su -l $Username -c "mkdir -p $HomePWD/.config" ;\
            su -l $Username -c "mkdir -p $HomePWD/.config/powershell" ;\
            su -l $Username -c "mkdir -p $HomePWD/.config/fish" ;\
            su -l $Username -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.alias -O $HomePWD/.alias" ;\
            su -l $Username -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.alias.ps1 -O $HomePWD/.alias.ps1" ;\
            su -l $Username -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.alias.fish -O $HomePWD/.alias.fish" ;\
            su -l $Username -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.bashrc -O $HomePWD/.bashrc" ;\
            su -l $Username -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.zshrc -O $HomePWD/.zshrc" ;\
            su -l $Username -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.config/powershell/Microsoft.PowerShell_profile.ps1 -O $HomePWD/.config/powershell/Microsoft.PowerShell_profile.ps1" ;\
            su -l $Username -c "wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.config/fish/config.fish -O $HomePWD/.config/fish/config.fish" ;\
            su -l $Username -c "ln -s /home/host/.ssh $HomePWD/.ssh" ;\
            su -s /bin/fish -l $Username -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish" ;\
        fi
    # SSH Config
        RUN if [ "$enable_account" -eq 0 ]; then \
            su -l $Username -c "touch $HomePWD/sshstart.sh" ;\
            su -l $Username -c "echo -e '#!/bin/bash\n/usr/sbin/sshd -D' | tee $HomePWD/sshstart.sh" ;\
            su -l $Username -c "chmod +x $HomePWD/sshstart.sh" ;\
        else \
        touch /usr/local/bin/SSH_Start.sh ;\
        echo -e '#!/bin/bash\n/usr/sbin/sshd -D' | tee /usr/local/bin/SSH_Start.sh ;\
        chmod +x /usr/local/bin/SSH_Start.sh ;\
        fi

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

RUN ln -sf $HomePWD/sshstart.sh /root/sshstart.sh

RUN ln -sf $HomePWD/.poshthemes /root/.poshthemes

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

RUN if [ "$enable_account" -eq 0 ]; then \
    export USER=${Username};    \
fi

CMD if [ "$enable_account" -eq 0 ]; then \
    su -l ${USER}; \
fi
