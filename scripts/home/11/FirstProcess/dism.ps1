function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (IsAdministrator) {

Set-Location $PSScriptRoot\..\..\..\
$TempFolder=$(Get-Location)
    . "$TempFolder\VARIBLES.ps1"
Set-Location $PSScriptRoot
    
# Enable Hyper-v All feature
dism.exe /online /enable-feature /featurename:Microsoft-Hyper-V-All /all /norestart
# Enable Virtual Machine Platform
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
# Enable Hypervisor Platform
dism.exe /online /enable-feature /featurename:HypervisorPlatform /all /norestart
# Fix Hypervisor platform
bcdedit /set hypervisorlaunchtype auto
# Enable Windows Container
dism.exe /online /enable-feature /featurename:Containers /all /norestart
dism.exe /online /enable-feature /featurename:Containers-HNS /all /norestart
dism.exe /online /enable-feature /featurename:Containers-SDN /all /norestart
# Enable Legacy Components
dism.exe /online /enable-feature /featurename:LegacyComponents /all /norestart
# Enable DirectPlay
dism.exe /online /enable-feature /featurename:DirectPlay /all /norestart
# Enable XPS Viewer
dism.exe /online /enable-feature /featurename:Printing-XPSServices-Features /all /norestart
# Enable Print To PDF
dism.exe /online /enable-feature /featurename:Printing-PrintToPDFServices-Features /all /norestart

} else {
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs   
}