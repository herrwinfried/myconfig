if (IsAdministrator) {
    $ScriptFolderTemp = Join-Path $PSScriptRoot "..\..\.."
    . "$ScriptFolderTemp\VARIABLE.ps1"

New-Font-Online -url "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" -Family "MesloLGS NF Bold Italic.ttf"

New-Font-Online -url "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" -Family "MesloLGS NF Bold.ttf"

New-Font-Online -url "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" -Family "MesloLGS NF Italic.ttf"

New-Font-Online -url "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -Family "MesloLGS NF Regular.ttf"
} else {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs   
}