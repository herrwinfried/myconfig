# if (IsAdministrator) {
#     $ScriptFolderTemp = Join-Path $PSScriptRoot "..\..\.."
#     . "$ScriptFolderTemp\VARIABLE.ps1"
# Rename-Computer -NewName "$NEW_HOSTNAME"
# } else {
#     Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs   
# }
Write-Debug "-_- / rename-computer"