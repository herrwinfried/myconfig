#!/bin/bash

function package {
sudo $PackageName $PackageInstall nvidia-glG06 x11-video-nvidiaG06 #xf86-video-intel bbswitch
}
groupadd wheel
usermod -aG wheel winfried

package