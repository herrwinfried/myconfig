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

    $features = @(
        "Microsoft-Hyper-V-All",
        "VirtualMachinePlatform",
        "HypervisorPlatform",
        "Containers",
        "Containers-HNS",
        "Containers-SDN",
        "Containers-DisposableClientVM"
        "LegacyComponents",
        "DirectPlay",
        "Printing-XPSServices-Features",
        "Printing-PrintToPDFServices-Features"
    )
    foreach ($feature in $features) {
        dism.exe /online /enable-feature /featurename:$feature /all /norestart
    }  
    # Fix Hypervisor platform
    bcdedit /set hypervisorlaunchtype auto
} else {
    if (Test-CommandExists pwsh) {
        Start-Process pwsh.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs   
    } else {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs   
    }
}