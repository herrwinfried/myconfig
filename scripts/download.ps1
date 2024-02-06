$Host.UI.RawUI.WindowTitle = "HerrWinfried - MyConfig [DOWNLOAD]"

if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct Script?"
   Start-Sleep -Seconds 3
    Exit 1
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

Set-Location $HOME

if (Test-Path -Path $HOME\MyConfig.old) {
    Remove-Item $HOME\MyConfig.old -Recurse -Force
}

if (Test-Path -Path $HOME\MyConfig) {
    Move-Item $HOME\MyConfig $HOME\MyConfig.old
}

function Start1 {
    $MainLine="windows"
    git clone https://github.com/herrwinfried/myconfig/ -b $MainLine
}

if (Test-CommandExists git) { 
Start1
} else {
WingetInstall -Interactive 1 -Id Git.Git
Start1
}


