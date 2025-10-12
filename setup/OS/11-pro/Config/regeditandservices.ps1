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
    ##############################################################
    
    if ($ConfigData.GetBuildNumber -ge 26045) {
        sudo config --enable forceNewWindow
    }
    
    $registryKeys = @(
        # Show Hide Files and Directories `[ ]` - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name  = "Hidden"
            Value = 1
        },
        # show sync provider notifications - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name  = "ShowSyncProviderNotifications"
            Value = 1
        },
        # Show encrypted or compressed NTFS files in color - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name  = "ShowEncryptCompressedColor"
            Value = 1
        },
        # Show CheckBox `[ ]` - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name  = "AutoCheckSelect"
            Value = 1
        },
        # Show File Extention - 0 ENABLE / 1 DISABLE
        @{
            Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name  = "HideFileExt"
            Value = 0
        },
        # Show recently used files - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
            Name  = "ShowRecent"
            Value = 0
        },
        # Start Menu Show recently used files - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name  = "Start_TrackDocs"
            Value = 0
        },
        # 
        @{
            Path  = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name  = "Start_Trackprogs"
            Value = 0
        },
        # Show frequently used folders - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
            Name  = "ShowFrequent"
            Value = 0
        },
        # Show files from office.com - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
            Name  = "ShowCloudFilesInQuickAccess"
            Value = 0
        },
        # Developer Mode - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock"
            Name  = "AllowDevelopmentWithoutDevLicense"
            Value = 1
        },
        # Taskbar enable "End Task" - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings"
            Name  = "TaskbarEndTask"
            Value = 1
        },
        # Run as different user - 0 ENABLE / 1 DISABLE
        @{
            Path  = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
            Name  = "ShowRunAsDifferentUserInStart"
            Value = 1
        },
        # Allow Telemetry - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKLM:\Software\Policies\Microsoft\Windows\DataCollection"
            Name  = "AllowTelemetry"
            Value = 0
            Type  = "DWord"
        },
        # Enable Activity Feed - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKLM:\Software\Policies\Microsoft\Windows\System"
            Name  = "EnableActivityFeed"
            Value = 0
            Type  = "DWord"
        },
        # Publish User Activities - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKLM:\Software\Policies\Microsoft\Windows\System"
            Name  = "PublishUserActivities"
            Value = 0
            Type  = "DWord"
        },
        # Upload User Activities - 1 ENABLE / 0 DISABLE
        @{
            Path  = "HKLM:\Software\Policies\Microsoft\Windows\System"
            Name  = "UploadUserActivities"
            Value = 0
            Type  = "DWord"
        },
        # Marks the system as "Upgraded" in Windows Code Integrity (CI) policies;
        # Value 1 = Enabled (some driver signature and security checks may be relaxed)
        @{
            Path  = "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy"
            Name  = "UpgradedSystem"
            Value = 1
            Type  = "dword"
        }
    );
    $registryKeys += @(
        @{
            Path  = "HKLM:\Software\Policies\Microsoft\Windows\OneDrive"
            Name  = "DisableFileSyncNGSC"
            Value = 1
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
            Name  = "AllowCloudSearch"
            Value = 0
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
            Name  = "AllowCortana"
            Value = 0
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
            Name  = "AllowCortanaAboveLock"
            Value = 0
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
            Name  = "AllowSearchToUseLocation"
            Value = 0
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"
            Name  = "Disabled"
            Value = 1
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"
            Name  = "DontSendAdditionalData"
            Value = 1
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"
            Name  = "BypassPowerThrottling"
            Value = 0
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"
            Name  = "BypassNetworkCostThrottling"
            Value = 0
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"
            Name  = "BypassDataThrottling"
            Value = 0
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"
            Name  = "AutoApproveOSDumps"
            Value = 0
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
            Name  = "AllowDesktopAnalyticsProcessing"
            Value = 0
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
            Name  = "AllowDeviceNameInTelemetry"
            Value = 0
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\Software\Policies\Microsoft\Windows\AppCompat"
            Name  = "AITEnable"
            Value = 0
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\Software\Policies\Microsoft\Windows\AppCompat"
            Name  = "DisableInventory"
            Value = 1
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
            Name  = "DODownloadMode"
            Value = 0
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE"
            Name  = "DisablePrivacyExperience"
            Value = 1
            Type  = "DWord"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableAccessibilitySettingSync"
            Value = 2
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableAccessibilitySettingSyncUserOverride"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableApplicationSettingSync"
            Value = 2
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableApplicationSettingSyncUserOverride"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableAppSyncSettingSync"
            Value = 2
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableAppSyncSettingSyncUserOverride"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableDesktopThemeSettingSync"
            Value = 2
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableDesktopThemeSettingSyncUserOverride"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisablePersonalizationSettingSync"
            Value = 2
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisablePersonalizationSettingSyncUserOverride"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableSettingSync"
            Value = 2
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableSettingSyncUserOverride"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableStartLayoutSettingSync"
            Value = 2
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableStartLayoutSettingSyncUserOverride"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableSyncOnPaidNetwork"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableWebBrowserSettingSync"
            Value = 2
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableWebBrowserSettingSyncUserOverride"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableWindowsSettingSync"
            Value = 2
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync"
            Name  = "DisableWindowsSettingSyncUserOverride"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
            Name  = "AllowCrossDeviceClipboard"
            Value = 0
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
            Name  = "EnableActivityFeed"
            Value = 0
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
            Name  = "PublishUserActivities"
            Value = 0
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
            Name  = "UploadUserActivities"
            Value = 0
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
            Name  = "DisabledByGroupPolicy"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\Software\Policies\Microsoft\SQMClient\Windows"
            Name  = "CEIPEnable"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\Software\Policies\Microsoft\Messenger\Client"
            Name  = "CEIP"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting"
            Name  = "DoReport"
            Value = 0
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\Software\Policies\Microsoft\Windows\AppCompat"
            Name  = "AITEnable"
            Value = 0
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata"
            Name  = "PreventDeviceMetadataFromNetwork"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings"
            Name  = "DisableSendGenericDriverNotFoundToWER"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization"
            Name  = "RestrictImplicitInkCollection"
            Value = 1
            Type  = "dword"
        },
        @{
            Path  = "HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization"
            Name  = "RestrictImplicitTextCollection"
            Value = 1
            Type  = "dword"
        }
    )
    foreach ($key in $registryKeys) {
        if (-not (Test-Path $key.Path)) {
            New-Item -Path $key.Path -Force | Out-Null
        }
        if ($key.PSObject.Properties['Type']) {
            Set-ItemProperty -Path $key.Path -Name $key.Name -Value $key.Value -Type $key.Type
        }
        else {
            Set-ItemProperty -Path $key.Path -Name $key.Name -Value $key.Value
        }
    }

    Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\" -TaskName "UsbCeip"
    Disable-ScheduledTask -TaskPath "\Microsoft\Windows\PI\" -TaskName "Sqm-Tasks"
    Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience\" -TaskName "ProgramDataUpdater"

    #Stop-Process -Name "explorer" -Force
}
else {
    if (Test-CommandExists pwsh) {
        Start-Process pwsh.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs -Wait   
    }
    else {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs -Wait  
    }
}