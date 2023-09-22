if (-Not $isLinux) {
    Write-Error "For Linux only, are you sure you added the correct alias file?"
    Exit 1
}

if ([string]::IsNullOrEmpty($env:LC_ALL)) {
    $env:LANG = "C.utf8"
    $env:LC_ALL = $env:LANG
}
$OhMyPoshTheme = "~/.poshthemes/default.omp.json"

if (Test-Path "$env:HOME/bin") {
    $env:PATH += ":$env:HOME/bin"
}

if (Test-Path "$env:HOME/development") {
    $env:PATH += ":$env:HOME/development"
}

if (Test-Path "$env:HOME/.local/bin") {
    $env:PATH += ":$env:HOME/.local/bin"
}

if (Test-Path "$env:HOME/bin/docker") {
    $env:DOCKER_HOST = "unix:///run/user/1000/docker.sock"
}

Function checkwsl {
    $unameout = $(uname -r | tr '[:upper:]' '[:lower:]');
    if ( (( $unameout.ToLower() -like "*microsoft*" ) -or ( $unameout.ToLower() -like "*wsl*" )) -or 
    (Test-Path /proc/sys/fs/binfmt_misc/WSLInterop) -or 
    ( $env:WSL_DISTRO_NAME ) -or 
    (((cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d":") -ne "0xffffffff") -and $env:WSL_DISTRO_NAME )) {

        return $True
    }
    else {
        return $False
    }
}    
Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
     
    $ErrorActionPreference = "stop"
    try { if (Get-Command $command) { return $True } }
     
    Catch { return $False }
     
    Finally { $ErrorActionPreference = $oldPreference }
}
  
if (Test-Path "/home/linuxbrew/.linuxbrew/bin/brew") {
    Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '$(/home/linuxbrew/.linuxbrew/bin/brew shellenv) | Invoke-Expression'
  
    function brewInstall {
        brew install $Args 2>$null
    }
    
    function brewInstallCask {
        brew install --cask $Args 2>$null
    }

}

if ($env:TERM -ne "linux") {
    if ((Test-Path $OhMyPoshTheme) -And (Test-CommandExists oh-my-posh)) {
        oh-my-posh init pwsh --config $OhMyPoshTheme | Invoke-Expression 
    }
}

#IF NOT WSL
if (-NOT $(checkwsl) ) {
  
    if (Test-CommandExists podman) {
        function podmanRun {
            Write-Host "podman system service --time=0 tcp:0.0.0.0:12979"
            podman system service --time=0 tcp:0.0.0.0:12979
        }
  
    }
  
    if (Test-CommandExists ancs4linux-ctl) {
        function ios_pair {
            $iosAddress = $(ancs4linux-ctl get-all-hci | jq -r '.[0]')
            Write-Host "Connect to $(hostname) from your phone."
            ancs4linux-ctl enable-advertising --hci-address $iosAddress --name $(hostname)   
        }
    }
  
}
  
function rootMode {
    if ($Args.Length -eq 0) {
        Write-Host "Usage: rootMode <command>"
        exit 1
    } else {
        $XDG_DE = $env:XDG_CURRENT_DESKTOP.ToLower()
        if ($XDG_DE -eq "kde") {
            Start-Process -Wait -FilePath "pkexec" -ArgumentList @(
                "env",
                "DISPLAY=$env:DISPLAY",
                "XAUTHORITY=$env:XAUTHORITY",
                "KDE_SESSION_VERSION=5",
                "KDE_FULL_SESSION=true",
                $Args
            )
        } else {
            Start-Process -Wait -FilePath "pkexec" -ArgumentList @(
                "env",
                "DISPLAY=$env:DISPLAY",
                "XAUTHORITY=$env:XAUTHORITY",
                $Args
            )
        }
    }
}
  
function englishRun {
    if ($Args.Length -eq 0) {
        Write-Host "Usage: englishRun <command>"
        exit 1
    } else {
        $env:LC_ALL = "C.utf8"
        $env:LANG = $env:LC_ALL
        & $Args
    }
}

function aliasUpdate {
    [String]$xArgs = 'rm -r ~/.alias && wget "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.alias" -O ~/.alias && rm -r ~/.alias.ps1 && wget "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.alias.ps1" -O ~/.alias.ps1 && rm -r ~/.alias.fish && wget "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/home/.alias.fish" -O ~/.alias.fish'
    Invoke-Expression $xArgs
}

if ((Test-Path $OhMyPoshTheme) -And (Test-CommandExists oh-my-posh)) {
    function OhMyPoshThemeUpdate {
        $themeFile = "$HOME/.poshthemes/default.omp.json"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/dotfiles/default.omp.json" -OutFile $themeFile
    }
}
