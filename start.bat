@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit)
powershell.exe -ExecutionPolicy Bypass -NoProfile -Command "Invoke-WebRequest https://github.com/massgravel/Microsoft-Activation-Scripts/archive/refs/heads/master.zip -OutFile $env:TEMP/mass.zip"
