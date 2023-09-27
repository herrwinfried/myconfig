if (IsAdministrator) {
    $ScriptFolderTemp = Join-Path $PSScriptRoot "..\..\.."
    . "$ScriptFolderTemp\VARIABLE.ps1"

    Install-PackageProvider -Name NuGet -Force
    Install-Module -Name PSWindowsUpdate -Force
} else {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
}

if (-not (IsAdministrator)) {
    winget update -r
}
