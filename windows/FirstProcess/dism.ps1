if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct Script?"
   Start-Sleep -Seconds 3
    Exit 1
}

# Enable HYPER-V ALL, Virtual machine platform, hypervisor platform, Legacy comp. , XPS Print , PDF Print
Start-Process PowerShell -verb runas "dism.exe /online /enable-feature /featurename:Microsoft-Hyper-V-All /all /norestart; dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart; dism.exe /online /enable-feature /featurename:HypervisorPlatform /all /norestart; bcdedit /set hypervisorlaunchtype auto; dism.exe /online /enable-feature /featurename:LegacyComponents /all /norestart; dism.exe /online /enable-feature /featurename:DirectPlay /all /norestart; dism.exe /online /enable-feature /featurename:Printing-XPSServices-Features /all /norestart; dism.exe /online /enable-feature /featurename:Printing-PrintToPDFServices-Features /all /norestart; "