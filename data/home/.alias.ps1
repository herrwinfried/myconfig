if ($isLinux -Or $IsMacOS) {
    Write-Error "This alias file is for Powershell for windows. Are you sure this is the correct file?"
    Exit 1
}

$OhMyPoshTheme = "~/.poshthemes/default.omp.json"

function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
     
    $ErrorActionPreference = "stop"
    try { if (Get-Command $command) { return $True } }
     
    Catch { return $False }
     
    Finally { $ErrorActionPreference = $oldPreference }
}

if (Test-CommandExists winget) {
    function WingetInstall {
        param (
            [Parameter()][bool]$Interactive = $false,
            [Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][String]$Id
            )
            if (Test-CommandExists winget) {
                if ($Interactive) {
                    $runCommand = "winget.exe install --interactive --id $Id --accept-package-agreements --accept-source-agreements --force"
                } else {
                    $runCommand = "winget.exe install --id $Id --accept-package-agreements --accept-source-agreements --force"
                }
                
                Invoke-Expression $runCommand
                } else {
                    Write-Warning "winget was not found, so it will not be installed. The program with ID $Id ."
                }
    }
}

if (Test-CommandExists docker) {
    function DockerModeInfo() {
        $dockerCommand = docker info 2>$null | Select-String OSType
        if ($dockerCommand -and $dockerCommand.Line -match 'OSType:\s*(\S+)') {
            $ostype = $Matches[1]
            Write-Host "Docker Run Type: $ostype"
        } else {
            Write-Host "Can't find Docker Run Type..."
        }
    }

    function DockerModeInfoValue() {
        $dockerCommand = docker info 2>$null | Select-String OSType
        if ($dockerCommand -and $dockerCommand.Line -match 'OSType:\s*(\S+)') {
            $ostype = $Matches[1]
            return $ostype
        }
    }
}


if ((Test-Path $OhMyPoshTheme) -And (Test-CommandExists oh-my-posh)) {
    oh-my-posh init pwsh --config $OhMyPoshTheme | Invoke-Expression 
}

function aliasUpdate {
    if ((Test-Path $ContainerAdmin) -And (Test-Path $ContainerUser)) {
        $aliasFile = "C:/Users/Public/.alias.ps1"
        $aliasFileBash = "C:/Users/Public/.alias"
    } else {
        $aliasFile = "$HOME/.alias.ps1"
        $aliasFileBash = "$HOME/.alias"
    }
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/windows/data/home/.alias.ps1" -OutFile "$aliasFile"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/windows/data/home/.alias" -OutFile "$aliasFileBash"
}

