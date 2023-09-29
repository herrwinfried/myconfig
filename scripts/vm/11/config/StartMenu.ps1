#TODO: It's not working, weird. Tried with export command.

$OldPWD = Get-Location
Set-Location $PSScriptRoot\..\..\..\..\dotfiles
$DotfilesFolder=$(pwd)

Import-StartLayout -LayoutPath "$DotfilesFolder\application.xml" -MountPath "C:\"

Set-Location $OldPWD