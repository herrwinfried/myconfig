$apps = @(
    "GitHub.GitLFS",
    "GnuPG.Gpg4win",
    "GnuPG.GnuPG",
    "Microsoft.VisualStudioCode",
    "Microsoft.AzureDataStudio",
    "Microsoft.VisualStudio.2022.Community",
    "KDE.Kate",
    "Python.Python.3.12",
    "Docker.DockerDesktop",
    "RedHat.Podman",
    "RedHat.Podman-Desktop"
)

$apps_interactive  = @(
    "Git.Git"
)

foreach ($app in $apps_interactive) {
    WingetInstall -Interactive 1 -Id $app
}

foreach ($app in $apps) {
    WingetInstall -Id $app
}