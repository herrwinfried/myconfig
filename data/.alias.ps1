if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct alias file?"
    Exit 1
}

Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
   
    $ErrorActionPreference = "stop"
    try {if(Get-Command $command){return $True}}
   
    Catch {return $False}
   
    Finally {$ErrorActionPreference=$oldPreference}
   }

#ONLY POWERSHELL CORE (7+.X.X)
if ( ((Get-Host).Version).Major -ne "6" ) { 

$OhMyPoshTheme="$HOME/.poshthemes/default.omp.json"  
if ((Test-Path $OhMyPoshTheme) -And (Test-CommandExists oh-my-posh)) {
    oh-my-posh init pwsh --config $OhMyPoshTheme | Invoke-Expression 
}

}

function winget_yes{
    param (
        [Parameter (Mandatory = $true)] [String]$Id
        )
$runnnx = "winget.exe install --id $Id --accept-package-agreements --accept-source-agreements"
        Invoke-Expression $runnnx
    }
