if (Test-Path ~/.alias.ps1) {
    . ~/.alias.ps1
}
if (( ((Get-Host).Version).Major -ge "7" ) -and ( ((Get-Host).Version).Minor -ge "4" ) ) {
    if ((Get-Module -Name Microsoft.WinGet.Client) -and (Test-Path "$env:USERPROFILE\AppData\Local\PowerToys\WinGetCommandNotFound.psd1")) {
        Import-Module "$env:USERPROFILE\AppData\Local\PowerToys\WinGetCommandNotFound.psd1"
    }
}