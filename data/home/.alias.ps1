if (-Not $isLinux) {
    Write-Error "For Linux only, are you sure you added the correct alias file?"
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
  
  $OhMyPoshTheme="~/.poshthemes/default.omp.json"
  
  # OpenSUSE CNF
  if (Test-Path "/etc/command_not_found") {
      . /etc/command_not_found
  }
  
  
  if ((Test-Path $OhMyPoshTheme) -And (Test-CommandExists oh-my-posh)) {
      oh-my-posh init pwsh --config $OhMyPoshTheme | Invoke-Expression 
  }
  
  #IF NOT WSL
  if ((cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d":") -ne "0xffffffff") {
  
  function podmanRun {
      Write-Host "podman system service --time=0 tcp:0.0.0.0:12979"
      podman system service --time=0 tcp:0.0.0.0:12979
  }
  
  if (Test-CommandExists ancs4linux-ctl) {
  function ios_pair {
      $iosAddress=$(ancs4linux-ctl get-all-hci | jq -r '.[0]')
      Write-Host "Connect to $(hostname) from your phone."
      ancs4linux-ctl enable-advertising --hci-address $iosAddress --name $(hostname)   
  }
  }
  
  }
  
  function rootMode {
  if (-Not $Args.Count -eq 0) {
  $XDG_DE=$($XDG_CURRENT_DESKTOP | tr '[:upper:]' '[:lower:]')
  [String]$xArgs=$(Write-Output $Args) 
  if ($XDG_DE -eq "kde") {
  sudo pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true $xArgs
  } else {
  sudo pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY $xArgs
  }
  } else {
      Write-Error "You didn't write anything to run."
  }
  }
  
  function englishRun {
      if (-Not $Args.Count -eq 0) {
  [String]$xArgs=$(Write-Output $Args)
  $env:LC_ALL='C' 
  $env:LANG=$env:LC_ALL 
  Invoke-Expression $xArgs
  }  else {
      Write-Error "You didn't write anything to run."
  }
  }
