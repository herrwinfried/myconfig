if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

echo "I activate the Virtual Machine Platform."
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

echo "I activate the Hyper-v."
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V /norestart
bcdedit /set hypervisorlaunchtype auto

echo "I activate the WSL."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

echo "Restart your computer."

pause