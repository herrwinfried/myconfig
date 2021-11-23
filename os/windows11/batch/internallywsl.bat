@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit)
color A
echo "I activate the Virtual Machine Platform."
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

echo "I activate the Hyper-v."
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V /norestart
bcdedit /set hypervisorlaunchtype auto
color b
echo "I activate the WSL."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
color f
echo "Restart your computer."
pause