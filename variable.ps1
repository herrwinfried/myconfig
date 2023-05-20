
function onlywindows {
if ($isLinux -Or $IsMacOS) {
        Write-Error "For Windows only, are you sure you added the correct Script?"
       Start-Sleep -Seconds 3
        Exit 1
}
}
function wingetx{
    param (
        [Parameter (Mandatory = $true)] [String]$Id
        )
$runnnx = "winget.exe install --id $Id --accept-package-agreements --accept-source-agreements"
        Invoke-Expression $runnnx
    }