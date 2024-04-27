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

    $registryKeys = @(
         # Show Hide Files and Directories `[ ]` - 1 ENABLE / 0 DISABLE
        @{
            Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name = "Hidden"
            Value = 1
        },
        # Show CheckBox `[ ]` - 1 ENABLE / 0 DISABLE
        @{
            Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name = "AutoCheckSelect"
            Value = 1
        },
        # Show File Extention - 0 ENABLE / 1 DISABLE
        @{
            Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name = "HideFileExt"
            Value = 0
        },
        # Show recently used files - 1 ENABLE / 0 DISABLE
        @{
            Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
            Name = "ShowRecent"
            Value = 0
        },
        # Start Menu Show recently used files - 1 ENABLE / 0 DISABLE
        @{
            Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name = "Start_TrackDocs"
            Value = 0
        },
        # Show frequently used folders - 1 ENABLE / 0 DISABLE
        @{
            Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
            Name = "ShowFrequent"
            Value = 0
        },
        # Show files from office.com - 1 ENABLE / 0 DISABLE
        @{
            Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
            Name = "ShowCloudFilesInQuickAccess"
            Value = 0
        }
    )

    foreach ($key in $registryKeys) {
        Set-ItemProperty -Path $key.Path -Name $key.Name -Value $key.Value
    }

    #Stop-Process -Name "explorer" -Force
} else {
    if (Test-CommandExists pwsh) {
        Start-Process pwsh.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs   
    } else {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs   
    }
}