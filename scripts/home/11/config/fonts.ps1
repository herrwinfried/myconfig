function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (IsAdministrator) {
    Set-Location $PSScriptRoot\..\..\..\
    $TempFolder=$(Get-Location)
    . "$TempFolder\variable.ps1"

    $fontUrls = @(
        @{
            Url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
            FileName = "MesloLGS NF Bold Italic.ttf"
        },
        @{
            Url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
            FileName = "MesloLGS NF Bold.ttf"
        },
        @{
            Url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
            FileName = "MesloLGS NF Italic.ttf"
        },
        @{
            Url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
            FileName = "MesloLGS NF Regular.ttf"
        }
    )

    foreach ($fontInfo in $fontUrls) {
        New-Font-Online -Url $fontInfo.Url -Family $fontInfo.FileName
    }
} else {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
}
