[string]$GetModuleName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
$GetScriptDir = $PSScriptRoot
# Language support
if (-Not ($Lang)) { $Lang = $PSUICulture }
$GetLanguageModuleFile = "$PSScriptRoot/lang/$Lang/$GetModuleName.psd1"

if (-Not (Test-Path "$PSScriptRoot/lang/en-US/$GetModuleName.psd1")) {
    Write-Error "There is no language file. Module exited."
    Exit 1
}
elseif (Test-Path $GetLanguageModuleFile) {
    $LanguageModule = Import-LocalizedData -BaseDirectory "$PSScriptRoot/lang" -FileName $($GetModuleName).psd1 -UICulture $Lang
}
elseif (-Not (Test-Path $GetLanguageModuleFile)) {
    $LanguageModule = Import-LocalizedData -BaseDirectory "$PSScriptRoot/lang" -FileName $($GetModuleName).psd1 -UICulture "en-US"
}
# language support complete

function Show-Help {
    Write-Host "Usage: .\install.ps1 [-h] [-ps] [-cc] [-c] [-l <lang>]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Parameters:" -ForegroundColor Yellow
    Write-Host "  [NO PARAMS]   Run Script"
    Write-Host "  -h, -?        Show this help message."
    Write-Host "  -ps           Run pre-setup actions."
    Write-Host "  -cc           Run only configuration."
    Write-Host "  -c            Run configuration."
    Write-Host "  -l <lang>     Set language (e.g., en-US, tr-TR)." 
}
Export-ModuleMember -Function Show-Help
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
            [Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][Alias("id", "p")][String]$PackageID
        )
        $RequireVersion = "1.11.510"
        $installedVersion = winget --version 2>&1 | Select-String -Pattern '(\d+(\.\d+){2})' -AllMatches | ForEach-Object { $_.Matches.Value }

        if ($installedVersion -ge $RequireVersion) {
            if ($Interactive) {
                $runCommand = "winget.exe install --interactive --id $PackageID --accept-package-agreements --accept-source-agreements"
            }
            else {
                $runCommand = "winget.exe install --id $PackageID --accept-package-agreements --accept-source-agreements"
            }
            Invoke-Expression $runCommand
        }
        else {
            Write-Host-Red "I couldn't install package $PackageID because your Winget version is not $RequireVersion or higher."
        }
    } 
    Export-ModuleMember -Function Install-WingetPackage
}
else {
    Write-Warning "$(LanguageModule.NotFoundWinget)"
}

function Invoke-Download {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$url,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$desc
    )
    Remove-Item $desc
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
        . $File.FullName
    }
}
Export-ModuleMember -Function Invoke-ScriptFile

function Test-ScriptDirectory {
    param (
        [Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][string]$WindowsVersion
    )

    if (Test-Path -Path "$GetScriptDir\OS\$WindowsVersion" -PathType Container) {
        return $true
    }
    else {
        return $false
    }
}

Export-ModuleMember -Function Test-ScriptDirectory

function PreSetupFinishMessage {
    Write-Host -ForegroundColor Yellow "$($LanguageModule.PreSetupMessageOne)"
    Write-Host -ForegroundColor Cyan "$($LanguageModule.PreSetupMessageTwo)"
    Exit 1;
}

Export-ModuleMember -Function PreSetupFinishMessage

function Invoke-InstallScript {
    param (
        [Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][string]$OSDirPath,
[Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][switch]$Presetup,
[Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][switch]$OnlyConfig,
[Parameter (Mandatory = $true)][ValidateNotNullOrEmpty()][switch]$Config
    )

    if (-not (Test-ScriptDirectory $OSDirPath)) {
        Write-Host "$($LanguageModule.NotSupport)"
        exit 1
    }
    else {
        if ($Presetup) {
            Invoke-ScriptFile "$GetScriptDir/OS/$OSDirPath/Presetup"
            PreSetupFinishMessage
        }
        if ($OnlyConfig) {
            Invoke-ScriptFile "$GetScriptDir/OS/$OSDirPath/Config"
            exit 1
        }
        Invoke-ScriptFile "$GetScriptDir/OS/$OSDirPath/Process"
        if ($Config) {
            Invoke-ScriptFile "$GetScriptDir/OS/$OSDirPath/Config"
        }
    }
}

Export-ModuleMember -Function Invoke-InstallScript