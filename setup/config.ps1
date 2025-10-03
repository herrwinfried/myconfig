$ConfigData = [PSCustomObject]@{}

function New-ConfigData {
    param (
        [string]$Name,
        $Value
    )
    $ConfigData | Add-Member -MemberType NoteProperty -Name $Name -Value $Value
}

New-ConfigData -Name 'Hostname' -Value 'HR-WINFRIED'
New-ConfigData -Name 'USERNAME' -Value $env:USERNAME
New-ConfigData -Name 'USERHOME' -Value $env:USERPROFILE
if ($IsLinux) {
    Write-Warning "Linux is not supported yet."

    New-ConfigData -Name 'GetOSName' -Value ([System.Runtime.InteropServices.RuntimeInformation]::OSDescription.ToLower())
    New-ConfigData -Name 'GetBoardVendor' -Value (cat /sys/class/dmi/id/sys_vendor 2>$null)
    New-ConfigData -Name 'GetBuildNumber' -Value ((Select-String -Path /etc/os-release -Pattern '^VERSION_ID=').Line.Split('=')[1].Trim('"') | Write-Host "NoBuildNumber")
} elseif ($IsMacOS) {
    New-ConfigData -Name 'GetOSName' -Value ([System.Runtime.InteropServices.RuntimeInformation]::OSDescription.ToLower())
    Write-Error "MacOS is not supported yet."
} else {
    New-ConfigData -Name 'GetOSName' -Value (Get-WmiObject -Class Win32_OperatingSystem).Caption.ToLower()
    New-ConfigData -Name 'GetBoardVendor' -Value (Get-CimInstance Win32_ComputerSystemProduct).Vendor.ToLower()
    New-ConfigData -Name 'GetBuildNumber' -Value ([int](Get-WmiObject -Class Win32_OperatingSystem).BuildNumber)
}

# https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.psmembertypes?view=powershellsdk-7.4.0