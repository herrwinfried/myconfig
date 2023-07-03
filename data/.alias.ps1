if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct alias file?"
    Exit 1
}

Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
   
    $ErrorActionPreference = "stop"
    try {
        if (Get-Command $command) {
            return $True
        }
    }   
    Catch {
        return $False
    }   
    Finally {
        $ErrorActionPreference = $oldPreference
    }
}

# ONLY POWERSHELL CORE (6+.X.X)
if ((Get-Host).Version.Major -ne 6) { 

    # :/
    $ContainerAdmin = "C:/Users/ContainerAdministrator"  
    $ContainerUser = "C:/Users/ContainerUser"  

    if ((Test-Path $ContainerAdmin) -And (Test-Path $ContainerUser)) {
        $OhMyPoshTheme = "C:/Users/Public/.poshthemes/default.omp.json"   
    } else {
        $OhMyPoshTheme = "$HOME/.poshthemes/default.omp.json"  
    }

    if ((Test-Path $OhMyPoshTheme) -And (Test-CommandExists oh-my-posh)) {
        oh-my-posh init pwsh --config $OhMyPoshTheme | Invoke-Expression 

        function OhMyPoshThemeUpdate {
            if ((Test-Path $ContainerAdmin) -And (Test-Path $ContainerUser)) {
                $themeFile = "C:/Users/Public/.poshthemes/default.omp.json"
            } else {
                $themeFile = "$HOME/.poshthemes/default.omp.json"
            }
            Invoke-WebRequest -Uri https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/default.omp.json -OutFile $themeFile
        }
    }
}

if (Test-Path "$Env:ProgramFiles\Docker\Docker\DockerCli.exe") {
    function DockerSwitch() {
        & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon
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

if (Test-CommandExists winget) {
    function winget_yes {
        param (
            [Parameter(Mandatory = $true)]
            [String]$Id
        )
        winget install --id $Id --accept-package-agreements --accept-source-agreements
    }
}

function aliasUpdate {
    if ((Test-Path $ContainerAdmin) -And (Test-Path $ContainerUser)) {
        $aliasFile = "C:/Users/Public/.alias.ps1"
    } else {
        $aliasFile = "$HOME/.alias.ps1"
    }
    Invoke-WebRequest -Uri https://raw.githubusercontent.com/herrwinfried/myconfig/windows/data/.alias.ps1 -OutFile $aliasFile
}
