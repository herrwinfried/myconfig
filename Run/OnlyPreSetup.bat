@echo off
Title "MyConfig - CMD"
    cd ../setup
    start pwsh.exe -ExecutionPolicy Bypass -File .\install.ps1 -ps
exit