$OldPWD = Get-Location
Set-Location $PSScriptRoot\..\..\..\..\dotfiles
$DotfilesFolder=$(Get-Location)

Remove-File "$env:USERPROFILE\.alias.ps1"

Copy-Item -Path "$DotfilesFolder\home\.alias.ps1" -Destination "$env:USERPROFILE\.alias.ps1" -Recurse -Force

Create-Folder $env:USERPROFILE\Documents\WindowsPowerShell
Create-Folder $env:USERPROFILE\Documents\PowerShell

Remove-File "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
Remove-File "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

Copy-Item -Path "$DotfilesFolder\home\Microsoft.PowerShell_profile.ps1" -Destination "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Recurse -Force
Copy-Item -Path "$DotfilesFolder\home\Microsoft.PowerShell_profile.ps1" -Destination "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Recurse -Force

Remove-File $env:USERPROFILE\.wslconfig

Copy-Item -Path "$DotfilesFolder\.wslconfig" -Destination "$env:USERPROFILE\.wslconfig" -Recurse -Force

Remove-File "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

Copy-Item -Path "$DotfilesFolder\terminal.json" -Destination "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Recurse -Force

Remove-File "$env:USERPROFILE\.poshthemes"

Create-Folder "$env:USERPROFILE\.poshthemes"

Download-File -url "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/default.omp.json" -desc "$env:USERPROFILE\.poshthemes\default.omp.json"

Start-Process PowerShell -verb runas "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned"

Set-Location $OldPWD