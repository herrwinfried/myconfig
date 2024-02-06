@echo off
Title "HerrWinfried - MyConfig [Download]"
    curl https://raw.githubusercontent.com/herrwinfried/myconfig/windows/scripts/download.ps1 -O
    start powershell.exe -ExecutionPolicy Bypass -File .\download.ps1
exit