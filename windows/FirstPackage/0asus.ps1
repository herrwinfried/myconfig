if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct Script?"
   Start-Sleep -Seconds 3
    Exit 1
}

#myasus
wingetx -Id 9N7R5S6B0ZZH

#Glidex
wingetx -Id 9PLH2SV1DVK5