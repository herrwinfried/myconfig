$COLORS = @{
    Red      = "$([char]27)[1;31m"
    Green    = "$([char]27)[1;32m"
    Yellow   = "$([char]27)[1;33m"
    Blue     = "$([char]27)[1;34m"
    Cyan     = "$([char]27)[1;36m"
    NoColor  = "$([char]27)[0m"
}

if ($IsLinux -ne $true) {
    Write-Host "${($COLORS.Red)}Error: This script is designed for Linux.${($COLORS.NoColor)}"
    exit 1
}

$env:DOTNET_CLI_TELEMETRY_OPTOUT = "1"

if (-not $env:LC_ALL -and -not $env:LANG) {
    $env:LANG = "C.utf8"
    $env:LC_ALL = $env:LANG
} elseif (-not $env:LANG) {
    $env:LANG = $env:LC_ALL
} elseif (-not $env:LC_ALL) {
    $env:LC_ALL = $env:LANG
}

$POSH_THEME = "$env:HOME/.poshthemes/default.omp.json"

$env:HOST_LC_ALL = $env:LC_ALL
$env:WINEDLLPATH = "$($env:WINEDLLPATH):/opt/discord-rpc/bin64:/opt/discord-rpc/bin32"

if (Test-Path "$env:XDG_RUNTIME_DIR/docker.sock") {
    $env:DOCKER_HOST = "unix://$env:XDG_RUNTIME_DIR/docker.sock"
} elseif (Test-Path "/var/run/docker.sock") {
    $env:DOCKER_HOST = "unix:///var/run/docker.sock"
}

function rootless_docker {
	$env:DOCKER_HOST = "unix:///var/run/docker.sock"
}

function root_docker {
	$env:DOCKER_HOST = "unix://${XDG_RUNTIME_DIR}/docker.sock"
}

if (Test-Path "/home/linuxbrew/.linuxbrew/bin/brew") {
$(/home/linuxbrew/.linuxbrew/bin/brew shellenv pwsh) | Invoke-Expression
}

function Test-WSL {
    $uname = (uname -r).ToLower()
    if ($uname -like "*microsoft*" -or $uname -like "*wsl*" -or (Test-Path "/proc/sys/fs/binfmt_misc/WSLInterop") -or $env:WSL_DISTRO_NAME) {
        return $true
    }
    return $false
}

function Update-AliasFiles {
    Write-Host "${($COLORS.Blue)}Updating aliases...${($COLORS.NoColor)}"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/user/.alias.ps1" -OutFile "$env:HOME/.alias.ps1" -Quiet
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/user/.alias" -OutFile "$env:HOME/.alias" -Quiet
    Write-Host "${($COLORS.Green)}Aliases updated.${($COLORS.NoColor)}"
}

if (Get-Command zypper -ErrorAction SilentlyContinue) {
    function Get-ZyppHistory {
        sudo bash -c 'cut -d "|" -f 1-4 -s --output-delimiter " | " /var/log/zypp/history | grep -v " radd "'
    }
}

if ((Get-Command oh-my-posh -ErrorAction SilentlyContinue) -and (Test-Path $POSH_THEME)) {
    if ($env:TERM -ne "linux") {
        oh-my-posh init pwsh --config $POSH_THEME | Invoke-Expression
    }

    function Update-OhMyPoshTheme {
        Write-Host "${($COLORS.Blue)}Updating Oh My Posh theme...${($COLORS.NoColor)}"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/user/.poshthemes/default.omp.json" -OutFile $POSH_THEME -Quiet
        Write-Host "${($COLORS.Green)}Theme updated.${($COLORS.NoColor)}"
    }
}