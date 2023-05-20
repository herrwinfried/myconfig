if ($isLinux -Or $IsMacOS) {
    Write-Error "For Windows only, are you sure you added the correct Script?"
   Start-Sleep -Seconds 3
    Exit 1
}

wingetx -Id Brave.Brave
wingetx -Id Valve.Steam
wingetx -Id EpicGames.EpicGamesLauncher
wingetx -Id 9P9TQF7MRM4R #WSL
wingetx -Id 9MSSK2ZXXN11 # OpenSUSE Tumbleweed
wingetx -Id 9NKSQGP7F2NH # WhatsApp
wingetx -Id 9N97ZCKPD60Q #Unigram
wingetx -Id Telegram.TelegramDesktop
wingetx -Id 9WZDNCRFHWL #HP Smart
wingetx -Id RevoUninstaller.RevoUninstaller
wingetx -Id Flameshot.Flameshot
wingetx -Id Microsoft.PowerToys
wingetx -Id Discord.Discord 
wingetx -Id Discord.Discord.PTB
wingetx -Id Element.Element
wingetx -Id KDE.KDEConnect
wingetx -Id 9N9WCLWDQS5J #Bluetooth Audio Receiver
# wingetx -Id BlueStack.BlueStacks
wingetx -Id BinanceTech.Binance
wingetx -Id OpenVPNTechnologies.OpenVPNConnect
wingetx -Id Twilio.Authy
wingetx -Id 7zip.7zip
wingetx -Id 9N9KDPHV91JT #f.lux
wingetx -Id AnyDeskSoftwareGmbH.AnyDesk
wingetx -Id TeamViewer.TeamViewer
wingetx -Id OBSProject.OBSStudio
wingetx -Id Google.Drive
#wingetx -Id Mega.MEGASync

#wingetx -Id XP8JK4HZBVF435 #auto dark mode
#wingetx -Id 9NM8N7DQ3Z5F #WinDynamicDesktop