$apps = @(
    "Brave.Brave",
    "Mozilla.Firefox",
    
    "7zip.7zip",
    
    "9WZDNCRFHWL", # HP Smart
    
    "9PP9GZM2GN26", # Intel Unison
    "Microsoft.PowerToys",
    "Flameshot.Flameshot",
    
    "9P9TQF7MRM4R", # Windows Subsystem for Linux (WSL)
    "9MSSK2ZXXN11", # OpenSUSE Tumbleweed for WSL
    "9MSVKQC78PK6", # Debian for WSL
    "9NPCP8DRCHSN", # Fedora for WSL (Community Version / Not Official)
    
    "9NKSQGP7F2NH", # Whatsapp
    "9N97ZCKPD60Q", # Unigram
    "Telegram.TelegramDesktop",
    "Discord.Discord",
    "Discord.Discord.PTB",
    "Discord.Discord.Canary",
    "Discord.Discord.Development",
    "Element.Element",
    
    "RevoUninstaller.RevoUninstaller",
    "KDE.KDEConnect",
    "KDE.Okular",
    "Stremio.Stremio",
    
    "XPDM1ZW6815MQM", # VLC
    
    "9N9WCLWDQS5J", # Bluetooth Audio Receiver
    
    "BlueStack.BlueStacks",
    "OpenVPNTechnologies.OpenVPNConnect",
    "AnyDeskSoftwareGmbH.AnyDesk",
    "TeamViewer.TeamViewer",
    "Valve.Steam",
    "HeroicGamesLauncher.HeroicGamesLauncher",
    "EpicGames.EpicGamesLauncher",
    "ElectronicArts.EADesktop",
    "Ubisoft.Connect",
    "OBSProject.OBSStudio",
    
    "TheDocumentFoundation.LibreOffice",
    
    "Yandex.Disk",
    "Google.GoogleDrive",
    
    "Oracle.VirtualBox",
    "VMware.WorkstationPro",
    
    "qBittorrent.qBittorrent"
)


$apps_interactive  = @()

foreach ($app in $apps_interactive) {
    WingetInstall -Interactive 1 -Id $app
}

foreach ($app in $apps) {
    WingetInstall -Id $app
}