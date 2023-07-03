param (
    [ValidateSet('server-ltsc22', 'servercore-ltsc22')]
    [string]$image = "servercore-ltsc22",
    
    [bool]$setname = $True
)

function NotMatch_LineParse($content, $search) {
    $lineAr = @()
    $Lines = $content -split '\r?\n'
    foreach ($line in $Lines) {
        if ($line -notmatch "$search") {
            $lineAr += $line
        }
    }
    $JoinLines = $lineAr -join "`r`n"

    return $JoinLines
}


# SOURCE 
$sourceFile = "$image.dockerfile"
#COPY
$newFile = "full-$image.dockerfile"

Copy-Item -Path "$image.dockerfile" -Destination "$newFile" -Force

$MainFilePath = Join-Path -Path $PWD -ChildPath $newFile
$MainFileContent = Get-Content -Path $MainFilePath -Raw
if ($setname) {
    $MainFileContent = $MainFileContent -replace "herrwinfried/dev_env:$image", "herrwinfried/dev_env:full-$image"
    $MainFileContent = $MainFileContent -replace "$image.dockerfile", "$newFile"

}
$MainFileContent=NotMatch_LineParse $MainFileContent "git"
Set-Content -Path $MainFilePath -Value $MainFileContent

$RUNTIME_URL = "https://raw.githubusercontent.com/dotnet/dotnet-docker/main/src/runtime/7.0/windowsservercore-ltsc2022/amd64/Dockerfile"
$SDK_URL = "https://raw.githubusercontent.com/dotnet/dotnet-docker/main/src/sdk/7.0/windowsservercore-ltsc2022/amd64/Dockerfile"
$ASPNET_URL = "https://raw.githubusercontent.com/dotnet/dotnet-docker/main/src/aspnet/7.0/windowsservercore-ltsc2022/amd64/Dockerfile"
$IIS_URL = "https://raw.githubusercontent.com/microsoft/iis-docker/main/windowsservercore-ltsc2022/Dockerfile"

$RUNTIME_REPO = "mcr.microsoft.com/windows/servercore:ltsc2022" #ltsc2022-amd64
$SDK_REPO = "mcr.microsoft.com/dotnet/aspnet"
$ASPNET_REPO = "mcr.microsoft.com/dotnet/runtime"
$IIS_REPO = "mcr.microsoft.com/windows/servercore:ltsc2022"

$filesToAppend = @(
    @{ Name = "runtimeDockerfile"; Url = $RUNTIME_URL; Repo = $RUNTIME_REPO },
    @{ Name = "sdkDockerfile"; Url = $SDK_URL; Repo = $SDK_REPO },
    @{ Name = "aspnetDockerfile"; Url = $ASPNET_URL; Repo = $ASPNET_REPO },
    @{ Name = "iisDockerfile"; Url = $IIS_URL; Repo = $IIS_REPO }
)

foreach ($file in $filesToAppend) {
    $filePath = Join-Path -Path $PWD -ChildPath $file.Name
    $fileUrl = $file.Url
    $fileRepo = $file.Repo

    Invoke-WebRequest -Uri $fileUrl -OutFile $filePath

    $content = Get-Content -Path $filePath -Raw

    if ($file.Name -eq "runtimeDockerfile") {
        $useText = [Regex]::Escape('RUN setx /M PATH "%PATH%;C:\Program Files\dotnet"')
        $setText = "RUN `$existingPath = [Environment]::GetEnvironmentVariable('PATH', 'Machine'); `$newPath = `$existingPath + ';C:\Program Files\dotnet'; [Environment]::SetEnvironmentVariable('PATH', `$newPath, 'Machine')"
        $content = $content -replace $useText, $setText
    }

    if ($file.Name -eq "sdkDockerfile") {
        $useText = [Regex]::Escape('RUN setx /M PATH "%PATH%;C:\Program Files\powershell;C:\Program Files\MinGit\cmd"')
        $setText = "RUN `$existingPath = [Environment]::GetEnvironmentVariable('PATH', 'Machine'); `$newPath = `$existingPath + ';C:\Program Files\powershell;C:\Program Files\MinGit\cmd'; [Environment]::SetEnvironmentVariable('PATH', `$newPath, 'Machine')"
        $content = $content -replace $useText, $setText

 }

         $content = $content -replace '# escape=`', "# SOURCE NAME: $($file.Name)"
         $content = $content -replace '`', '\'
         $content = $content -replace 'ARG REPO', '# ARG REPO'
         $content = $content -replace '\$REPO', $fileRepo
         $content = $content -replace 'FROM mcr.microsoft.com', "#FROM mcr.microsoft.com"
         $content = $content -replace 'EXPOSE', "#EXPOSE"
         $content = $content -replace 'ENTRYPOINT', "#ENTRYPOINT"
     
         $content = $content -replace '\$ErrorActionPreference', "#`$ErrorActionPreference"
         $content = $content -replace '\$ProgressPreference', "#`$ProgressPreference"


    Add-Content -Path $newFile -Value $content
    Remove-Item -Path $filePath

}
