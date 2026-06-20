#!/usr/bin/env bash
# ------------------------------------------------------------
# lib/colors.sh — Color definitions and colored output helper
#   This module is intended to be sourced by all scripts.
#   Requirement: bash 4+ (for associative arrays)
# ------------------------------------------------------------

# Guard: prevent multiple sourcing
[[ -n "${_LIB_COLORS_LOADED:-}" ]] && return 0
readonly _LIB_COLORS_LOADED=1

declare -A COLORS=(
	[Black]='\033[0;30m'    [DarkBlue]='\033[0;34m'    [DarkGreen]='\033[0;32m'  [DarkCyan]='\033[0;36m'
	[DarkRed]='\033[0;31m'  [DarkMagenta]='\033[0;35m' [DarkYellow]='\033[0;33m' [Gray]='\033[0;37m'
	[DarkGray]='\033[1;30m' [Blue]='\033[1;34m'        [Green]='\033[1;32m'      [Cyan]='\033[1;36m'
	[Red]='\033[1;31m'      [Magenta]='\033[1;35m'     [Yellow]='\033[1;33m'     [White]='\033[1;37m'
	[NoColor]='\033[0m'
)

# ----------------------------------------------------------------
# color_echo <color_name> <message...>
#   Prints a message in the specified color and resets the color.
#   Usage: color_echo Green "Operation successful!"
# ----------------------------------------------------------------
color_echo() {
	local color_key="$1"
	shift
	echo -e "${COLORS[$color_key]}$*${COLORS[NoColor]}"
}
