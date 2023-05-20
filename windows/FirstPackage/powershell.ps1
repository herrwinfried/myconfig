if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct Script?"
   Start-Sleep -Seconds 3
    Exit 1
}

wingetx -Id 9MZ1SNWT0N5D # Powershell core

wingetx -Id JanDeDobbeleer.OhMyPosh