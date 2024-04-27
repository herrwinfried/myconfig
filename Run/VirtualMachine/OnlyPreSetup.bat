@echo off
Title "MyConfig - CMD"
    cd ../../scripts
    start powershell.exe -ExecutionPolicy Bypass -File .\install.ps1 -vm -ps
exit