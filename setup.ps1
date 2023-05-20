$Host.UI.RawUI.WindowTitle = "HerrWinfried - MyConfig SETUP"

if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct Script?"
   Start-Sleep -Seconds 3
    Exit 1
}
$ScriptRoot=$PSScriptRoot

. $ScriptRoot\variable.ps1

Get-ChildItem $ScriptRoot\Windows\FirstProcess -filter *.ps1 | ForEach-Object {
    . $_.FullName
}

Get-ChildItem $ScriptRoot\Windows\FirstPackage -filter *.ps1 | ForEach-Object {
    . $_.FullName
}

Get-ChildItem $ScriptRoot\Windows\Package -filter *.ps1 | ForEach-Object {
    . $_.FullName
}

Get-ChildItem $ScriptRoot\Windows\RecentProcess -filter *.ps1 | ForEach-Object {
    . $_.FullName
}