@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit)
echo "I activate the Virtual Machine Platform."
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
pause