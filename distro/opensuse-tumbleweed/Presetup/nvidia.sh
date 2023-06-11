#!/bin/bash

if ! checkwsl ; then

sudo $Package $PackageInstall nvidia-glG06 x11-video-nvidiaG06 nvidia-drivers-G06 #xf86-video-intel bbswitch
sudo groupadd wheel
sudo usermod -aG wheel $Username

fi