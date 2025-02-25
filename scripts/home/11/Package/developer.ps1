$apps = @(
    @{
        Id          = "9NWMW7BB59HW" # KDE Kate
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
        Id          = "Nvidia.CUDA"
        Interactive = $False
    }
)

foreach ($app in $apps) {
    if ($app.Interactive) {
        Install-WingetPackage -Interactive 1 -PackageID $app.Id
    }
    else {
        Install-WingetPackage -PackageID $app.Id
    }
}