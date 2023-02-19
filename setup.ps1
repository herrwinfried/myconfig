function wingetx{
    param (
        [Parameter (Mandatory = $true)] [String]$Id
        )
$runnnx = "winget.exe install --id $Id --accept-package-agreements --accept-source-agreements"
        Invoke-Expression $runnnx
    }

$Host.UI.RawUI.WindowTitle = "HerrWinfried - MyConfig SETUP"

Start-Process PowerShell -verb runas "dism.exe /online /enable-feature /featurename:Microsoft-Hyper-V-All /all /norestart; dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart; dism.exe /online /enable-feature /featurename:HypervisorPlatform /all /norestart; bcdedit /set hypervisorlaunchtype auto; dism.exe /online /enable-feature /featurename:LegacyComponents /all /norestart; dism.exe /online /enable-feature /featurename:DirectPlay /all /norestart; dism.exe /online /enable-feature /featurename:Printing-XPSServices-Features /all /norestart; dism.exe /online /enable-feature /featurename:Printing-PrintToPDFServices-Features /all /norestart; "

wingetx -Id Brave.Brave
#myasus
wingetx -Id 9N7R5S6B0ZZH
#Intel Unison

wingetx -Id 9PP9GZM2GN26


##########################################################WINBTRFS######################################################
$BtrfsFolder = "$env:USERPROFILE\winbtrfs"
# Folder Check
if (Test-Path -Path $BtrfsFolder) {
    Write-Host "I found folder named winbtrfs and deleted it." -ForegroundColor Red
    Remove-Item "$env:USERPROFILE\winbtrfs" -Recurse
}

New-Item "$env:USERPROFILE\winbtrfs" -ItemType Directory

Invoke-WebRequest https://github.com/maharmstone/btrfs/releases/download/v1.8.2/btrfs-1.8.2.zip -OutFile $env:USERPROFILE\winbtrfs\btrfs.zip
Expand-Archive $env:USERPROFILE\winbtrfs\btrfs.zip -DestinationPath $env:USERPROFILE\winbtrfs\btrfs
Set-Location $env:USERPROFILE\winbtrfs\btrfs\x64
Get-ChildItem "$env:USERPROFILE\winbtrfs\btrfs\x64" -Recurse -Filter "*inf" | ForEach-Object { PNPUtil.exe /add-driver $_.FullName /install } 
##########################################################WINBTRFS######################################################
# Powershell
wingetx -Id 9MZ1SNWT0N5D

wingetx -Id JanDeDobbeleer.OhMyPosh


if (-NOT (Test-Path -Path "$env:USERPROFILE\OhMyPosh")) {
mkdir "$env:USERPROFILE\OhMyPosh"
}
if (-NOT (Test-Path -Path "$env:USERPROFILE\OhMyPosh\powerlevel10k_rainbow.omp.json")) {
    Remove-Item "$env:USERPROFILE\OhMyPosh\powerlevel10k_rainbow.omp.json" -Recurse
    Invoke-WebRequest https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/powerlevel10k_rainbow.omp.json -OutFile $env:USERPROFILE\OhMyPosh\powerlevel10k_rainbow.omp.json
} else {
    Invoke-WebRequest https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/powerlevel10k_rainbow.omp.json -OutFile $env:USERPROFILE\OhMyPosh\powerlevel10k_rainbow.omp.json
}

if (-NOT (Test-Path -Path "$env:USERPROFILE\Documents\PowerShell")) {
    mkdir "$env:USERPROFILE\Documents\PowerShell"
    }

    if (Test-Path -Path "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1") {
        Remove-Item "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Recurse
        "oh-my-posh init pwsh --config $env:USERPROFILE\OhMyPosh\powerlevel10k_rainbow.omp.json | Invoke-Expression" | Out-File -FilePath "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    } else {
        "oh-my-posh init pwsh --config $env:USERPROFILE\OhMyPosh\powerlevel10k_rainbow.omp.json | Invoke-Expression" | Out-File -FilePath "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    }

    if (Test-Path -Path "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json") {
        Remove-Item "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Recurse
        Invoke-WebRequest https://raw.githubusercontent.com/herrwinfried/myconfig/windows/data/terminal.json -OutFile $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
    } else {
        Invoke-WebRequest https://raw.githubusercontent.com/herrwinfried/myconfig/windows/data/terminal.json -OutFile $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
    }


#Glidex
wingetx -Id 9PLH2SV1DVK5
#icloud
wingetx -Id 9PKTQ5699M62
#itunes
wingetx -Id 9PB2MZ1ZMB1S

wingetx -Id Nvidia.GeForceExperience
### WSL 
#WSL
wingetx -Id 9P9TQF7MRM4R
#opensuse
wingetx -Id 9MSSK2ZXXN11

### IDE & TEXT
wingetx -Id Microsoft.VisualStudioCode
wingetx -Id Microsoft.AzureDataStudio
wingetx -Id Microsoft.VisualStudio.2022.Community
#Kate
wingetx -Id 9NWMW7BB59HW
#termius
wingetx -Id 9NK1GDVPX09V

#wingetx -Id GitHub.GitHubDesktop
wingetx -Id Git.Git
wingetx -Id GitHub.GitLFS

#wingetx -Id MongoDB.Compass.Full
#wingetx -Id HeidiSQL.HeidiSQL

wingetx -Id OpenJS.NodeJS


wingetx -Id Discord.Discord 
wingetx -Id Discord.Discord.PTB
wingetx -Id Element.Element

# Unigram / Telegram
wingetx -Id 9N97ZCKPD60Q
#wingetx -Id Telegram.TelegramDesktop

# Whatsapp beta
wingetx -Id 9NBDXK71NK08
#Kde connect
wingetx -Id KDE.KDEConnect
# HP Smart
wingetx -Id 9WZDNCRFHWLH

wingetx -Id Valve.Steam
wingetx -Id EpicGames.EpicGamesLauncher

#Bluetooth Audio Receiver
#wingetx -Id 9N9WCLWDQS5J

# wingetx -Id BlueStack.BlueStacks
wingetx -Id BinanceTech.Binance

#auto dark mode
#wingetx -Id XP8JK4HZBVF435
#WinDynamicDesktop
#wingetx -Id 9NM8N7DQ3Z5F

wingetx -Id OpenVPNTechnologies.OpenVPNConnect
wingetx -Id Twilio.Authy
wingetx -Id Flameshot.Flameshot
wingetx -Id 7zip.7zip
#f.lux
wingetx -Id 9N9KDPHV91JT

wingetx -Id RevoUninstaller.RevoUninstaller

wingetx -Id AnyDeskSoftwareGmbH.AnyDesk
wingetx -Id TeamViewer.TeamViewer
wingetx -Id GnuPG.Gpg4win
wingetx -Id GnuPG.GnuPG
wingetx -Id OBSProject.OBSStudio
wingetx -Id Google.Drive
wingetx -Id Mega.MEGASync
wingetx -Id Microsoft.PowerToys
#wingetx -Id Microsoft.SQLServerManagementStudio
wingetx -Id JetBrains.Toolbox

#wingetx -Id RedHat.Podman 
#wingetx -Id RedHat.Podman-Desktop
wingetx -Id Docker.DockerDesktop
wingetx -Id VMware.WorkstationPro

