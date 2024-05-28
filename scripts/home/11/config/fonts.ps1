function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (IsAdministrator) {
    # FIXME: :/ Hey, if you know a more logical way, I'm open to suggestions.
    Set-Location $PSScriptRoot\..\..\..\
    $TempFolder=$(Get-Location)
    . "$TempFolder\config.ps1"
    Import-Module "$TempFolder\function.psm1"
    Set-Location $PSScriptRoot
    ##############################################################

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
        Invoke-Download -url $fontInfo.Url -desc "$env:TEMP\$fontInfo.FileName"
        New-Font -Source "$env:TEMP\$fontInfo.FileName" -Family $fontInfo.FileName -System
    }
} else {
    if (Test-CommandExists pwsh) {
        Start-Process pwsh.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs -Wait   
    } else {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs -Wait   
    }
}