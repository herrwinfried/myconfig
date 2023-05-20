if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct Script?"
   Start-Sleep -Seconds 3
    Exit 1
}
wingetx -Id JetBrains.Toolbox
wingetx -Id Microsoft.VisualStudioCode
wingetx -Id Microsoft.AzureDataStudio
wingetx -Id Microsoft.VisualStudio.2022.Community
wingetx -Id 9NWMW7BB59HW #Kate
wingetx -Id 9NK1GDVPX09V #termius
#wingetx -Id GitHub.GitHubDesktop
wingetx -Id Git.Git
wingetx -Id GitHub.GitLFS
wingetx -Id OpenJS.NodeJS
wingetx -Id GnuPG.Gpg4win
wingetx -Id GnuPG.GnuPG
#wingetx -Id Microsoft.SQLServerManagementStudio
#wingetx -Id RedHat.Podman 
#wingetx -Id RedHat.Podman-Desktop
wingetx -Id Docker.DockerDesktop
wingetx -Id VMware.WorkstationPro