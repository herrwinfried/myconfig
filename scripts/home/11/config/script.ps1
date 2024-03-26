function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (IsAdministrator) {
    Set-Location $PSScriptRoot\..\..\..\
    $TempFolder=$(Get-Location)
    . "$TempFolder\variable.ps1"

New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Value "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Force
} else {
    Create-Folder "$ScriptFolder1\data\home\.poshthemes\"
    Remove-File "$env:USERPROFILE\.poshthemes\default.omp.json"
    Download-File -url "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.poshthemes/default.omp.json" -desc "$ScriptFolder1\data\home\.poshthemes\default.omp.json"

    Copy-Item -Recurse -Force -Path "$ScriptFolder1\data\home\*" -Destination "$env:USERPROFILE"

    Create-Folder $env:USERPROFILE\Documents\WindowsPowerShell
    Create-Folder $env:USERPROFILE\Documents\PowerShell
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
}
