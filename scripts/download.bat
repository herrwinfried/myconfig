@echo off
Title "HerrWinfried - MyConfig DOWNLOAD"
    curl https://raw.githubusercontent.com/herrwinfried/myconfig/windows/download.ps1 -O
    start powershell.exe -ExecutionPolicy Bypass -File .\download.ps1
exit