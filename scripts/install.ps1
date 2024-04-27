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
    [switch]$Config,
    [Alias("l")]
    [string]$Lang
)

$GetScriptDir = $PSScriptRoot
$GetDataDir = "$PSScriptRoot\..\data"
[string]$GetScriptName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)

# Language support
if (-Not ($Lang)) { $Lang = $PSUICulture }
$GetLanguageFile = "$PSScriptRoot/lang/$Lang/$GetScriptName.psd1"

if (-Not (Test-Path "$PSScriptRoot/lang/en-US/$GetScriptName.psd1")) {
        Write-Error "There is no language file. Script exited."
        Exit 1
} elseif (Test-Path $GetLanguageFile) {
    $Language = Import-LocalizedData -BaseDirectory "$PSScriptRoot/lang" -FileName $($GetScriptName).psd1 -UICulture $Lang
} elseif (-Not (Test-Path $GetLanguageFile)) {
    $Language = Import-LocalizedData -BaseDirectory "$PSScriptRoot/lang" -FileName $($GetScriptName).psd1 -UICulture "en-US"
}
# language support complete

$Host.UI.RawUI.WindowTitle = "MyConfig - $($Language.ScriptTitle)"

if (-Not (Test-Path "$GetScriptDir/config.ps1")) {
    Write-Error $Language.NotFoundConfig
    Exit 1
} else {
    . $GetScriptDir/config.ps1
}

if (-Not (Test-Path "$GetScriptDir/function.psm1")) {
    Write-Error $Language.NotFoundFunction
    Exit 1
} else {
    $GetLanguageModuleFile = "$PSScriptRoot/lang/$Lang/function.psd1"

if (-Not (Test-Path "$PSScriptRoot/lang/en-US/function.psd1")) {
        Write-Error "There is no language file. Module exited."
        Exit 1
} elseif (Test-Path $GetLanguageModuleFile) {
    $LanguageModule = Import-LocalizedData -BaseDirectory "$PSScriptRoot/lang" -FileName function.psd1 -UICulture $Lang
} elseif (-Not (Test-Path $GetLanguageModuleFile)) {
    $LanguageModule = Import-LocalizedData -BaseDirectory "$PSScriptRoot/lang" -FileName function.psd1 -UICulture "en-US"
}
    Import-Module $GetScriptDir/function.psm1
}

Test-isWindows

if (($Client -eq 0) -and ($Server -eq 0) -and ($VirtualMachine -eq 0)) {
    Write-Host-Red "$($Language.NoArgument)"
    Exit 1;
} else {

    if ($Client -eq 1) {
        if (($Server -eq 1) -or ($VirtualMachine -eq 1)) {
            BothOptionArguments
        }
    } elseif (($Server -eq 1) -and ($VirtualMachine -eq 1)) {
        BothOptionArguments
    }

}

if ($config.GetOSName -ilike "microsoft windows 11*") {
    $OSDirectoryPath="11"
} else {
    Write-Host-Red "$($Language.NotSupportOS)"
    Exit 1;
}

if ($Client) {
   Invoke-InstallScript -Type home -OSDirPath $OSDirectoryPath
}

if ($Server) {
    Invoke-InstallScript -Type server -OSDirPath $OSDirectoryPath
}

if ($VirtualMachine) {
    Invoke-InstallScript -Type vm -OSDirPath $OSDirectoryPath
}