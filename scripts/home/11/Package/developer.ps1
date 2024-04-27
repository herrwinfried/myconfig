$apps = @(
    @{
        Id = "Git.Git"
        Interactive = $True
    },
    @{
        Id = "GitHub.GitLFS"
        Interactive = $False
    },
    @{
        Id = "GnuPG.Gpg4win"
        Interactive = $False
    },
    @{
        Id = "GnuPG.GnuPG"
        Interactive = $False
    },
    @{
        Id = "Microsoft.VisualStudioCode"
        Interactive = $False
    },
    @{
        Id = "Microsoft.AzureDataStudio"
        Interactive = $False
    },
    @{
        Id = "Microsoft.VisualStudio.2022.Community"
        Interactive = $False
    },
    @{
        Id = "KDE.Kate"
        Interactive = $False
    },
    @{
        Id = "Python.Python.3.12"
        Interactive = $False
    },
    @{
        Id = "OpenJS.NodeJS"
        Interactive = $False
    },
    @{
        Id = "ApacheFriends.Xampp.8.2"
        Interactive = $False
    },
    @{
        Id = "Docker.DockerDesktop"
        Interactive = $False
    },
    @{
        Id = "RedHat.Podman"
        Interactive = $False
    },
    @{
        Id = "RedHat.Podman-Desktop"
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