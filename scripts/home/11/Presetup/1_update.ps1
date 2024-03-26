function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
if (IsAdministrator) {
    Set-Location $PSScriptRoot\..\..\..\
    $TempFolder=$(Get-Location)
    . "$TempFolder\variable.ps1"
    PackageProviderInstall -ProviderName NuGet
    ModuleInstall -ModuleName PSWindowsUpdate
    Import-Module PSWindowsUpdate
    Get-WindowsUpdate -AcceptAll -Download
    Get-WindowsUpdate -AcceptAll -Install
} else {
    Start-Process PowerShell -verb runas "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned"
    winget upgrade --all --accept-package-agreements --accept-source-agreements
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
}