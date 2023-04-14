#!/bin/bash

  sudo $PackageName $PackageInstall snapd
  sudo systemctl enable --now snapd
  sudo systemctl enable --now snapd.apparmor