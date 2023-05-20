if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct Script?"
   Start-Sleep -Seconds 3
    Exit 1
}

#icloud
wingetx -Id 9PKTQ5699M62
#itunes
wingetx -Id 9PB2MZ1ZMB1S
#Apple Devices
wingetx -Id 9NP83LWLPZ9K