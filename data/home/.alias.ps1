if ($(uname -s) -ne "Linux") {
    Write-Host -ForegroundColor Red "For Linux only, are you sure you added the correct alias file?"
    exit 1
}

if (-not $env:LC_ALL -and -not $env:LANG) {
    $env:LANG = "C.utf8"
    $env:LC_ALL = $env:LANG
}

Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
     
    $ErrorActionPreference = "stop"
    try { if (Get-Command $command) { return $True } }
     
    Catch { return $False }
     
    Finally { $ErrorActionPreference = $oldPreference }
}

$OhMyPoshTheme = "$HOME\.poshthemes\default.omp.json"

$env:PATH += ";$HOME\bin;$HOME\development;$HOME\.local\bin"

if (Test-Path "/home/linuxbrew/.linuxbrew/bin/brew") {
    Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '$(/home/linuxbrew/.linuxbrew/bin/brew shellenv) | Invoke-Expression'
}

if ((Test-Path "$HOME/bin/docker") -or (Test-Path "/usr/bin/docker")) {
    $env:DOCKER_HOST = "unix:///run/user/1000/docker.sock"
}

if ((Test-Path $OhMyPoshTheme) -And (Test-CommandExists oh-my-posh)) {
    if ($env:TERM -ne "linux") {
        oh-my-posh init pwsh --config $OhMyPoshTheme | Invoke-Expression
    }
}

function Update-OhMyPoshTheme {
    $themeFile = "$HOME\.poshthemes\default.omp.json"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.poshthemes/default.omp.json" -OutFile $themeFile
}

function englishRun {
    if ($args.Length -eq 0) {
        Write-Host "Usage: $($MyInvocation.MyCommand.Name) <command>"
        exit 1
    } else {
        $env:LC_ALL = "C.utf8"
        $env:LANG = $env:LC_ALL
        & $args
    }
}

function Update-Alias {
    Remove-Item "$HOME\.alias" -ErrorAction SilentlyContinue
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias" -OutFile "$HOME\.alias"
    Remove-Item "$HOME\.alias.ps1" -ErrorAction SilentlyContinue
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias.ps1" -OutFile "$HOME\.alias.ps1"
    Remove-Item "$HOME\.alias.fish" -ErrorAction SilentlyContinue
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias.fish" -OutFile "$HOME\.alias.fish"
}

function Check-WSL {
    $unameout = $(uname -r | ForEach-Object { $_.ToLower() })
    if ($unameout -like "*microsoft*" -or $unameout -like "*wsl*" -or (Test-Path /proc/sys/fs/binfmt_misc/WSLInterop) -or $env:WSL_DISTRO_NAME -or ((Get-Content /proc/cpuinfo | Select-String -Pattern "microcode" -First 1).Line -match "0xffffffff" -and $env:WSL_DISTRO_NAME)) {
        return $true
    } else {
        return $false
    }
}

if (((Test-Path "/windir/c") -or (Test-Path "/mnt/c")) -and (Check-WSL)) {
    function wsl_c {
        if (Test-Path "/windir/c") {
            Set-Location -Path "/windir/c"
        } elseif (Test-Path "/mnt/c") {
            Set-Location -Path "/mnt/c"
        }
    }
}

Set-Alias aliasUpdate Update-Alias
Set-Alias OhMyPoshThemeUpdate Update-OhMyPoshTheme
Set-Alias checkwsl Check-WSL