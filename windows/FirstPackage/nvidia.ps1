if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct Script?"
   Start-Sleep -Seconds 3
    Exit 1
}


wingetx -Id Nvidia.GeForceExperience