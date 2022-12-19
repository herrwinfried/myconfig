@echo off
Title "HerrWinfried - MyConfig SETUP"
    curl https://raw.githubusercontent.com/herrwinfried/myconfig/windows/setup.ps1 -O
    start powershell.exe -ExecutionPolicy Bypass -File .\setup.ps1
exit