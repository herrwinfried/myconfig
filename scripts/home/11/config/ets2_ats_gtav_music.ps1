function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (IsAdministrator) {
    Set-Location $PSScriptRoot\..\..\..\
    $TempFolder=$(Get-Location)
    . "$TempFolder\variable.ps1"

New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\American Truck Simulator\music" -Value "$env:USERPROFILE\music\game_music" -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\Euro Truck Simulator 2\music" -Value "$env:USERPROFILE\music\game_music" -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\Rockstar Games\GTA V\User Music" -Value "$env:USERPROFILE\music\game_music" -Force
} else {

Create-Folder $env:USERPROFILE\music\game_music
Create-Folder "$env:USERPROFILE\Documents\Euro Truck Simulator 2"
Create-Folder "$env:USERPROFILE\Documents\American Truck Simulator"

Create-Folder "$env:USERPROFILE\Documents\Rockstar Games"
Create-Folder "$env:USERPROFILE\Documents\Rockstar Games\GTA V"

if (Test-Path "$env:USERPROFILE\Documents\Euro Truck Simulator 2\music" -PathType Container) {
    Remove-Item -Path "$env:USERPROFILE\Documents\Euro Truck Simulator 2\music" -Recurse -Force
}
if (Test-Path "$env:USERPROFILE\Documents\American Truck Simulator\music" -PathType Container) {
    Remove-Item -Path "$env:USERPROFILE\Documents\American Truck Simulator\music" -Recurse -Force
}
if (Test-Path "$env:USERPROFILE\Documents\Rockstar Games\GTA V\User Music" -PathType Container) {
    Remove-Item -Path "$env:USERPROFILE\Documents\Rockstar Games\GTA V\User Music" -Recurse -Force
}
Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
} 