#!/usr/bin/env bash
# ------------------------------------------------------------
# config.sh
#   Detects the Linux distribution and execution environment
#   (WSL, Distrobox, native Linux). Reads configuration values
#   from /etc/os-release.
#
#   Exported variables:
#       DISTRO   – distribution ID (lowercase, e.g., "opensuse-tumbleweed")
#       PLATFORM – wsl, distrobox, or linux
#       NAME     – full distribution name (e.g., "openSUSE Tumbleweed")
#       VERSION  – distribution version
#       config   – various configuration values (associative array)
# ------------------------------------------------------------
set -euo pipefail

# ----------------------------------------------------------------
# Helper function to read from os-release
# ----------------------------------------------------------------
_os_release_value() {
	local key="$1"
	if [[ -f /etc/os-release ]]; then
		grep -E "^${key}=" /etc/os-release 2>/dev/null | cut -d= -f2- | tr -d '"' || true
	fi
}

# ----------------------------------------------------------------
# 1️⃣ Distribution detection
# ----------------------------------------------------------------
if [[ -f /etc/os-release ]]; then
	DISTRO="$(_os_release_value ID)"
	DISTRO="${DISTRO,,}" # convert to lowercase
	NAME="$(_os_release_value NAME)"
	VERSION="$(_os_release_value VERSION)"
else
	DISTRO="unknown"
	NAME="unknown"
	VERSION=""
fi

# ----------------------------------------------------------------
# 2️⃣ Platform detection
# ----------------------------------------------------------------
if [[ -n "${WSLENV-}" ]] || grep -qi microsoft /proc/version 2>/dev/null; then
	PLATFORM="wsl"
elif [[ -n "${DISTROBOX_ENTER_PATH-}" ]]; then
	PLATFORM="distrobox"
else
	PLATFORM="linux"
fi

export DISTRO PLATFORM NAME VERSION

# ----------------------------------------------------------------
# 3️⃣ Configuration values
# ----------------------------------------------------------------
declare -A config
config["distro"]="${NAME} ${VERSION}"
config["boardVendor"]="$(cat /sys/class/dmi/id/board_vendor 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo '')"

# Project root is the directory where this file is located
_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config["packageDirs"]="${_CONFIG_DIR}/data"

config["hostname"]="herrwinfried"

# ----------------------------------------------------------------
# 4️⃣ XDG user directories
# ----------------------------------------------------------------
_xdg_dirs_file="${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs"
if [[ ! -f "$_xdg_dirs_file" ]]; then
	xdg-user-dirs-update && sleep 1 && source "$_xdg_dirs_file"
else
	source "$_xdg_dirs_file"
fi

export PATH="$PATH:/usr/sbin:/sbin"
