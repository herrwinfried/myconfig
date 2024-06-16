if ((uname -s) -ne "Linux") {
  Write-Host "$(tput setaf 1)This powershell file is designed to be used on linux. Please check your operating system.$(tput setaf 7)"
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

$OhMyPoshTheme="$env:HOME/.poshthemes/default.omp.json"

if (Test-CommandExists zypper) {
function Get-ZyppHistory  {
  Invoke-Expression  'cut -d "|" -f 1-4 -s --output-delimiter " | " /var/log/zypp/history | grep -v " radd "'
}
}

if ((rpm -q "docker") -ilike '*docker*') {
  $env:DOCKER_HOST = "unix:///run/user/1000/docker.sock"
}
function Test-WSL {
    $unameout = $(uname -r)
    if ($unameout -ilike "*microsoft*" -or $unameout -ilike "*wsl*" -or (Test-Path /proc/sys/fs/binfmt_misc/WSLInterop) -or $env:WSL_DISTRO_NAME -or ((Get-Content /proc/cpuinfo | Select-String -Pattern "microcode" -SimpleMatch -First 1).ToString().Split(":")[1].Trim() -eq "0xffffffff") -and $env:WSL_DISTRO_NAME) {
        return $true
    }
    else {
        return $false   
    }

}

if (((Test-Path "/windir/c") -or (Test-Path "/mnt/c")) -and (Test-WSL)) {
    function wsl_c {
        if (Test-Path "/windir/c") {
            Set-Location -Path "/windir/c"
        } elseif (Test-Path "/mnt/c") {
            Set-Location -Path "/mnt/c"
        }
    }
}

if (Test-Path "/home/linuxbrew/.linuxbrew/bin/brew") {
  Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '$(/home/linuxbrew/.linuxbrew/bin/brew shellenv) | Invoke-Expression'
}

if ((Test-Path $OhMyPoshTheme) -And (Test-CommandExists oh-my-posh)) {
  if ($env:TERM -ne "linux") {
      oh-my-posh init pwsh --config $OhMyPoshTheme | Invoke-Expression 
  }
  function Update-OhMyPoshTheme {
    if (Test-Path "$env:HOME\.poshthemes\default.omp.json") { Remove-Item "$env:HOME\.poshthemes\default.omp.json" }
      Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.poshthemes/default.omp.json" -OutFile "$env:HOME\.poshthemes\default.omp.json"
    }
}

function Update-Alias {
    if (Test-Path "$env:HOME\.alias.ps1") { Remove-Item "$env:HOME\.alias.ps1" }
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias.ps1" -OutFile "$env:HOME\.alias.ps1"
    if (Test-Path "$env:HOME\.alias") { Remove-Item "$env:HOME\.alias" }
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias" -OutFile "$env:HOME\.alias"
 }
