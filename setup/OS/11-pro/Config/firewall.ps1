function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (IsAdministrator) {
    # FIXME: :/ Hey, if you know a more logical way, I'm open to suggestions.
    Set-Location $PSScriptRoot\..\..\..\
    $TempFolder = $(Get-Location)
    . "$TempFolder\config.ps1"
    Import-Module "$TempFolder\function.psm1"
    Set-Location $PSScriptRoot
    $envContent = @{} 
    Get-Content "$TempFolder\..\.env" | ForEach-Object {
        if ($_ -match "^\s*([^#][^=]+)=(.+)$") {
            $envContent[$matches[1].Trim()] = $matches[2].Trim()
        }
    }
    ##############################################################
    $WACPort = if ($envContent["WACPort"]) { $envContent["WACPort"] } else { 6600 }
    New-NetFirewallRule -DisplayName "Windows Admin Center Block Port" -Enabled True -Profile Domain, Public -Direction Inbound -Action Block -LocalPort $WACPort -Protocol TCP
}
else {
    if (Test-CommandExists pwsh) {
        Start-Process pwsh.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs -Wait   
    }
    else {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs -Wait  
    }
}