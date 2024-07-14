function IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (IsAdministrator) {

    if ($ConfigData.GetBuildNumber -ge 26045) {
        sudo config --enable forceNewWindow
    }

    $registryKeys = @(
        # Developer Mode - 1 ENABLE / 0 DISABLE
       @{
           Path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock"
           Name = "AllowDevelopmentWithoutDevLicense"
           Value = 1
       },
       # Taskbar enable "End Task" - 1 ENABLE / 0 DISABLE
       @{
           Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings"
           Name = "TaskbarEndTask"
           Value = 1
       },
       # Run as different user - 0 ENABLE / 1 DISABLE
       @{
           Path = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
           Name = "ShowRunAsDifferentUserInStart"
           Value = 1
       }
   )

   foreach ($key in $registryKeys) {
    if (-not (Test-Path $key.Path)) {
        New-Item -Path $key.Path -Force | Out-Null
    }
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