if ((uname -s) -ne "Linux") {
  Write-Host "$(tput setaf 1)This powershell file is designed to be used on linux. Please check your operating system.$(tput setaf 7)"
  exit 1
}

if (-not $env:LC_ALL -and -not $env:LANG) {
  $env:LANG = "C.utf8"
  $env:LC_ALL = $env:LANG
}

### Proton/Wine
$env:HOST_LC_ALL = $env:LC_ALL
$env:WINEDLLPATH = "$env:WINEDLLPATH:/opt/discord-rpc/bin64:/opt/discord-rpc/bin32"
###########################

function Test-CommandExists {
  Param ($command)
  $oldPreference = $ErrorActionPreference
   
  $ErrorActionPreference = "stop"
  try { if (Get-Command $command) { return $True } }
   
  Catch { return $False }
   
  Finally { $ErrorActionPreference = $oldPreference }
}

if (Test-CommandExists warp-cli) {
  warp-cli generate-completions powershell | Set-Content -Path "$env:HOME/.config/powershell/completions/warp-cli.ps1"
}

New-Item -ItemType Directory -Path "$env:HOME/.config/powershell/completions" -Force | Out-Null
Get-ChildItem -Path "$env:HOME/.config/powershell/completions" -Filter '*.ps1' | ForEach-Object {
    . $_.FullName
}

$env:DOTNET_CLI_TELEMETRY_OPTOUT = "1"
$OhMyPoshTheme="$env:HOME/.poshthemes/default.omp.json"

if (Test-CommandExists zypper) {
  function Get-ZyppHistory {
    $command = 'cut -d "|" -f 1-4 -s --output-delimiter " | " /var/log/zypp/history | grep -v " radd "'
    Start-Process sudo -ArgumentList "bash", "-c", $command -Wait
}
}

if (Test-Path "$env:XDG_RUNTIME_DIR/docker.sock" -PathType Leaf) {
  $env:DOCKER_HOST = "unix://$env:XDG_RUNTIME_DIR/docker.sock"
} else {
    $env:DOCKER_HOST = "unix:///var/run/docker.sock"
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

if (Test-Path "$env:HOMEBREW_PREFIX") {
$("$env:HOMEBREW_PREFIX/bin/brew shellenv") | Invoke-Expression | Out-Null
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