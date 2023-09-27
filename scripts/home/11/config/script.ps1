Remove-File "$env:USERPROFILE\.alias.ps1"

Download-File -url "https://raw.githubusercontent.com/herrwinfried/myconfig/windows/dotfiles/home/.alias.ps1" -desc "$env:USERPROFILE\.alias.ps1"

Create-Folder $env:USERPROFILE\Documents\WindowsPowerShell
Create-Folder $env:USERPROFILE\Documents\PowerShell

Remove-File "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
Remove-File "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

Download-File -url "https://raw.githubusercontent.com/herrwinfried/myconfig/windows/dotfiles/home/Microsoft.PowerShell_profile.ps1" -desc "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
Download-File -url "https://raw.githubusercontent.com/herrwinfried/myconfig/windows/dotfiles/home/Microsoft.PowerShell_profile.ps1" -desc "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

Remove-File $env:USERPROFILE\.wslconfig

Download-File -url "https://raw.githubusercontent.com/herrwinfried/myconfig/windows/dotfiles/.wslconfig" -desc "$env:USERPROFILE\.wslconfig"

Remove-File "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Download-File -url "https://raw.githubusercontent.com/herrwinfried/myconfig/windows/dotfiles/terminal.json" -desc "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"


Remove-File "$env:USERPROFILE\.poshthemes"

Create-Folder "$env:USERPROFILE\.poshthemes"

Download-File -url "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/default.omp.json" -desc "$env:USERPROFILE\.poshthemes\default.omp.json"

Start-Process PowerShell -verb runas "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned"