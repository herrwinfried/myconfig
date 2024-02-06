param(
    [Alias("h")]
    [switch]$Help,
    [Alias("u", "home")]
    [switch]$User,
    [Alias("ps")]
    [switch]$Presetup,
    [Alias("s")]
    [switch]$Server,
    [Alias("vm")]
    [switch]$VirtualMachine,
    [Alias("c")]
    [switch]$Config,
    [Alias("cc")]
    [switch]$OnlyConfig
)
$Host.UI.RawUI.WindowTitle = "HerrWinfried - MyConfig Installer"
$ScriptFolder = $PSScriptRoot
. $ScriptFolder/VARIBLES.ps1

if ($Help) {
    exit 1;
} 
if (($Config) -and ($OnlyConfig)) {
$Config = $false
} 

if (($User -eq $false) -and ($Presetup -eq $false) -and ($Server -eq $false) -and ($VirtualMachine -eq $false) -and ($Config -eq $false) -and ($OnlyConfig -eq $false)) {
    Write-Host -ForegroundColor Yellow "You selected no arguments... Exiting the script..."
    exit 1
} elseif ((($User -eq $false) -and ($Server -eq $false) -and ($VirtualMachine -eq $false)) -and (($Config) -or ($Presetup) -or ($OnlyConfig))) {
    Write-Warning "missing parameter. I guess you didn't choose the main parameters. (example: -user, -server, -vm)"
    exit 1;
}

function exe_script {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$script_folder
    )
    Get-ChildItem $script_folder -Filter *.ps1 | ForEach-Object {
        Write-Host -ForegroundColor Cyan $_.FullName
        . $_.FullName
    }
}

function check_scriptfolder {
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$folder,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$os
    )
        if (Test-Path -Path "$ScriptFolder/$folder/$os") {
            return $true
        } else {
            return $false
        }
}
function basic_if_warning {
    Write-Host "Do you want to continue with both server and home arguments open?"
    Write-Host "[1] Yes"
    Write-Host "[2] No and exit"
    $IFREAD = Read-Host
    if ($IFREAD -ne 1 -and $IFREAD -ne 2) {
        Write-Host "You entered an unregistered number..."
        basic_if_warning
    }
    elseif ($IFREAD -eq 2) {
        exit 1
    }
}

if (($User) -and ($Server)) {
    basic_if_warning
}

if ($OSNAME -ilike "microsoft windows 11*") {
$OSFolder="11"
    if ($User) {
        if (-Not (check_scriptfolder "home" "11")) {
            Write-Host -ForegroundColor Red "NOT SUPPORT [home]"
            exit 1;
        }

        if ($Presetup) {
            exe_script "$ScriptFolder/home/$OSFolder/Presetup"
            exit 1
        }
        if ($OnlyConfig) {
            exe_script "$ScriptFolder/home/$OSFolder/Config"
            exit 1
        }
        exe_script "$ScriptFolder/home/$OSFolder/FirstProcess"
        exe_script "$ScriptFolder/home/$OSFolder/FirstPackage"
        exe_script "$ScriptFolder/home/$OSFolder/Package"
        exe_script "$ScriptFolder/home/$OSFolder/RecentProcess"
        if ($Config) {
        exe_script "$ScriptFolder/home/$OSFolder/Config"
        }

    }
    if ($VirtualMachine) {
        if (-Not (check_scriptfolder "vm" "11")) {
            Write-Host -ForegroundColor Red "NOT SUPPORT [vm]"
            exit 1;
        }

        if ($Presetup) {
            exe_script "$ScriptFolder/vm/$OSFolder/Presetup"
            exit 1
        }
        if ($OnlyConfig) {
            exe_script "$ScriptFolder/vm/$OSFolder/Config"
            exit 1
        }
        exe_script "$ScriptFolder/vm/$OSFolder/FirstProcess"
        exe_script "$ScriptFolder/vm/$OSFolder/FirstPackage"
        exe_script "$ScriptFolder/vm/$OSFolder/Package"
        exe_script "$ScriptFolder/vm/$OSFolder/RecentProcess"
        if ($Config) {
        exe_script "$ScriptFolder/vm/$OSFolder/Config"
        }

    }
    if ($server) {
        if (-Not (check_scriptfolder "server" "11")) {
            Write-Host -ForegroundColor Red "NOT SUPPORT [server]"
            exit 1;
        }

        if ($Presetup) {
            exe_script "$ScriptFolder/server/$OSFolder/Presetup"
            exit 1
        }
        if ($OnlyConfig) {
            exe_script "$ScriptFolder/server/$OSFolder/Config"
            exit 1
        }
        exe_script "$ScriptFolder/server/$OSFolder/FirstProcess"
        exe_script "$ScriptFolder/server/$OSFolder/FirstPackage"
        exe_script "$ScriptFolder/server/$OSFolder/Package"
        exe_script "$ScriptFolder/server/$OSFolder/RecentProcess"
        if ($Config) {
        exe_script "$ScriptFolder/server/$OSFolder/Config"
        }

    }

} else {
Write-Host -ForegroundColor Red "I cannot support the operating system you are currently trying."
}