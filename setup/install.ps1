param(
    [Alias("h", "?")]
    [switch]$Help,
    [Alias("ps")]
    [switch]$Presetup = $False,
    [Alias("cc")]
    [switch]$OnlyConfig = $False,
    [Alias("c")]
    [switch]$Config = $False,
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
}
elseif (Test-Path $GetLanguageFile) {
    $Language = Import-LocalizedData -BaseDirectory "$PSScriptRoot/lang" -FileName $($GetScriptName).psd1 -UICulture $Lang
}
elseif (-Not (Test-Path $GetLanguageFile)) {
    $Language = Import-LocalizedData -BaseDirectory "$PSScriptRoot/lang" -FileName $($GetScriptName).psd1 -UICulture "en-US"
}
# language support complete

$Host.UI.RawUI.WindowTitle = "MyConfig - $($Language.ScriptTitle)"

if (-Not (Test-Path "$GetScriptDir/config.ps1")) {
    Write-Error $Language.NotFoundConfig
    Exit 1
}
else {
    . $GetScriptDir/config.ps1
}

if (-Not (Test-Path "$GetScriptDir/function.psm1")) {
    Write-Error $Language.NotFoundFunction
    Exit 1
}
else {
    $GetLanguageModuleFile = "$PSScriptRoot/lang/$Lang/function.psd1"

    if (-Not (Test-Path "$PSScriptRoot/lang/en-US/function.psd1")) {
        Write-Error "There is no language file. Module exited."
        Exit 1
    }
    elseif (Test-Path $GetLanguageModuleFile) {
        $LanguageModule = Import-LocalizedData -BaseDirectory "$PSScriptRoot/lang" -FileName function.psd1 -UICulture $Lang
    }
    elseif (-Not (Test-Path $GetLanguageModuleFile)) {
        $LanguageModule = Import-LocalizedData -BaseDirectory "$PSScriptRoot/lang" -FileName function.psd1 -UICulture "en-US"
    }
    Import-Module $GetScriptDir/function.psm1
}

if ($Help) {
    Show-Help
    Exit
}

if ($ConfigData.GetOSName -eq "microsoft windows 11 pro") {
    $OSDirectoryPath = "11-pro"
}
else {
    Write-Host-Red "$($Language.NotSupportOS)"
    Exit 1;
}

    Invoke-InstallScript -OSDirPath $OSDirectoryPath -Presetup:$Presetup -OnlyConfig:$OnlyConfig -Config:$Config

