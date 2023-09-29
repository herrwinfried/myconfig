FROM mcr.microsoft.com/windows/servercore:ltsc2022

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
#    docker build -t herrwinfried/dev_env:full-servercore-ltsc22 . -f ./full-servercore-ltsc22.dockerfile 
#    New-Item -Path "C:\" -Name "Host" -ItemType "directory"
#    docker run -it -v C:\Host:C:\Host:rw --name servercore -p 3256:22 herrwinfried/dev_env:full-servercore-ltsc22

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
RUN if (-not (Test-Path -Path "C:\Users\Public\.poshthemes")) { New-Item "C:\Users\Public\.poshthemes" -ItemType Directory }; \
    if (Test-Path -Path "C:\Users\Public\.poshthemes\themes.zip") { Remove-Item C:\Users\Public\.poshthemes\themes.zip -Recurse }; \
    Invoke-WebRequest https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/default.omp.json -OutFile C:\Users\Public\.poshthemes\default.omp.json;

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

# SOURCE NAME: runtimeDockerfile

#FROM mcr.microsoft.com/windows/servercore:ltsc2022-amd64

ENV \
    # Configure web servers to bind to port 80 when present
    ASPNETCORE_URLS=http://+:80 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # .NET Runtime version
    DOTNET_VERSION=7.0.8

# Install .NET Runtime
RUN powershell -Command \
        #$ErrorActionPreference = 'Stop'; \
        #$ProgressPreference = 'SilentlyContinue'; \
        \
        Invoke-WebRequest -OutFile dotnet.zip https://dotnetcli.azureedge.net/dotnet/Runtime/$Env:DOTNET_VERSION/dotnet-runtime-$Env:DOTNET_VERSION-win-x64.zip; \
        $dotnet_sha512 = '52b2a4179cae5a7c74470068cdb89d1e9cdb26c3a9fad0d362e0d16f2a203d8bcee8d88719dd62fddb4f50094c9820a765c75fc5188e8fe6b94cdcd84d20b39e'; \
        if ((Get-FileHash dotnet.zip -Algorithm sha512).Hash -ne $dotnet_sha512) { \
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; \
            exit 1; \
        }; \
        \
        mkdir $Env:ProgramFiles\dotnet; \
        tar -oxzf dotnet.zip -C $Env:ProgramFiles\dotnet; \
        Remove-Item -Force dotnet.zip

RUN $existingPath = [Environment]::GetEnvironmentVariable('PATH', 'Machine'); $newPath = $existingPath + ';C:\Program Files\dotnet'; [Environment]::SetEnvironmentVariable('PATH', $newPath, 'Machine')

# SOURCE NAME: sdkDockerfile

# ARG REPO=mcr.microsoft.com/dotnet/aspnet
#FROM mcr.microsoft.com/dotnet/aspnet:7.0.8-windowsservercore-ltsc2022

ENV \
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    # SDK version
    DOTNET_SDK_VERSION=7.0.305 \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-WindowsServerCore-ltsc2022

# Download MinGit
RUN powershell -Command " \
        #$ErrorActionPreference = 'Stop'; \
        #$ProgressPreference = 'SilentlyContinue'; \
        \
        Invoke-WebRequest -OutFile mingit.zip https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.1/MinGit-2.41.0-64-bit.zip; \
        $mingit_sha256 = 'c9cffc25e2ef81f51029138678b7bfc538a56095ec0538125dc790a01e20d77a'; \
        if ((Get-FileHash mingit.zip -Algorithm sha256).Hash -ne $mingit_sha256) { \
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; \
            exit 1; \
        }; \
        mkdir $Env:ProgramFiles\MinGit; \
        tar -oxzf mingit.zip -C $Env:ProgramFiles\MinGit; \
        Remove-Item -Force mingit.zip"

RUN powershell -Command " \
        #$ErrorActionPreference = 'Stop'; \
        #$ProgressPreference = 'SilentlyContinue'; \
        \
        # Retrieve .NET SDK
        Invoke-WebRequest -OutFile dotnet.zip https://dotnetcli.azureedge.net/dotnet/Sdk/$Env:DOTNET_SDK_VERSION/dotnet-sdk-$Env:DOTNET_SDK_VERSION-win-x64.zip; \
        $dotnet_sha512 = '9cad4fe5efbf9d37bcefad88a1623da12946958759a6ab7795602598a9e2c7e9a948c335e7fbb002b7c03af877798f24c97546857e8822f639cf92ae81006221'; \
        if ((Get-FileHash dotnet.zip -Algorithm sha512).Hash -ne $dotnet_sha512) { \
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; \
            exit 1; \
        }; \
        tar -oxzf dotnet.zip -C $Env:ProgramFiles\dotnet ./LICENSE.txt ./ThirdPartyNotices.txt ./packs ./sdk ./sdk-manifests ./templates ./shared/Microsoft.WindowsDesktop.App; \
        Remove-Item -Force dotnet.zip; \
        \
        # Install PowerShell global tool
        $powershell_version = '7.3.4'; \
        Invoke-WebRequest -OutFile PowerShell.Windows.x64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Windows.x64.$powershell_version.nupkg; \
        $powershell_sha512 = 'c2a103ada901a2fa2d9e0be43355099e3a96f7a1b229aafc7b8cb46253389881854e57fa0dcd8619ed3e2c7ca6f614c13b574b1db3090cff29115aa5575acaeb'; \
        if ((Get-FileHash PowerShell.Windows.x64.$powershell_version.nupkg -Algorithm sha512).Hash -ne $powershell_sha512) { \
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; \
            exit 1; \
        }; \
        & $Env:ProgramFiles\dotnet\dotnet tool install --add-source . --tool-path $Env:ProgramFiles\powershell --version $powershell_version PowerShell.Windows.x64; \
        & $Env:ProgramFiles\dotnet\dotnet nuget locals all --clear; \
        Remove-Item -Force PowerShell.Windows.x64.$powershell_version.nupkg; \
        Remove-Item -Path $Env:ProgramFiles\powershell\.store\powershell.windows.x64\$powershell_version\powershell.windows.x64\$powershell_version\powershell.windows.x64.$powershell_version.nupkg -Force;"

RUN $existingPath = [Environment]::GetEnvironmentVariable('PATH', 'Machine'); $newPath = $existingPath + ';C:\Program Files\powershell;C:\Program Files\MinGit\cmd'; [Environment]::SetEnvironmentVariable('PATH', $newPath, 'Machine')

# Trigger first run experience by running arbitrary cmd
RUN dotnet help

# SOURCE NAME: aspnetDockerfile

# ARG REPO=mcr.microsoft.com/dotnet/runtime
#FROM mcr.microsoft.com/dotnet/runtime:7.0.8-windowsservercore-ltsc2022

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.8

# Install ASP.NET Core Runtime
RUN powershell -Command \
        #$ErrorActionPreference = 'Stop'; \
        #$ProgressPreference = 'SilentlyContinue'; \
        \
        Invoke-WebRequest -OutFile aspnetcore.zip https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$Env:ASPNET_VERSION/aspnetcore-runtime-$Env:ASPNET_VERSION-win-x64.zip; \
        $aspnetcore_sha512 = 'c383cbb29d2d028895f689f8b0621bcab548ec2dfb0a67b3cef788d809f1670ce0f8afc1de90fd465abc0614fce9af829fc2f249d166958009c0479d4ecb88c7'; \
        if ((Get-FileHash aspnetcore.zip -Algorithm sha512).Hash -ne $aspnetcore_sha512) { \
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; \
            exit 1; \
        }; \
        \
        tar -oxzf aspnetcore.zip -C $Env:ProgramFiles\dotnet ./shared/Microsoft.AspNetCore.App; \
        Remove-Item -Force aspnetcore.zip

# SOURCE NAME: iisDockerfile
#FROM mcr.microsoft.com/windows/servercore:ltsc2022

RUN powershell -Command \
    Add-WindowsFeature Web-Server; \
    Invoke-WebRequest -UseBasicParsing -Uri "https://dotnetbinaries.blob.core.windows.net/servicemonitor/2.0.1.10/ServiceMonitor.exe" -OutFile "C:\ServiceMonitor.exe"

#EXPOSE 80

#ENTRYPOINT ["C:\\ServiceMonitor.exe", "w3svc"]

