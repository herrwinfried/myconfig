[string]$GetModuleName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)

# Language support
if (-Not ($Lang)) { $Lang = $PSUICulture }
$GetLanguageModuleFile = "$PSScriptRoot/lang/$Lang/$GetModuleName.psd1"

if (-Not (Test-Path "$PSScriptRoot/lang/en-US/$GetModuleName.psd1")) {
        Write-Error "There is no language file. Module exited."
        Exit 1
} elseif (Test-Path $GetLanguageModuleFile) {
    $LanguageModule = Import-LocalizedData -BaseDirectory "$PSScriptRoot/lang" -FileName $($GetModuleName).psd1 -UICulture $Lang
} elseif (-Not (Test-Path $GetLanguageModuleFile)) {
    $LanguageModule = Import-LocalizedData -BaseDirectory "$PSScriptRoot/lang" -FileName $($GetModuleName).psd1 -UICulture "en-US"
}
# language support complete

function Write-Host-Red {
    Param (    
        [Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][String]$echo
    )
    Write-Host -ForegroundColor Red $echo
}
Export-ModuleMember -Function Write-Host-Red
Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
     
    $ErrorActionPreference = "stop"
    try { if (Get-Command $command) { return $True } }
     
    Catch { return $False }
     
    Finally { $ErrorActionPreference = $oldPreference }
}
Export-ModuleMember -Function Test-CommandExists
function Test-isWindows {
    if ((-Not (Test-CommandExists Get-WmiObject)) -or ($IsLinux) -or ($IsMacOS)) {
        Write-Host-Red "$($LanguageModule.isNotWindows)"
        Exit 1;
    }
}
Export-ModuleMember -Function Test-isWindows
function Test-IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
Export-ModuleMember -Function Test-IsAdministrator

if (Test-CommandExists winget) {
    function Install-WingetPackage {
        param (
            [Parameter()][Alias("i")][bool]$Interactive = $false,
            [Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][Alias("id","p")][String]$PackageID
            )
        $RequireVersion = "1.7.10861"
        $installedVersion = winget --version 2>&1 | Select-String -Pattern '(\d+(\.\d+){2})' -AllMatches | ForEach-Object { $_.Matches.Value }

        if ($installedVersion -ge $RequireVersion) {
            if ($Interactive) {
                $runCommand = "winget.exe install --interactive --id $PackageID --accept-package-agreements --accept-source-agreements"
            } else {
                $runCommand = "winget.exe install --id $PackageID --accept-package-agreements --accept-source-agreements"
            }
            Invoke-Expression $runCommand
        } else {
            Write-Host-Red "I couldn't install package $PackageID because your Winget version is not $RequireVersion or higher."
        }
    } 
    Export-ModuleMember -Function Install-WingetPackage
} else {
    Write-Warning "$(LanguageModule.NotFoundWinget)"
}

function Install-Module2 {
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
Export-ModuleMember -Function Install-Module2
function Install-PackageProvider2 {
    param (
        [Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][String]$ProviderName
        )
        if (-not (Get-Module -ListAvailable -Name $ProviderName)) {
            Install-PackageProvider -Name $ProviderName -Force
        } else {
            Write-Warning "Package Provider $ProviderName is already installed."
        }
}
Export-ModuleMember -Function Install-PackageProvider2

function Remove-Item2 {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$item
    )
    if (Test-Path -Path $item) {
        Remove-Item -Path $item -Recurse -Force
    }
}
Export-ModuleMember -Function Remove-Item2

function Invoke-Download {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$url,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$desc
    )
    Remove-Item2 $desc
    Invoke-WebRequest $url -OutFile $desc
}
Export-ModuleMember -Function Invoke-Download

function New-Directory {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$folder
    )
    if (-Not (Test-Path -Path $folder) ) {
        New-Item -Path $folder -ItemType Directory
    }
}
Export-ModuleMember -Function New-Directory

function Invoke-ScriptFile {
    param (
        [Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][string]$Directory
    )
    foreach ($File in (Get-ChildItem -Path $Directory -Filter *.ps1)) {
        Write-Host -ForegroundColor Magenta "$File"
        Start-Sleep -Seconds 1
        . "$Directory\$File"
    }
}
Export-ModuleMember -Function Invoke-ScriptFile

function Test-ScriptDirectory {
    param (
        [Parameter (Mandatory = $true)][ValidateSet("home", "server", "vm")][string]$Type,
        [Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][string]$WindowsVersion
    )

    if (Test-Path -Path "$GetScriptDir\$Type\$WindowsVersion" -PathType Container) {
        return $true
    } else {
        return $false
    }
}

Export-ModuleMember -Function Test-ScriptDirectory

function BothOptionArguments {
    Write-Warning "$($LanguageModule.BothWarningArg)"
    Write-Host "[1] $($LanguageModule.BothWarningArgYes)"
    Write-Host "[2] $($LanguageModule.BothWarningArgNo)"
    $IFREAD = Read-Host
    if (($IFREAD -ne 1) -and ($IFREAD -ne 2)) {
        Write-Host-Red "$($LanguageModule.InvalidNumberOption)"
        BothOptionArguments
    }
    elseif ($IFREAD -eq 2) {
        exit 1
    }
} 

Export-ModuleMember -Function BothOptionArguments

function PreSetupFinishMessage {
    Write-Host -ForegroundColor Yellow "$($LanguageModule.PreSetupMessageOne)"
    Write-Host -ForegroundColor Cyan "$($LanguageModule.PreSetupMessageTwo)"
    Exit 1;
}

Export-ModuleMember -Function PreSetupFinishMessage

function Invoke-InstallScript {
    param (
        [Parameter (Mandatory = $true)][ValidateSet("home", "server", "vm")][string]$Type,
        [Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][string]$OSDirPath
    )

    if (-not (Test-ScriptDirectory "$Type" $OSDirPath)) {
        Write-Host "$($LanguageModule.NotSupport) [$Type]"
        exit 1
    } else {
        if ($Presetup) {
            Invoke-ScriptFile "$GetScriptDir/$Type/$OSDirPath/Presetup"
            PreSetupFinishMessage
        }
        if ($OnlyConfig) {
            Invoke-ScriptFile "$GetScriptDir/$Type/$OSDirPath/Config"
            exit 1
        }
        Invoke-ScriptFile "$GetScriptDir/$Type/$OSDirPath/FirstProcess"
        Invoke-ScriptFile "$GetScriptDir/$Type/$OSDirPath/Package"
        if ($Config) {
            Invoke-ScriptFile "$GetScriptDir/$Type/$OSDirPath/Config"
        }
        Invoke-ScriptFile "$GetScriptDir/$Type/$OSDirPath/RecentProcess"
    }
}

Export-ModuleMember -Function Invoke-InstallScript