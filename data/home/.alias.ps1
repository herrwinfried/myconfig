if (-Not $ismacos ) {
    Write-Error "For macOS only, are you sure you added the correct alias file?"
    Exit 1
}

$env:PATH += ":/Users/winfried/development/flutter/bin:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

Function unkey {
    security unlock-keychain
}
Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
   
    $ErrorActionPreference = "stop"
    try {if(Get-Command $command){return $True}}
   
    Catch {return $False}
   
    Finally {$ErrorActionPreference=$oldPreference}
   }

$OhMyPoshTheme="~/.poshthemes/default.omp.json"

if (Test-Path "/usr/local/bin/brew") {
  Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '$(/usr/local/bin/brew shellenv) | Invoke-Expression'

  function brewInstall {
    brew install $Args 2>$null
}

function brewInstallCask {
    brew install --cask $Args 2>$null
}

}

if ((Test-Path $OhMyPoshTheme) -And (Test-CommandExists oh-my-posh)) {
    oh-my-posh init pwsh --config $OhMyPoshTheme | Invoke-Expression 
}

function aliasUpdate {
    [String]$xArgs="rm -r ~/.alias && wget https://raw.githubusercontent.com/herrwinfried/myconfig/macos/data/home/.alias -O ~/.alias && rm -r ~/.alias.ps1 && wget https://raw.githubusercontent.com/herrwinfried/myconfig/macos/data/home/.alias.ps1 -O ~/.alias.ps1"
    Invoke-Expression $xArgs
  }