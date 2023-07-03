if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process PowerShell "-ExecutionPolicy Bypass `"$PSCommandPath`"" -Verb RunAs; exit }
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Remove-Item install.ps1
Invoke-RestMethod get.scoop.sh -outfile 'install.ps1'
.\install.ps1 -RunAsAdmin -ScoopGlobalDir 'C:\Program Files\GlobalScoopApps'
Remove-Item install.ps1