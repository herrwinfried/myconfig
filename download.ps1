$Host.UI.RawUI.WindowTitle = "HerrWinfried - MyConfig DOWNLOAD"

if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct Script?"
   Start-Sleep -Seconds 3
    Exit 1
}

Set-Location $HOME

if (-Not (Test-Path -Path $HOME\MyConfig)) {
    New-Item $HOME\MyConfig -ItemType Directory
}
if (Test-Path -Path $HOME\MyConfig) {
    Set-Location $HOME\MyConfig
$ScriptFolder="$HOME\MyConfig"
    if (Test-Path -Path $ScriptFolder\wscript.zip ) {
        Remove-Item $ScriptFolder\wscript.zip -Recurse
    }

    Invoke-WebRequest https://github.com/herrwinfried/myconfig/archive/refs/heads/windows.zip -OutFile $ScriptFolder\wscript.zip
    Expand-Archive $ScriptFolder\wscript.zip -DestinationPath $ScriptFolder\wscript
    Move-Item $ScriptFolder\wscript\myconfig-windows\* -Destination $ScriptFolder

}

