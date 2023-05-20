if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct Script?"
   Start-Sleep -Seconds 3
    Exit 1
}

#Oh my posh

if (-NOT (Test-Path -Path "$env:USERPROFILE\.poshthemes")) {
    New-Item "$env:USERPROFILE\.poshthemes" -ItemType Directory 
}

if (Test-Path -Path "$env:USERPROFILE\.poshthemes\themes.zip") {
    Remove-Item  $env:USERPROFILE\.poshthemes\themes.zip -Recurse
}

# Invoke-WebRequest https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -OutFile $env:USERPROFILE\.poshthemes\themes.zip
# Expand-Archive $env:USERPROFILE\.poshthemes\themes.zip -DestinationPath  $env:USERPROFILE\.poshthemes
# if (Test-Path -Path "$env:USERPROFILE\.poshthemes\themes.zip") {
#     Remove-Item  $env:USERPROFILE\.poshthemes\themes.zip -Recurse
# }

Invoke-WebRequest https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/default.omp.json -OutFile $env:USERPROFILE\.poshthemes\default.omp.json

Start-Process PowerShell -verb runas "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned"
