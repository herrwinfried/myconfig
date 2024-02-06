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
Start-Sleep -s 1
    PackageProviderInstall -ProviderName NuGet
    ModuleInstall -ModuleName PSWindowsUpdate
	Import-Module PSWindowsUpdate
	Get-WindowsUpdate -AcceptAll -Download
	Get-WindowsUpdate -AcceptAll -Install
} else {
     
winget update -r
Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs

}