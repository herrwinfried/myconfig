$config = New-Object PSObject

function New-ScriptConfig {
    param (
        [string]$Name,
        $Value
    )
$config | Add-Member -MemberType NoteProperty -Name $Name -Value $Value
}

New-ScriptConfig -Name 'Hostname' -Value 'HR-WINFRIED'
New-ScriptConfig -Name 'USERNAME' -Value $env:USERNAME
New-ScriptConfig -Name 'USERHOME' -Value $env:USERPROFILE

New-ScriptConfig -Name 'GetOSName' -Value (Get-WmiObject -Class Win32_OperatingSystem).Caption.ToLower()
New-ScriptConfig -Name 'GetBoardVendor' -Value (Get-CimInstance Win32_ComputerSystemProduct).Vendor.ToLower()

# https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.psmembertypes?view=powershellsdk-7.4.0