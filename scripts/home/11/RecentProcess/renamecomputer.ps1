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
$CURRENT_HOSTNAME = ($env:computername).ToLower()
if ($CURRENT_HOSTNAME -ne $NEW_HOSTNAME) {
    Rename-Computer -NewName "$NEW_HOSTNAME"
}
} else {
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs   
}