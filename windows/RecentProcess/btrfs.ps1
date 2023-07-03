choco install -y winbtrfs

# ##########################################################WINBTRFS######################################################
# $BtrfsFolder = "$env:USERPROFILE\winbtrfs"
# # Folder Check
# if (Test-Path -Path $BtrfsFolder) {
#     Write-Host "I found folder named winbtrfs and deleted it." -ForegroundColor Red
#     Remove-Item "$env:USERPROFILE\winbtrfs" -Recurse
# }

# New-Item "$env:USERPROFILE\winbtrfs" -ItemType Directory

# Invoke-WebRequest https://github.com/maharmstone/btrfs/releases/download/v1.8.2/btrfs-1.8.2.zip -OutFile $env:USERPROFILE\winbtrfs\btrfs.zip
# Expand-Archive $env:USERPROFILE\winbtrfs\btrfs.zip -DestinationPath $env:USERPROFILE\winbtrfs\btrfs
# $Btrfss=$(Get-ChildItem "$env:USERPROFILE\winbtrfs\btrfs" -Filter "*.inf" | ForEach-Object { PNPUtil.exe /add-driver "$($_.FullName)" /install 2>$null })
# Start-Process PowerShell -ArgumentList "-noexit", "$Btrfss" -Verb RunAs
# ##########################################################WINBTRFS######################################################