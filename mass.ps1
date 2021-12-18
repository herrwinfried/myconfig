if (Test-Path -Path $env:TEMP/mass.zip) {
   Write-Host "Mass adında zip buldum onu siliyorum."
    Remove-Item $env:TEMP/mass.zip -Recurse
} else {
}
if (Test-Path -Path $env:TEMP/mass) {
    Write-Host "Mass adında klasör buldum onu siliyorum."
     Remove-Item $env:TEMP/mass -Recurse
 } else {
 }
Write-Host "MAS indiriyorum GitHub dan"
Invoke-WebRequest https://github.com/massgravel/Microsoft-Activation-Scripts/archive/refs/heads/master.zip -OutFile $env:TEMP/mass.zip
Write-Host "indirdim"

Write-Host "Zipten çıkartıyorum"
Expand-Archive $env:TEMP\mass.zip -DestinationPath $env:TEMP\mass
Write-Host "Zipten çıkarttım"

Write-Host "HWID çalıştırıyorum"
Set-Location $env:TEMP\mass\Microsoft-Activation-Scripts-master\MAS_1.4\Separate-Files-Version\Activators\HWID-KMS38_Activation
Start-Process HWID_Activation.cmd
Pause