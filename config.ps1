$Host.UI.RawUI.WindowTitle = "HerrWinfried - MyConfig CONFIG"

onlywindows

$ScriptRoot=$PSScriptRoot

. $ScriptRoot\variable.ps1

Get-ChildItem $ScriptRoot\Windows\config -filter *.ps1 | ForEach-Object {
    . $_.FullName
}