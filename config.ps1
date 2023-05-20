$Host.UI.RawUI.WindowTitle = "HerrWinfried - MyConfig CONFIG"

if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct Script?"
   Start-Sleep -Seconds 3
    Exit 1
}

$ScriptRoot=$PSScriptRoot

. $ScriptRoot\variable.ps1

Get-ChildItem $ScriptRoot\Windows\config -filter *.ps1 | ForEach-Object {
    . $_.FullName
}