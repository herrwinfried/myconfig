if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process PowerShell "-ExecutionPolicy Bypass `"$PSCommandPath`"" -Verb RunAs; exit }
$FontFolder="$env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts"

if (Test-Path -Path "$FontFolder\MesloLGS NF Bold Italic.ttf") {
    Remove-Item "$FontFolder\MesloLGS NF Bold Italic.ttf" -Recurse
}
if (Test-Path -Path "$FontFolder\MesloLGS NF Bold.ttf") {
    Remove-Item "$FontFolder\MesloLGS NF Bold.ttf" -Recurse
}
if (Test-Path -Path "$FontFolder\MesloLGS NF Italic.ttf") {
    Remove-Item "$FontFolder\MesloLGS NF Italic.ttf" -Recurse
}
if (Test-Path -Path "$FontFolder\MesloLGS NF Regular.ttf") {
    Remove-Item "$FontFolder\MesloLGS NF Regular.ttf" -Recurse
}
##########################################
if (-NOT (Test-Path -Path "$FontFolder\MesloLGS NF Bold Italic.ttf")) {
    Invoke-WebRequest https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -OutFile "$FontFolder\MesloLGS NF Bold Italic.ttf"
}
if (-NOT (Test-Path -Path "$FontFolder\MesloLGS NF Bold.ttf")) {
    Invoke-WebRequest https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -OutFile "$FontFolder\MesloLGS NF Bold.ttf"
}
if (-NOT (Test-Path -Path "$FontFolder\MesloLGS NF Italic.ttf")) {
    Invoke-WebRequest https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -OutFile "$FontFolder\MesloLGS NF Italic.ttf"
}
if (-NOT (Test-Path -Path "$FontFolder\MesloLGS NF Regular.ttf")) {
    Invoke-WebRequest https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -OutFile "$FontFolder\MesloLGS NF Regular.ttf"
}