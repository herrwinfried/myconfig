if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct alias file?"
    Exit 1
}

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

function New-Font-Online {
    param(
        [Parameter(Mandatory, HelpMessage="web address of the file")][ValidateNotNullOrEmpty()][string]$url,
        [Parameter(Mandatory, HelpMessage="font full name including .ttf or .otf")][ValidateNotNullOrEmpty()][string]$Family,
        [Parameter(HelpMessage="is System?")][Alias("s")]
        [switch]$System
    )
        <#
    .DESCRIPTION
    It downloads fonts from the internet and adds them to the global font list.

    .EXAMPLE
    New-Font-Online -url "https://example.com/meslonf.ttf" -Family "xMesloNF.ttf"
    It downloads from https://example.com/meslonf.ttf, uploads it to the 
    $env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts folder as xMesloNF.ttf, and regedit specifies the font name.

    #>
    if ($System) {
        [string]$Destination = "C:\Windows\fonts"
        [string]$Registry = "HKLM:\\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    } else {
        [string]$Destination = "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts"
        [string]$Registry = "HKCU:\\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    }

    $validExtensions = @(".ttf", ".otf") 

    $fileExtension = [System.IO.Path]::GetExtension($Family)

    if ($validExtensions -contains $fileExtension.ToLower()) {
	if (-NOT (Test-Path $Destination)) {
	New-Item -Path $Destination -ItemType Directory
	}
        $fontType = if ($fileExtension -eq ".otf") { "OpenType" } else { "TrueType" }

        $fontRegistryKey = [System.IO.Path]::GetFileNameWithoutExtension($Family)
        $fontRegistryKey = "$fontRegistryKey ($fontType)"

        if (-not (Test-Path "$Registry\$fontRegistryKey")) {
            Invoke-WebRequest -Uri $url -OutFile $env:TEMP/$Family
            $fontFullName = Join-Path -Path $Destination -ChildPath $Family
            Move-Item -Path $env:TEMP/$Family -Destination $fontFullName -Force
            if ($System) {
                Set-ItemProperty -Path $Registry -Name $fontRegistryKey -Value $Family
            } else {
                Set-ItemProperty -Path $Registry -Name $fontRegistryKey -Value "$Destination\$Family"
        }
           
        }
        else {
            $existingFontFile = Get-ItemProperty -Path "$Registry\$fontRegistryKey" | Select-Object -ExpandProperty "(default)"
            Write-Warning "There can't be two fonts with the same name: $Family. Current file path: $existingFontFile"
        }
    }
    else {
        Write-Host -ForegroundColor Red "Not Support: $fileExtension. only .ttf and .otf files are supported."
    }
}

function New-Font {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$source,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Family,
        [Parameter(HelpMessage="is System?")][Alias("s")]
        [switch]$System
    )
          <#
    .DESCRIPTION
    Adds global font to the selected font file.

    .EXAMPLE
    New-Font -source "c:/myfont/meslonf.ttf" -Family "xMesloNF.ttf" 
    Copies c:/myfont/meslon.ttf and adds xMesloNF.ttf to
     $env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts folder and regedit specifies the font name.

    #>

    if ($System) {
        [string]$Destination = "C:\Windows\fonts"
        [string]$Registry = "HKLM:\\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    } else {
        [string]$Destination = "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts"
        [string]$Registry = "HKCU:\\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    }
  $validExtensions = @(".ttf", ".otf") 

  $fileExtension = [System.IO.Path]::GetExtension($Family)

  if ($validExtensions -contains $fileExtension.ToLower()) {
	if (-NOT (Test-Path $Destination)) {
	New-Item -Path $Destination -ItemType Directory
	}
      $fontType = if ($fileExtension -eq ".otf") { "OpenType" } else { "TrueType" }

      $fontRegistryKey = [System.IO.Path]::GetFileNameWithoutExtension($Family)
      $fontRegistryKey = "$fontRegistryKey ($fontType)"

      if (-not (Test-Path "$Registry\$fontRegistryKey")) {
        $fontFullName = Join-Path -Path $Destination -ChildPath $Family
        Move-Item -Path $Family -Destination $fontFullName -Force
        if ($System) {
            Set-ItemProperty -Path $Registry -Name $fontRegistryKey -Value $Family
        } else {
            Set-ItemProperty -Path $Registry -Name $fontRegistryKey -Value "$Destination\$Family"
    }
        }
        else {
            $existingFontFile = Get-ItemProperty -Path "$Registry\$fontRegistryKey" | Select-Object -ExpandProperty "(default)"
            Write-Warning "There can't be two fonts with the same name: $Family. Current file path: $existingFontFile"
        }
    }
    else {
        Write-Host -ForegroundColor Red "Not Support: $fileExtension. only .ttf and .otf files are supported."
    }
}

function Remove-Font {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Family,
        [Parameter(HelpMessage="is System?")][Alias("s")]
        [switch]$System
    )

    <#
    .DESCRIPTION
    Removes the selected font.

    .EXAMPLE
    New-Font -Family "xMesloNF.ttf" 
    It removes xMesloNF.ttf from the computer and 
    deletes it from the registry.
    #>

    if ($System) {
        [string]$Registry = "HKLM:\\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    } else {
        [string]$Registry = "HKCU:\\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    }

    $fontRegistryKey = [System.IO.Path]::GetFileNameWithoutExtension($Family)

    if (Test-Path "$Registry\$fontRegistryKey") {
        Remove-ItemProperty -Path $Registry -Name $fontRegistryKey -Force
        Write-Host -ForegroundColor Green "Removed font entry from the registry: $Family"
    }
    else {
        Write-Warning "Font entry not found in the registry: $Family"
    }

    if ($System) {
        $fontFile = Join-Path -Path "C:\Windows\fonts" -ChildPath $Family
    } else {
        $fontFile = Join-Path -Path "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts" -ChildPath $Family
    }

    if (Test-Path $fontFile) {
        Remove-Item -Path $fontFile -Force
        Write-Host -ForegroundColor green "Removed font file: $fontFile"
    }
    else {
        Write-Warning "Font file not found: $fontFile"
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

function aliasUpdate {
    if ((Test-Path $ContainerAdmin) -And (Test-Path $ContainerUser)) {
        $aliasFile = "C:/Users/Public/.alias.ps1"
    } else {
        $aliasFile = "$HOME/.alias.ps1"
    }
    Invoke-WebRequest -Uri https://raw.githubusercontent.com/herrwinfried/myconfig/windows/dotfiles/home/.alias.ps1 -OutFile $aliasFile
}