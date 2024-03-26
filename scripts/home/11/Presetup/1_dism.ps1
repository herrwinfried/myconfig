function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (IsAdministrator) {
    Set-Location $PSScriptRoot\..\..\..\
    $TempFolder=$(Get-Location)
    . "$TempFolder\variable.ps1"

    # Enable features
    $features = @(
        "Microsoft-Hyper-V-All",
        "VirtualMachinePlatform",
        "HypervisorPlatform",
        "Containers",
        "Containers-HNS",
        "Containers-SDN",
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
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs   
}
