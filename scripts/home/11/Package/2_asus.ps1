if ($config.BOARD_VENDOR -ilike "*asus*") {
    $apps = @(
    @{
        Id = "9N7R5S6B0ZZH" # MyAsus
        Interactive = $False
    },
    @{
        Id = "9PLH2SV1DVK5" # Glidex
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

    }