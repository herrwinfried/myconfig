function wingetx{
    param (
        [Parameter (Mandatory = $true)] [String]$Id
        )
$runnnx = "winget.exe install --id $Id --accept-package-agreements --accept-source-agreements"
        Invoke-Expression $runnnx
    }

Start-Process PowerShell -verb runas "dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart; DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V-All /norestart; bcdedit /set hypervisorlaunchtype auto"

wingetx -Id Brave.Brave
### ASUS && APPLE 
#myasus
wingetx -Id 9N7R5S6B0ZZH
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
wingetx -Id Microsoft.VisualStudio.2022.Community
#Kate
wingetx -Id 9NWMW7BB59HW
#termius
wingetx -Id 9NK1GDVPX09V

wingetx -Id GitHub.GitHubDesktop
wingetx -Id Git.Git
wingetx -Id GitHub.GitLFS

wingetx -Id MongoDB.Compass.Full
wingetx -Id HeidiSQL.HeidiSQL

wingetx -Id OpenJS.NodeJS

### Messenger & Printers
wingetx -Id Discord.Discord 
wingetx -Id Discord.Discord.PTB
wingetx -Id Element.Element
wingetx -Id Telegram.TelegramDesktop
# Whatsapp beta
wingetx -Id 9NBDXK71NK08
#Kde connect
wingetx -Id 9N93MRMSXBF0
# HP Smart
wingetx -Id 9WZDNCRFHWLH

wingetx -Id Valve.Steam
wingetx -Id EpicGames.EpicGamesLauncher

#Bluetooth Audio Receiver
wingetx -Id 9N9WCLWDQS5J

# Powershell
wingetx -Id 9MZ1SNWT0N5D

wingetx -Id JanDeDobbeleer.OhMyPosh
if (!Test-Path -Path "$env:USERPROFILE\OhMyPosh") {
mkdir "$env:USERPROFILE\OhMyPosh"
}
if (Test-Path -Path "$env:USERPROFILE\OhMyPosh\powerlevel10k_rainbow.omp.json") {
    Remove-Item "$env:USERPROFILE\OhMyPosh\powerlevel10k_rainbow.omp.json" -Recurse
    Invoke-WebRequest https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/powerlevel10k_rainbow.omp.json -OutFile $env:USERPROFILE\OhMyPosh\powerlevel10k_rainbow.omp.json
} else {
    Invoke-WebRequest https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/powerlevel10k_rainbow.omp.json -OutFile $env:USERPROFILE\OhMyPosh\powerlevel10k_rainbow.omp.json
}

if (!Test-Path -Path "$env:USERPROFILE\Documents\PowerShell") {
    mkdir "$env:USERPROFILE\Documents\PowerShell"
    }

    if (Test-Path -Path "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1") {
        Remove-Item "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Recurse
        "oh-my-posh init pwsh --config $env:USERPROFILE\OhMyPosh\powerlevel10k_rainbow.omp.json | Invoke-Expression" | Out-File -FilePath "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    } else {
        "oh-my-posh init pwsh --config $env:USERPROFILE\OhMyPosh\powerlevel10k_rainbow.omp.json | Invoke-Expression" | Out-File -FilePath "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    }


wingetx -Id BlueStack.BlueStacks
wingetx -Id BinanceTech.Binance
#auto dark mode
wingetx -Id XP8JK4HZBVF435
#WinDynamicDesktop
wingetx -Id 9NM8N7DQ3Z5F

wingetx -Id OpenVPNTechnologies.OpenVPNConnect
wingetx -Id Twilio.Authy
wingetx -Id Flameshot.Flameshot
wingetx -Id 7zip.7zip
#f.lux
wingetx -Id 9N9KDPHV91JT

wingetx -Id AnyDeskSoftwareGmbH.AnyDesk
wingetx -Id TeamViewer.TeamViewer
wingetx -Id GnuPG.Gpg4win
wingetx -Id GnuPG.GnuPG
wingetx -Id OBSProject.OBSStudio
wingetx -Id Google.Drive
wingetx -Id Microsoft.PowerToys
wingetx -Id Microsoft.SQLServerManagementStudio
wingetx -Id Microsoft.AzureDataStudio

if (Test-Path -Path "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json") {
    Remove-Item "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Recurse
    Invoke-WebRequest https://raw.githubusercontent.com/herrwinfried/herrwinfried/json/terminal.json -OutFile $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
} else {
    Invoke-WebRequest https://raw.githubusercontent.com/herrwinfried/herrwinfried/json/terminal.json -OutFile $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
}

wingetx -Id JetBrains.DataGrip

wingetx -Id JetBrains.CLion