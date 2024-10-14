Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
     
    $ErrorActionPreference = "stop"
    try { if (Get-Command $command) { return $True } }
     
    Catch { return $False }
     
    Finally { $ErrorActionPreference = $oldPreference }
}

if ((-Not (Test-CommandExists Get-WmiObject)) -or ($IsLinux) -or ($IsMacOS)) {
    Write-Host -ForegroundColor Red "This powershell file is designed to be used on windows. Please check your operating system."
    Exit 1;
}

$OhMyPoshTheme = "~/.poshthemes/default.omp.json"

function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (Test-CommandExists winget) {
    function Install-WingetPackage {
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

if (Test-Path "$Env:ProgramFiles\Docker\Docker\DockerCli.exe") {
    function Switch-DockerDeamon() {
        & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon
    }
}

if (Test-CommandExists docker) {
    function Get-DockerMode() {
        $dockerCommand = docker info 2>$null | Select-String OSType
        if ($dockerCommand -and $dockerCommand.Line -match 'OSType:\s*(\S+)') {
            $ostype = $Matches[1]
            Write-Host -ForegroundColor Green "OS: $ostype"
        } else {
            Write-Host -ForegroundColor Red "OS Not Found"
        }
    }

    function Get-DockerModeValue() {
        $dockerCommand = docker info 2>$null | Select-String OSType
        if ($dockerCommand -and $dockerCommand.Line -match 'OSType:\s*(\S+)') {
            $ostype = $Matches[1]
            return $ostype
        }
    }
}

function Create-truckersmp-symboliclink {
    $atsModsPath = "$env:APPDATA\TruckersMP\installation\data\ats\mods"
    $atsTargetPath = "$env:USERPROFILE\Documents\American Truck Simulator\mod"
    
    $ets2ModsPath = "$env:APPDATA\TruckersMP\installation\data\ets2\mods"
    $ets2TargetPath = "$env:USERPROFILE\Documents\Euro Truck Simulator 2\mod"
    
    $sharedModsPath = "$env:APPDATA\TruckersMP\installation\data\shared\mods"
    
    New-Item -ItemType Directory -Force -Path $atsTargetPath
    
    Get-ChildItem -Path $atsModsPath -Filter *.mp | ForEach-Object {
        $linkPath = Join-Path $atsTargetPath "$($_.BaseName).scs"
        New-Item -ItemType SymbolicLink -Path $linkPath -Target $_.FullName
    }
    
    New-Item -ItemType Directory -Force -Path $ets2TargetPath
    
    Get-ChildItem -Path $ets2ModsPath -Filter *.mp | ForEach-Object {
        $linkPath = Join-Path $ets2TargetPath "$($_.BaseName).scs"
        New-Item -ItemType SymbolicLink -Path $linkPath -Target $_.FullName
    }
    
    
    Get-ChildItem -Path $sharedModsPath -Filter *.mp | ForEach-Object {
        $atsDestinationPath = Join-Path $atsTargetPath "$($_.BaseName).scs"
        New-Item -ItemType SymbolicLink -Path $atsDestinationPath -Target $_.FullName
        $ets2DestinationPath = Join-Path $ets2TargetPath "$($_.BaseName).scs"
        New-Item -ItemType SymbolicLink -Path $ets2DestinationPath -Target $_.FullName
    }   
}

if ((Test-Path $OhMyPoshTheme) -And (Test-CommandExists oh-my-posh)) {
    oh-my-posh init pwsh --config $OhMyPoshTheme | Invoke-Expression 

function Update-OhMyPoshTheme() { 
    if (Test-Path "$env:USERPROFILE\.poshthemes\default.omp.json") { Remove-Item "$env:USERPROFILE\.poshthemes\default.omp.json" }
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.poshthemes/default.omp.json" -OutFile "$env:USERPROFILE\.poshthemes\default.omp.json"
}

}

function Update-Alias() {
    if (Test-Path "$env:USERPROFILE\.alias.ps1") { Remove-Item "$env:USERPROFILE\.alias.ps1" }
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/windows/data/home/.alias.ps1" -OutFile "$env:USERPROFILE\.alias.ps1"
    if (Test-Path "$env:USERPROFILE\.alias") { Remove-Item "$env:USERPROFILE\.alias" }
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/windows/data/home/.alias" -OutFile "$env:USERPROFILE\.alias"
}  
