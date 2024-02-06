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

New-Font-Online -url "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" -Family "MesloLGS NF Bold Italic.ttf"

New-Font-Online -url "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" -Family "MesloLGS NF Bold.ttf"

New-Font-Online -url "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" -Family "MesloLGS NF Italic.ttf"

New-Font-Online -url "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -Family "MesloLGS NF Regular.ttf"
} else {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs   
}