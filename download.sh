#!/bin/bash
cd /tmp                       
if [[ -f "/tmp/macos.zip" ]]; then 
rm -rf macos*
fi
curl -L https://github.com/herrwinfried/myconfig/archive/refs/heads/macos.zip -o /tmp/macos.zip
unzip /tmp/macos.zip    
if [[ -f "/Users/winfried/MyConfig" ]]; then 
rm -rf /Users/winfried/MyConfig
fi                       
mv /tmp/myconfig-macos /Users/winfried/MyConfig