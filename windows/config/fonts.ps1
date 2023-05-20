if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process PowerShell "-ExecutionPolicy Bypass `"$PSCommandPath`"" -Verb RunAs; exit }

if (Test-Path -Path "C:\Windows\Fonts\MesloLGS NF Bold Italic.ttf") {
    Remove-Item "C:\Windows\Fonts\MesloLGS NF Bold Italic.ttf" -Recurse
}
if (Test-Path -Path "C:\Windows\Fonts\MesloLGS NF Bold.ttf") {
    Remove-Item "C:\Windows\Fonts\MesloLGS NF Bold.ttf" -Recurse
}
if (Test-Path -Path "C:\Windows\Fonts\MesloLGS NF Italic.ttf") {
    Remove-Item "C:\Windows\Fonts\MesloLGS NF Italic.ttf" -Recurse
}
if (Test-Path -Path "C:\Windows\Fonts\MesloLGS NF Regular.ttf") {
    Remove-Item "C:\Windows\Fonts\MesloLGS NF Regular.ttf" -Recurse
}
##########################################
if (-NOT (Test-Path -Path "C:\Windows\Fonts\MesloLGS NF Bold Italic.ttf")) {
    Invoke-WebRequest https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -OutFile "C:\Windows\Fonts\MesloLGS NF Bold Italic.ttf"
}
if (-NOT (Test-Path -Path "C:\Windows\Fonts\MesloLGS NF Bold.ttf")) {
    Invoke-WebRequest https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -OutFile "C:\Windows\Fonts\MesloLGS NF Bold.ttf"
}
if (-NOT (Test-Path -Path "C:\Windows\Fonts\MesloLGS NF Italic.ttf")) {
    Invoke-WebRequest https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -OutFile "C:\Windows\Fonts\MesloLGS NF Italic.ttf"
}
if (-NOT (Test-Path -Path "C:\Windows\Fonts\MesloLGS NF Regular.ttf")) {
    Invoke-WebRequest https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -OutFile "C:\Windows\Fonts\MesloLGS NF Regular.ttf"
}