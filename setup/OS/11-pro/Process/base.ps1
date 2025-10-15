# basic apps

$apps = @(
    @{
        Id          = "Microsoft.Sysinternals.Suite"
        Interactive = "$false"
    },
    @{
        Id          = "Fastfetch-cli.Fastfetch"
        Interactive = $False
    },
    @{
        Id          = "Klocman.BulkCrapUninstaller"
        Interactive = $False
    },
    @{
        Id          = "Microsoft.OpenJDK.21"
        Interactive = $False
    },
    @{
        Id          = "EclipseAdoptium.Temurin.8.JDK"
        Interactive = $False
    },
    @{
        Id          = "Microsoft.PowerShell"
        Interactive = $False
    },
    @{
        Id          = "JanDeDobbeleer.OhMyPosh"
        Interactive = $False
    },
    @{
        Id          = "WiresharkFoundation.Wireshark"
        Interactive = $False
    }
)

if ($ConfigData.GetBoardVendor -ilike "*asus*") {
    $apps += @(
        @{
            Id          = "9N7R5S6B0ZZH" # MyAsus
            Interactive = $False
        },
        @{
            Id          = "9PLH2SV1DVK5" # Glidex
            Interactive = $False
        }
    )
}

# Auth, Browser, File Tool, VPN, WSL, Apple products
$apps += @(
    @{
        Id          = "Proton.ProtonAuthenticator"
        Interactive = $False
    },
    @{
        Id          = "Brave.Brave"
        Interactive = $False
    },
    @{
        Id          = "Mozilla.Firefox"
        Interactive = $False
    },
    @{
        Id          = "7zip.7zip"
        Interactive = $False
    },
    @{
        Id          = "AdrienAllard.FileConverter"
        Interactive = $False
    },
    @{
        Id          = "9PFXCD722M2C" # KDE Filelight
        Interactive = $False
    },
    @{
        Id          = "OpenVPNTechnologies.OpenVPNConnect"
        Interactive = $False
    },
    @{
        Id          = "WireGuard.WireGuard"
        Interactive = $False
    },
    @{
        Id          = "Cloudflare.Warp"
        Interactive = $False
    },
    @{
        Id          = "9P9TQF7MRM4R" # Windows Subsystem for Linux (WSL)
        Interactive = $False
    },
    @{
        Id          = "9PKTQ5699M62" # iCloud
        Interactive = $False
    },
    @{
        Id          = "9PB2MZ1ZMB1S" # iTunes
        Interactive = $False
    },
    @{
        Id          = "9NP83LWLPZ9K" # Apple Devices
        Interactive = $False
    }
    @{
        Id          = "9PFHDD62MXS1" # Apple Music
        Interactive = $False
    },
    @{
        Id          = "9NM4T8B9JQZ1" # Apple TV
        Interactive = $False
    }
)

# Games
$apps += @(
    @{
        Id          = "Valve.Steam"
        Interactive = $False
    },
    @{
        Id          = "HeroicGamesLauncher.HeroicGamesLauncher"
        Interactive = $False
    },
    @{
        Id          = "EpicGames.EpicGamesLauncher"
        Interactive = $False
    },
    @{
        Id          = "ElectronicArts.EADesktop"
        Interactive = $False
    },
    @{
        Id          = "Ubisoft.Connect"
        Interactive = $False
    },
    @{
        Id          = "PrismLauncher.PrismLauncher"
        Interactive = $False
    }
)

# AI, Messenger, Office, Customizer, Remote Desktop Apps, Screenshot Cloud Drive
$apps += @(
    @{
        Id          = "9NT1R1C2HH7J" # ChatGPT
        Interactive = $False
    }
    @{
        Id          = "9WZDNCRFHWLH" # HP Smart
        Interactive = $False
    },
    @{
        Id          = "AnyDeskSoftwareGmbH.AnyDesk"
        Interactive = $False
    },
    @{
        Id          = "TeamViewer.TeamViewer"
        Interactive = $False
    },
    @{
        Id          = "RustDesk.RustDesk"
        Interactive = $False
    },
    @{
        Id          = "LocalSend.LocalSend"
        Interactive = $False
    },
    @{
        Id          = "dev47apps.DroidCam"
        Interactive = $False
    },
    @{
        Id          = "9N93MRMSXBF0" # KDE Connect
        Interactive = $False
    },
    @{
        Id          = "9NKSQGP7F2NH" # Whatsapp
        Interactive = $False
    },
    @{
        Id          = "9N97ZCKPD60Q" # Unigram
        Interactive = $False
    },
    @{
        Id          = "Discord.Discord"
        Interactive = $False
    },
    @{
        Id          = "Element.Element"
        Interactive = $False
    },
    @{
        Id          = "TheDocumentFoundation.LibreOffice"
        Interactive = $False
    },
    @{
        Id          = "Microsoft.PowerToys"
        Interactive = $False
    },
    @{
        Id          = "ShareX.ShareX"
        Interactive = $False
    },
    @{
        Id          = "OBSProject.OBSStudio"
        Interactive = $False
    },
    @{
        Id          = "KDE.Kdenlive"
        Interactive = $False
    },
    @{
        Id          = "Google.GoogleDrive"
        Interactive = $False
    }
)

# Text Editor, IDE, GPG Tools, C#, NodeJS, Containers
$apps += @(
    @{
        Id          = "9NWMW7BB59HW" # KDE Kate
        Interactive = $False
    },
    @{
        Id          = "Obsidian.Obsidian"
        Interactive = $False
    },
    @{
        Id          = "Microsoft.VisualStudioCode"
        Interactive = $False
    },
    @{
        Id          = "Microsoft.VisualStudio.2022.Community"
        Interactive = $False
    },
    @{
        Id          = "JetBrains.Toolbox"
        Interactive = $False
    },
    @{
        Id          = "Git.Git"
        Interactive = $True
    },
    @{
        Id          = "GitHub.GitLFS"
        Interactive = $False
    },
    @{
        Id          = "GLab.GLab"
        Interactive = $False
    },
    @{
        Id          = "GitHub.cli"
        Interactive = $False
    },
    @{
        Id          = "GnuPG.Gpg4win"
        Interactive = $False
    },
    @{
        Id          = "GnuPG.GnuPG"
        Interactive = $False
    },
    @{
        Id          = "Microsoft.DotNet.SDK.9"
        Interactive = $False
    },
    @{
        Id          = "OpenJS.NodeJS"
        Interactive = $False
    },
    @{
        Id          = "Docker.DockerDesktop"
        Interactive = $False
    },
    @{
        Id          = "Oracle.VirtualBox"
        Interactive = $False
    }
)

if (Get-CimInstance Win32_VideoController | Where-Object { $_.Name -ilike "*NVIDIA*" }) {
    $apps += @{
        Id          = "Nvidia.CUDA"
        Interactive = $False
    }
} 

# Later, prevent the firewall from running in the Public and Domain profiles due to security risk.
$apps += @{
    Id          = "Microsoft.WindowsAdminCenter"
    Interactive = $True
}

foreach ($app in $apps) {
    if ($app.Interactive) {
        Install-WingetPackage -Interactive 1 -PackageID $app.Id
    }
    else {
        Install-WingetPackage -PackageID $app.Id
    }
}