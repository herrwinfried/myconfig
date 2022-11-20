if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
Write-Output "I activate the Virtual Machine Platform."
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
winget install --id 9P9TQF7MRM4R --accept-package-agreements --accept-source-agreements
Write-Output "Restart your computer."
pause