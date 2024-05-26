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

    New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\American Truck Simulator\music" -Value "$env:USERPROFILE\music\game_music" -Force
    New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\Euro Truck Simulator 2\music" -Value "$env:USERPROFILE\music\game_music" -Force
    New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\Rockstar Games\GTA V\User Music" -Value "$env:USERPROFILE\music\game_music" -Force
    New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\Rockstar Games\GTA IV\User Music" -Value "$env:USERPROFILE\music\game_music" -Force

} else {

    New-Directory "$env:USERPROFILE\music\game_music"
    New-Directory "$env:USERPROFILE\Documents\Euro Truck Simulator 2"
    New-Directory "$env:USERPROFILE\Documents\American Truck Simulator"

    New-Directory "$env:USERPROFILE\Documents\Rockstar Games"
    New-Directory "$env:USERPROFILE\Documents\Rockstar Games\GTA V"
    New-Directory "$env:USERPROFILE\Documents\Rockstar Games\GTA IV"

    Remove-Item2 "$env:USERPROFILE\Documents\Euro Truck Simulator 2\music"
    Remove-Item2 "$env:USERPROFILE\Documents\American Truck Simulator\music"

    Remove-Item2 "$env:USERPROFILE\Documents\Rockstar Games\GTA V\User Music"
    Remove-Item2 "$env:USERPROFILE\Documents\Rockstar Games\GTA IV\User Music"


    if (Test-CommandExists pwsh) {
        Start-Process pwsh.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs -Wait   
    } else {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs -Wait   
    }
}