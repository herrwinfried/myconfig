@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit)
powershell.exe -ExecutionPolicy Bypass -NoProfile -Command "Invoke-WebRequest https://raw.githubusercontent.com/herrwinfried/myconfig/mas-automatic/mass.ps1 -OutFile $env:TEMP/mass.ps1";powershell.exe -ExecutionPolicy Bypass -NoProfile -Command powershell.exe -ExecutionPolicy Bypass -NoProfile $env:TEMP\mass.ps1