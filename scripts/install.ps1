param(
    [Alias("h", "?")]
    [switch]$Help,
    [Alias("u", "user")]
    [switch]$Client,
    [Alias("s")]
    [switch]$Server,
    [Alias("vm")]
    [switch]$VirtualMachine,
    [Alias("ps")]
    [switch]$Presetup,
    [Alias("cc")]
    [switch]$OnlyConfig,
    [Alias("c")]
    [switch]$Config
)

$ScriptFolder = $PSScriptRoot
$ScriptFolder1 = "$PSScriptRoot\..\"
$Host.UI.RawUI.WindowTitle = "HerrWinfried - MyConfig Install"

if (-not (Test-Path -Path "$ScriptFolder/lang/en.ps1")) {
    Write-Host -ForegroundColor Red "language file missing!!!"
    exit 1
} else {
    . $ScriptFolder/lang/en.ps1
}

. $ScriptFolder/variable.ps1

CheckWindows

function basic_if_warning {
    Write-Warning $LANG_BOTH_WARNING_ARG
    Write-Host "[1] $LANG_BOTH_WARNING_ARG_YES "
    Write-Host "[2] $LANG_BOTH_WARNING_ARG_NO "
    $IFREAD = Read-Host
    if ($IFREAD -ne 1 -and $IFREAD -ne 2) {
        red_message $LANG_BOTH_WARNING_ARG_OPTION_INVALID
        basic_if_warning
    }
    elseif ($IFREAD -eq 2) {
        exit 1
    }
}

function presetup_message {
    Write-Host -ForegroundColor Yellow $LANG_PRESETUP_MESSAGE_1
    Write-Host -ForegroundColor Cyan $LANG_PRESETUP_MESSAGE_2
    Exit 1;
}

if (($Client -eq 0) -and ($Server -eq 0) -and ($VirtualMachine -eq 0)) {
    red_message $LANG_NO_ARGUMENTS
    Exit 1;
} else {

    if ($Client -eq 1) {
        if (($Server -eq 1) -or ($VirtualMachine -eq 1)) {
            basic_if_warning
        }
    } elseif (($Server -eq 1) -and ($VirtualMachine -eq 1)) {
        basic_if_warning
    }

}

if ($OSNAME -ilike "microsoft windows 11*") {
    $VersionFolder="11"
} else {
    red_message $LANG_NOT_SUPPORT_VERSION_LIST
    Exit 1;
}

if ($Client) {
    if (-not (CHECK_SHELL_DIRECTORY "home" $VersionFolder)) {
        Write-Host "NOT SUPPORT [home]"
        exit 1
    } else {
        if ($Presetup) {
            EXE_SHELL "$ScriptFolder/home/$VersionFolder/Presetup"
            presetup_message
        }
        if ($OnlyConfig) {
            EXE_SHELL "$ScriptFolder/home/$VersionFolder/config"
            exit 1
        }
        EXE_SHELL "$ScriptFolder/home/$VersionFolder/FirstProcess"
        EXE_SHELL "$ScriptFolder/home/$VersionFolder/Package"
        if ($Config) {
            EXE_SHELL "$ScriptFolder/home/$VersionFolder/config"
        }
        EXE_SHELL "$ScriptFolder/home/$VersionFolder/RecentProcess"
    }
}

if ($Server) {
    if (-not (CHECK_SHELL_DIRECTORY "server" $VersionFolder)) {
        Write-Host "NOT SUPPORT [server]"
        exit 1
    } else {
        if ($Presetup) {
            EXE_SHELL "$ScriptFolder/server/$VersionFolder/Presetup"
            presetup_message
        }
        if ($OnlyConfig) {
            EXE_SHELL "$ScriptFolder/server/$VersionFolder/config"
            exit 1
        }
        EXE_SHELL "$ScriptFolder/server/$VersionFolder/FirstProcess"
        EXE_SHELL "$ScriptFolder/server/$VersionFolder/Package"
        if ($Config) {
            EXE_SHELL "$ScriptFolder/server/$VersionFolder/config"
        }
        EXE_SHELL "$ScriptFolder/server/$VersionFolder/RecentProcess"
    }
}

if ($VirtualMachine) {
    if (-not (CHECK_SHELL_DIRECTORY "vm" $VersionFolder)) {
        Write-Host "NOT SUPPORT [VirtualMachine]"
        exit 1
    } else {
        if ($Presetup) {
            EXE_SHELL "$ScriptFolder/vm/$VersionFolder/Presetup"
            presetup_message
        }
        if ($OnlyConfig) {
            EXE_SHELL "$ScriptFolder/vm/$VersionFolder/config"
            exit 1
        }
        EXE_SHELL "$ScriptFolder/vm/$VersionFolder/FirstProcess"
        EXE_SHELL "$ScriptFolder/vm/$VersionFolder/Package"
        if ($Config) {
            EXE_SHELL "$ScriptFolder/vm/$VersionFolder/config"
        }
        EXE_SHELL "$ScriptFolder/vm/$VersionFolder/RecentProcess"
    }
}
