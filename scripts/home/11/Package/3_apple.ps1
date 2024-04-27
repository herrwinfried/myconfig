$apps = @(
    @{
        Id = "9PKTQ5699M62" # iCloud
        Interactive = $False
    },
    @{
        Id = "9NP83LWLPZ9K" # Apple Devices
        Interactive = $False
    }
    @{
        Id = "9PFHDD62MXS1" # Apple Music
        Interactive = $False
    },
    @{
        Id = "9NM4T8B9JQZ1" # Apple TV
        Interactive = $False
    }
    )
    foreach ($app in $apps) {
        if ($app.Interactive) {
            Install-WingetPackage -Interactive 1 -PackageID $app.Id
        } else {
            Install-WingetPackage -PackageID $app.Id
        }
    }