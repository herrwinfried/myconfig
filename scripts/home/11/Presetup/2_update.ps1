function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
if (IsAdministrator) {
    # FIXME: :/ Hey, if you know a more logical way, I'm open to suggestions.
    Set-Location $PSScriptRoot\..\..\..\
    $TempFolder=$(Get-Location)
    . "$TempFolder\config.ps1"
    Import-Module "$TempFolder\function.psm1"
    Set-Location $PSScriptRoot
    ##############################################################

    Install-PackageProvider2 -ProviderName NuGet
    Install-Module2 -ModuleName PSWindowsUpdate
    Import-Module PSWindowsUpdate
    Get-WindowsUpdate -AcceptAll -Download
    Get-WindowsUpdate -AcceptAll -Install
} else {
    Start-Process PowerShell -verb runas "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned"
    winget upgrade --all --accept-package-agreements --accept-source-agreements
    if (Test-CommandExists pwsh) {
        Start-Process pwsh.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs -Wait   
    } else {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs -Wait  
    }
}