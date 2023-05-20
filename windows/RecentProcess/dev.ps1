if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct Script?"
   Start-Sleep -Seconds 3
    Exit 1
}

# DEV MODE ENABLE
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"