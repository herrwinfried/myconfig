$apps = @(
    @{
        Id = "Brave.Brave"
        Interactive = $False
    },
    @{
        Id = "Mozilla.Firefox.DeveloperEdition"
        Interactive = $False
    },
    @{
        Id = "7zip.7zip"
        Interactive = $False
    },
    @{
        Id = "AdrienAllard.FileConverter"
        Interactive = $False
    },
    @{
        Id = "Fastfetch-cli.Fastfetch"
        Interactive = $False
    },
    @{
        Id = "Microsoft.OpenJDK.21"
        Interactive = $False
    },
    @{
        Id = "OpenVPNTechnologies.OpenVPNConnect"
        Interactive = $False
    },
    @{
        Id = "9P9TQF7MRM4R" # Windows Subsystem for Linux (WSL)
        Interactive = $False
    },
    @{
        Id = "9MSSK2ZXXN11" # OpenSUSE Tumbleweed for WSL
        Interactive = $False
    },
    @{
        Id = "9WZDNCRFHWLH" # HP Smart
        Interactive = $False
    },
    @{
        Id = "9N5JJZW4QZBR" # Xtreme Download Manager - XDM
        Interactive = $False
    },
    @{
        Id = "AnyDeskSoftwareGmbH.AnyDesk"
        Interactive = $False
    },
    @{
        Id = "TeamViewer.TeamViewer"
        Interactive = $False
    },
    @{
        Id = "9PP9GZM2GN26" # Intel Unison
        Interactive = $False
    },
    @{
        Id = "KDE.KDEConnect"
        Interactive = $False
    },
    @{
        Id = "9N9WCLWDQS5J" # Bluetooth Audio Receiver
        Interactive = $False
    },
    @{
        Id = "9NBLGGH516XP" # EarTrumpet
        Interactive = $False
    },
    @{
        Id = "XPDM1ZW6815MQM" # VLC
        Interactive = $False
    },
    @{
        Id = "Stremio.Stremio"
        Interactive = $False
    },
    @{
        Id = "KDE.Okular"
        Interactive = $False
    },
    @{
        Id = "RevoUninstaller.RevoUninstaller"
        Interactive = $False
    },
    @{
        Id = "9NKSQGP7F2NH" # Whatsapp
        Interactive = $False
    },
    @{
        Id = "Telegram.TelegramDesktop"
        Interactive = $False
    },
    @{
        Id = "Discord.Discord"
        Interactive = $False
    },
    @{
        Id = "Discord.Discord.PTB"
        Interactive = $False
    },
    @{
        Id = "TheDocumentFoundation.LibreOffice"
        Interactive = $False
    },
    @{
        Id = "Yandex.Disk"
        Interactive = $False
    },
    @{
        Id = "Google.GoogleDrive"
        Interactive = $False
    },
    @{
        Id = "Microsoft.PowerToys"
        Interactive = $False
    },
    @{
        Id = "Flameshot.Flameshot"
        Interactive = $False
    },
    @{
        Id = "Valve.Steam"
        Interactive = $False
    },
    @{
        Id = "HeroicGamesLauncher.HeroicGamesLauncher"
        Interactive = $False
    },
    @{
        Id = "EpicGames.EpicGamesLauncher"
        Interactive = $False
    },
    @{
        Id = "ElectronicArts.EADesktop"
        Interactive = $False
    },
    @{
        Id = "Ubisoft.Connect"
        Interactive = $False
    },
    @{
        Id = "PrismLauncher.PrismLauncher"
        Interactive = $False
    },
    @{
        Id = "OBSProject.OBSStudio"
        Interactive = $False
    },
    @{
        Id = "Oracle.VirtualBox"
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
