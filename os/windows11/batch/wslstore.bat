@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit)
color A
echo "I activate the Virtual Machine Platform."
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
color b
echo "Read and accept the agreement. This will install WSL."
winget install --id 9P9TQF7MRM4R
color f
echo "Restart your computer."
pause