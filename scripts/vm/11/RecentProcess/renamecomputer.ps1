function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# if (IsAdministrator) {
# Set-Location $PSScriptRoot\..\..\..\
# $TempFolder=$(pwd)
   # . "$TempFolder\VARIBLES.ps1"
# Set-Location $PSScriptRoot
# Rename-Computer -NewName "$NEW_HOSTNAME"
# } else {
#     Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs   
# }
Write-Debug "-_- / rename-computer"