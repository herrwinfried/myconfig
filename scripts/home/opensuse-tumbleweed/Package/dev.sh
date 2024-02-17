#!/bin/bash

Package_a="git git-lfs"
Package_a+=" patterns-devel-C-C++-devel_C_C++ gdb llvm-clang gcc gcc-c++"
Package_a+=" cmake cmake-full extra-cmake-modules"
Package_a+=" qt6-base-devel qt6-declarative-devel"
Package_a+=" dotnet-sdk-7.0 patterns-devel-mono-devel_mono"
Package_a+=" patterns-devel-base-devel_rpm_build"
Package_a+=" python311 python311-pip rsync build ninja"
SUDO $Package $PackageInstall $Package_a

dotnet new install Avalonia.Templates
