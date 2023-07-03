FROM mcr.microsoft.com/windows/server:ltsc2022

LABEL maintainer="Winfried <contact@herrwinfried.me>"
LABEL description="My windows development environment .(BETA)."

################################# NOTE ####################################################
# I'm creating the regular account for SSH, not for myself.                               #
# Unfortunately, it doesn't seem possible at the moment                                   #
# to start the container as administrator.                                                #
# So I created it for SSH, but logically it's a normal user account.                      #
###########################################################################################

# If you want to turn off Docker in OhMyPosh. You should remove the docker value in the file 
# "$PSHOME\Microsoft.Powershell_profile.ps1" in both powershell and powershell core. 
# It doesn't have any functions, I just added it to make docker custom definitions easily.

# Username of the account to be created
ARG LocalUsername="winfried"

#Enter a password for ARG LocalUsername.
ARG LocalPassword="admin&1234"

#Administrator account Password
#ARG adminPassword=""

#for SSH port
EXPOSE 22

# HELP ME!!!
#    docker build -t herrwinfried/dev_env:server-ltsc22 . -f ./server-ltsc22.dockerfile 
#    New-Item -Path "C:\" -Name "Host" -ItemType "directory"
#    docker run -it -v C:\Host:C:\Host:rw --name server -p 3256:22 herrwinfried/dev_env:server-ltsc22

# I want to use powershell instead of CMD

SHELL [ "powershell", "-ExecutionPolicy", "Bypass", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]

#USER
# If you entered a LocalUsername and LocalPassword value, remove the value below from the comment line.
RUN New-LocalUser -Name ${env:LocalUsername} -Password (ConvertTo-SecureString -String ${env:LocalPassword} -AsPlainText -Force) -FullName "${env:LocalUsername}" -Description 'Custom User'

# If the user will have admin authority, remove it from the comment line.
RUN Add-LocalGroupMember -Group administrators -Member ${env:LocalUsername}

#Administrator

# If you entered a adminPassword value, remove the value below from the two comment line. This will enable an admin account.
# RUN net user administrator /ACTIVE:YES
# RUN net user administrator ${env:adminPassword}

#chocolatey package manager
RUN iex (wget 'https://chocolatey.org/install.ps1' -UseBasicParsing)

#Installing packages via chocolatey

RUN choco.exe install -y --acceptlicense powershell-core

# Switch Powershell CORE
SHELL [ "pwsh", "-ExecutionPolicy", "Bypass", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]

# Install the OpenSSH Client
RUN Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Install the OpenSSH Server
RUN Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

RUN New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "(Get-Command pwsh).Source" -PropertyType String -Force

#Start SSH Service
RUN Start-Service sshd
RUN Set-Service -Name sshd -StartupType 'Automatic'

# msys2 install
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
  Invoke-WebRequest -UseBasicParsing -uri "https://github.com/msys2/msys2-installer/releases/download/nightly-x86_64/msys2-base-x86_64-latest.sfx.exe" -OutFile msys2.exe; \
  .\msys2.exe -y -oC:\; \
  Remove-Item msys2.exe ; \
  function msys() { C:\msys64\usr\bin\bash.exe @('-lc') + @Args; } \
  msys ' '; \
  msys 'pacman --noconfirm -Syuu'; \
  msys 'pacman --noconfirm -Syuu'; \
  msys 'pacman --noconfirm -Scc';

# nano installation via msys2
RUN function msys() { C:\msys64\usr\bin\bash.exe @('-lc') + @Args; } \
msys 'pacman --noconfirm -S nano';
RUN Start-Process PowerShell -Verb RunAs -ArgumentList 'Set-ExecutionPolicy -ExecutionPolicy RemoteSigned'

# USER ${LocalUsername}

#CONFIG
#   ALIAS FILE
RUN if (Test-Path -Path "C:\Users\Public\.alias.ps1") { Remove-Item "C:\Users\Public\.alias.ps1" -Recurse } \
    Invoke-WebRequest https://raw.githubusercontent.com/herrwinfried/myconfig/windows/data/.alias.ps1 -OutFile C:\Users\Public\.alias.ps1

# PowerShell Framework config
COPY dockerconfig/Microsoft.Powershell_profile.ps1 "C:/Windows/System32/WindowsPowerShell/v1.0/Microsoft.Powershell_profile.ps1"

# PowerShell Core config
RUN pwsh -Command 'Copy-Item -Path "C:/Windows/System32/WindowsPowerShell/v1.0/Microsoft.Powershell_profile.ps1" -Destination $PSHOME\Microsoft.Powershell_profile.ps1 -Recurse'

#   Oh-My-Posh
RUN $env:SCOOP_GLOBAL='C:\Program Files\GlobalScoopApps'; \
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine'); \
irm get.scoop.sh -outfile 'install.ps1'; ./install.ps1 -RunAsAdmin -ScoopGlobalDir $env:SCOOP_GLOBAL  ; Remove-Item -Path ./install.ps1 -Force 

RUN scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json -g

#Install NodeJS
ARG NODEJS_VERSION=20.3.1
RUN choco install -y nodejs --version $Env:NODEJS_VERSION
#Install Python
ARG PYTHON_VERSION=3.11.4
RUN choco install -y python --version $Env:PYTHON_VERSION
#Install Rust
ARG RUST_VERSION=1.68.0
RUN choco install -y rust --version $Env:RUST_VERSION
#Install Git
RUN scoop install git -g
# Install Github CLI
RUN scoop install main/gh -g
# Install Gitlab CLI
RUN scoop install main/glab -g