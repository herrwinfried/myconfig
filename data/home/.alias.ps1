if (-Not $isLinux) {
    Write-Error "For Linux only, are you sure you added the correct alias file?"
    Exit 1
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
    if (-Not $Args.Count -eq 0) {
        $XDG_DE = $($XDG_CURRENT_DESKTOP | tr '[:upper:]' '[:lower:]')
        [String]$xArgs = $(Write-Output $Args) 
        if ($XDG_DE -eq "kde") {
            sudo pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true $xArgs
        }
        else {
            sudo pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY $xArgs
        }
    }
    else {
        Write-Error "You didn't write anything to run."
    }
}
  
function englishRun {
    if (-Not $Args.Count -eq 0) {
        [String]$xArgs = $(Write-Output $Args)
        $env:LC_ALL = 'C' 
        $env:LANG = $env:LC_ALL 
        Invoke-Expression $xArgs
    }
    else {
        Write-Error "You didn't write anything to run."
    }
}

function aliasUpdate {
    [String]$xArgs = 'rm -r ~/.alias && wget "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias" -O ~/.alias && rm -r ~/.alias.ps1 && wget "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias.ps1" -O ~/.alias.ps1 && rm -r ~/.alias.fish && wget "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias.fish" -O ~/.alias.fish'
    Invoke-Expression $xArgs
}

if ((Test-Path $OhMyPoshTheme) -And (Test-CommandExists oh-my-posh)) {
    function OhMyPoshThemeUpdate {
        $themeFile = "$HOME/.poshthemes/default.omp.json"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/default.omp.json" -OutFile $themeFile
    }
}
