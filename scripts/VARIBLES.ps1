function OnlyWindows {
    if (($IsLinux) -or ($IsMacOS)) {
Write-Host -ForegroundColor red "This installation is for windows systems only."
Exit 1;
}
}

OnlyWindows

$OSNAME = (Get-WmiObject -Class Win32_OperatingSystem).Caption.ToLower()
$BOARD_VENDOR = (Get-CimInstance Win32_ComputerSystemProduct).Vendor.ToLower()

$NEW_HOSTNAME = "herrwinfried"

$Username=$env:USERNAME
$HomePWD=$env:USERPROFILE

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

function ModuleInstall {
    param (
        [Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][String]$ModuleName
        )
        if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
            Install-Module -Name $ModuleName -Force
        } else {
            Write-Warning "Module $ModuleName is already installed."
         
        }   
        Import-Module -Name $ModuleName
}

function PackageProviderInstall {
    param (
        [Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][String]$ProviderName
        )
        if (-not (Get-Module -ListAvailable -Name $ProviderName)) {
            Install-PackageProvider -Name $ProviderName -Force
        } else {
            Write-Warning "Package Provider $ProviderName is already installed."
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

function Remove-File {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$item
    )
    if (Test-Path -Path $item) {
        Remove-Item -Path $item -Recurse -Force
    }
}

function Download-File {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$url,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$desc
    )
    Remove-File $desc
    Invoke-WebRequest $url -OutFile $desc
}

function Create-Folder {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$folder
    )
    if (-Not (Test-Path -Path $folder) ) {
        New-Item -Path $folder -ItemType Directory
    }
}