if (Test-Path -Path "$env:USERPROFILE\.alias.ps1") {
    Remove-Item "$env:USERPROFILE\.alias.ps1" -Recurse
}
Invoke-WebRequest https://raw.githubusercontent.com/herrwinfried/myconfig/windows/data/.alias.ps1 -OutFile $env:USERPROFILE\.alias.ps1
#POWERSHELL (FRAMEWORK)
if (-NOT (Test-Path -Path "$env:USERPROFILE\Documents\WindowsPowerShell")) {
    mkdir "$env:USERPROFILE\Documents\WindowsPowerShell"
}

if (Test-Path -Path "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1") {
    Remove-Item "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Recurse
}
Invoke-WebRequest https://raw.githubusercontent.com/herrwinfried/myconfig/windows/data/Microsoft.PowerShell_profile.ps1 -OutFile $env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#---------------
#POWERSHELL CORE 
if (-NOT (Test-Path -Path "$env:USERPROFILE\Documents\PowerShell")) {
    mkdir "$env:USERPROFILE\Documents\PowerShell"
}

if (Test-Path -Path "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1") {
    Remove-Item "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Recurse
}
Invoke-WebRequest https://raw.githubusercontent.com/herrwinfried/myconfig/windows/data/Microsoft.PowerShell_profile.ps1 -OutFile $env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1


if (Test-Path -Path "$env:USERPROFILE\.wslconfig") {
    Remove-Item "$env:USERPROFILE\.wslconfig" -Recurse
}
Invoke-WebRequest https://raw.githubusercontent.com/herrwinfried/myconfig/windows/data/.wslconfig -OutFile $env:USERPROFILE\.wslconfig



if (Test-Path -Path "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json") {
    Remove-Item "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Recurse
}
Invoke-WebRequest https://raw.githubusercontent.com/herrwinfried/myconfig/windows/data/terminal.json -OutFile $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json


