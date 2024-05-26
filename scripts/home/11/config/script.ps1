function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (IsAdministrator) {
    # FIXME: :/ Hey, if you know a more logical way, I'm open to suggestions.
    Set-Location $PSScriptRoot\..\..\..\
    $TempFolder=$(Get-Location)
    . "$TempFolder\config.ps1"
    Import-Module "$TempFolder\function.psm1"
    Set-Location $PSScriptRoot
    ##############################################################

    New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Value "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Force

} else {
    New-Directory "$GetDataDir\home\.poshthemes\"
    Remove-Item2 "$env:USERPROFILE\.poshthemes\default.omp.json"
    Invoke-Download -url "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.poshthemes/default.omp.json" -desc "$GetDataDir\home\.poshthemes\default.omp.json"

    Copy-Item -Recurse -Force -Path "$GetDataDir\home\*" -Destination "$env:USERPROFILE"

    New-Directory $env:USERPROFILE\Documents\WindowsPowerShell
    New-Directory $env:USERPROFILE\Documents\PowerShell
    if (Test-CommandExists pwsh) {
        Start-Process pwsh.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs -Wait  
    } else {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs -Wait   
    }
}