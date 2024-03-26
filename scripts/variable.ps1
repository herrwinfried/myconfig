function red_message {
    param (
        [Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][String]$message
    )
    Write-Host -ForegroundColor Red $message
}

function CheckWindows {
    if (($IsLinux) -or ($IsMacOS)) {
        Write-Host -ForegroundColor Red $LANG_NOTWINDOWS
        Exit 1;
        }
}

$OSNAME = (Get-WmiObject -Class Win32_OperatingSystem).Caption.ToLower()
$BOARD_VENDOR = (Get-CimInstance Win32_ComputerSystemProduct).Vendor.ToLower()

$USERNAME=$env:USERNAME
$USERHOME=$env:USERPROFILE

Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
     
    $ErrorActionPreference = "stop"
    try { if (Get-Command $command) { return $True } }
     
    Catch { return $False }
     
    Finally { $ErrorActionPreference = $oldPreference }
}

function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
function Required_script {
    $i = 0

    if (-not (Test-CommandExists git)) {
        red_message $LANG_GIT_COMMAND_NOT_FOUND
        $i++
    }

    if ($i -ne 0) {
        exit 1
    }
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

function EXE_SHELL {
    param (
        [string]$script_folder
    )

    foreach ($forScriptFile in (Get-ChildItem -Path $script_folder -Filter *.ps1)) {
        Write-Host -ForegroundColor Magenta "$forScriptFile"
        Start-Sleep -Seconds 1
        . "$script_folder\$forScriptFile"
    }
}

function CHECK_SHELL_DIRECTORY {
    param (
        [string]$folder,
        [string]$version
    )
    if (Test-Path -Path "$ScriptFolder\$folder\$version" -PathType Container) {
        return $true
    } else {
        return $false
    }
}


function New-Font-Online {
    param(
        [Parameter(Mandatory, HelpMessage="Web address of the file")]
        [ValidateNotNullOrEmpty()]
        [string]$Url,

        [Parameter(Mandatory, HelpMessage="Font full name including .ttf or .otf")]
        [ValidateNotNullOrEmpty()]
        [string]$Family,

        [Parameter(HelpMessage="Is System?")]
        [Alias("s")]
        [switch]$System
    )

    $Destination = if ($System) { "C:\Windows\fonts" } else { "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts" }
    $Registry = if ($System) { "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" } else { "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" }
    $ValidExtensions = ".ttf", ".otf"

    if ($ValidExtensions -notcontains [System.IO.Path]::GetExtension($Family).ToLower()) {
        Write-Host -ForegroundColor Red "Not supported extension: $fileExtension. Only .ttf and .otf files are supported."
        return
    }

    if (-not (Test-Path $Destination)) {
        New-Item -Path $Destination -ItemType Directory | Out-Null
    }

    $FontType = if ([System.IO.Path]::GetExtension($Family) -eq ".otf") { "OpenType" } else { "TrueType" }
    $FontRegistryKey = "$($Family -replace '\..+$') ($FontType)"

    if (-not (Test-Path "$Registry\$FontRegistryKey")) {
        Invoke-WebRequest -Uri $Url -OutFile "$env:TEMP\$Family" | Out-Null
        $FontFullName = Join-Path -Path $Destination -ChildPath $Family
        Move-Item -Path "$env:TEMP\$Family" -Destination $FontFullName -Force | Out-Null
        Set-ItemProperty -Path $Registry -Name $FontRegistryKey -Value $(if ($System) { $Family } else { "$Destination\$Family" })
    }
    else {
        $ExistingFontFile = (Get-ItemProperty -Path "$Registry\$FontRegistryKey" -ErrorAction SilentlyContinue)."(default)"
        Write-Warning "There can't be two fonts with the same name: $Family. Current file path: $ExistingFontFile"
    }
}

function New-Font {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Source,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Family,
        [Parameter(HelpMessage="Is System?")][Alias("s")][switch]$System
    )

    $Destination = if ($System) { "C:\Windows\fonts" } else { "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts" }
    $Registry = if ($System) { "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" } else { "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" }

    $ValidExtensions = ".ttf", ".otf"
    $FileExtension = [System.IO.Path]::GetExtension($Family).ToLower()

    if ($ValidExtensions -notcontains $FileExtension) {
        Write-Host -ForegroundColor Red "Unsupported extension: $FileExtension. Only .ttf and .otf files are supported."
        return
    }

    if (-not (Test-Path $Destination)) {
        New-Item -Path $Destination -ItemType Directory | Out-Null
    }

    $FontType = if ($FileExtension -eq ".otf") { "OpenType" } else { "TrueType" }
    $FontRegistryKey = "$($Family -replace '\..+$') ($FontType)"

    if (-not (Test-Path "$Registry\$FontRegistryKey")) {
        $FontFullName = Join-Path -Path $Destination -ChildPath $Family
        Move-Item -Path $Source -Destination $FontFullName -Force | Out-Null
        Set-ItemProperty -Path $Registry -Name $FontRegistryKey -Value $(if ($System) { $Family } else { "$Destination\$Family" })
    }
    else {
        $ExistingFontFile = (Get-ItemProperty -Path "$Registry\$FontRegistryKey" -ErrorAction SilentlyContinue)."(default)"
        Write-Warning "There can't be two fonts with the same name: $Family. Current file path: $ExistingFontFile"
    }
}

function Remove-Font {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Family,
        [Parameter(HelpMessage="Is System?")][Alias("s")][switch]$System
    )

    $Registry = if ($System) { "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" } else { "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" }
    $FontRegistryKey = [System.IO.Path]::GetFileNameWithoutExtension($Family)

    if (Test-Path "$Registry\$FontRegistryKey") {
        Remove-ItemProperty -Path $Registry -Name $FontRegistryKey -Force
        Write-Host -ForegroundColor Green "Removed font entry from the registry: $Family"
    }
    else {
        Write-Warning "Font entry not found in the registry: $Family"
    }

    $FontFile = Join-Path -Path $(if ($System) { "C:\Windows\fonts" } else { "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts" }) -ChildPath $Family

    if (Test-Path $FontFile) {
        Remove-Item -Path $FontFile -Force
        Write-Host -ForegroundColor Green "Removed font file: $FontFile"
    }
    else {
        Write-Warning "Font file not found: $FontFile"
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

###
$NEW_HOSTNAME = "herrwinfried"