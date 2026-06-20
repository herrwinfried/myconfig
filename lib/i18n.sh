#!/usr/bin/env bash
# ------------------------------------------------------------
# lib/i18n.sh — gettext initialization and _() translation function
#   Source language: English  |  Available translations: Turkish (tr)
#   When sourced, this module sets TEXTDOMAIN and TEXTDOMAINDIR.
# ------------------------------------------------------------

# Guard: prevent multiple sourcing
[[ -n "${_LIB_I18N_LOADED:-}" ]] && return 0
readonly _LIB_I18N_LOADED=1

# Calculate the project root from the location of this file (parent of lib/)
_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${_LIB_DIR}/.." && pwd)"

export TEXTDOMAIN="myconfig"
export TEXTDOMAINDIR="${PROJECT_ROOT}/locale"

# ----------------------------------------------------------------
# _() — gettext wrapper
#   Usage: echo "$(_ "Hello, World!")"
#   With printf: printf "$(_ "Found %s items")" "$count"
# ----------------------------------------------------------------
_() { gettext "$@"; }
