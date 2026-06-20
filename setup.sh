#!/usr/bin/env bash
# ------------------------------------------------------------
# setup.sh – Central orchestrator
#   1. Loads shared modules (lib/).
#   2. Loads configuration (DISTRO, PLATFORM).
#   3. Initializes environment (root check, internet, sudo keep-alive).
#   4. Detects package manager.
#   5. Executes stage scripts based on command-line flags
#      (Repository, Presetup, Configure, Process).
#   The script aborts on any error (set -euo pipefail).
# ------------------------------------------------------------
set -euo pipefail
IFS=$'\n\t' # safe word splitting

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ------------------------------------------------------------
# Load shared modules
# ------------------------------------------------------------
source "${SCRIPT_DIR}/lib/colors.sh"
source "${SCRIPT_DIR}/lib/i18n.sh"
source "${SCRIPT_DIR}/lib/utils.sh"
source "${SCRIPT_DIR}/lib/package_manager.sh"

# ------------------------------------------------------------
# Compile translation files (.po → .mo)
# ------------------------------------------------------------
if [[ -x "${SCRIPT_DIR}/compile_translations.sh" ]]; then
	"${SCRIPT_DIR}/compile_translations.sh"
fi

# ------------------------------------------------------------
# Environment initialization (root check, internet, sudo keep-alive)
# ------------------------------------------------------------
init_environment() {
	# Must not be run as root — expects a normal user with sudo privileges.
	if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
		color_echo Red "$(_ "⚠️  Error: Script cannot be run as root. Please run as a normal user.")"
		exit 1
	fi

	# Simple internet connectivity test.
	if ! ping -c1 -W3 duckduckgo.com >/dev/null 2>&1; then
		color_echo Red "$(_ "⚠️  Error: No internet connection. Please check your network.")"
		exit 1
	fi

	# Acquire and keep alive sudo credentials.
	if ! sudo -v; then
		color_echo Red "$(_ "⚠️  Error: sudo authentication failed.")"
		exit 1
	fi
	(
		while true; do
			sudo -n true 2>/dev/null || break
			sleep 60
		done
	) &
	KEEP_ALIVE_PID=$!
	trap 'kill "$KEEP_ALIVE_PID" 2>/dev/null || true' EXIT
}

# ------------------------------------------------------------
# Configuration and environment initialization
# ------------------------------------------------------------
cd "$SCRIPT_DIR"
source "./config.sh"
init_environment

# ------------------------------------------------------------
# Package manager detection
# ------------------------------------------------------------
detect_package_manager

# ------------------------------------------------------------
# Distribution check
# ------------------------------------------------------------
if [[ -z "${DISTRO:-}" || "$DISTRO" == "unknown" ]]; then
	color_echo Red "$(_ "❌ Unable to detect Linux distribution.")" >&2
	exit 1
fi

# Select base directory based on platform (WSL, Distrobox, or native Linux)
case "$PLATFORM" in
	wsl)       BASE_DIR="distros_Wsl" ;;
	distrobox) BASE_DIR="distros_Distrobox" ;;
	*)         BASE_DIR="distros" ;;
esac

DISTRO_DIR="${SCRIPT_DIR}/${BASE_DIR}/${DISTRO}"
if [[ ! -d "$DISTRO_DIR" ]]; then
	color_echo Red "$(printf "$(_ "❌ Configuration not found for distro: %s at %s")" "$DISTRO" "$DISTRO_DIR")" >&2
	exit 1
fi

color_echo Yellow "$(printf "$(_ "🧭 Detected distribution: %s")" "$DISTRO")"
color_echo Yellow "$(printf "$(_ "🖥️  Platform: %s")" "$PLATFORM")"
color_echo Yellow "$(printf "$(_ "📁 Configuration directory: %s")" "$DISTRO_DIR")"

# ------------------------------------------------------------
# Parameter parsing & help
# ------------------------------------------------------------
# Supported flags:
#   --presetup   : Runs Repository + Presetup.
#   --install    : Runs Repository + Process.
#   --config     : Runs Configure.
#   --onlyconfig : Runs only Configure.
#   -h|--help    : Show this help message.

usage() {
	cat <<-EOF
Usage: ${0##*/} [OPTIONS]

Options:
  --presetup        Run Repository + Presetup scripts (initial system preparation).
  --install         Run Repository + Process scripts (install packages and configure the system).
  --config          Run only the Configure scripts (desktop, services, etc.).
  --onlyconfig      Alias for --config (runs Configure without preceding stages).
  -h, --help        Show this help message and exit.

At least one of the stage flags (--presetup, --install, --config, --onlyconfig) must be provided.
EOF
}

RUN_PRESETUP=false
RUN_CONFIG=false
RUN_PROCESS=false
SHOW_HELP=false

while [[ $# -gt 0 ]]; do
	case "$1" in
		--presetup)
			RUN_PRESETUP=true
			RUN_CONFIG=false
			RUN_PROCESS=false
			shift
			;;
		--install)
			RUN_PRESETUP=false
			RUN_PROCESS=true
			shift
			;;
		--config)
			RUN_CONFIG=true
			shift
			;;
		--onlyconfig)
			RUN_PRESETUP=false
			RUN_CONFIG=true
			RUN_PROCESS=false
			shift
			;;
		-h|--help)
			SHOW_HELP=true
			shift
			;;
		*)
			color_echo Red "$(printf "$(_ "⚠️  Unknown parameter: %s")" "$1")" >&2
			shift
			;;
	esac
done

if $SHOW_HELP; then
	usage
	exit 0
fi

# Fail if no flags are specified (parameter is mandatory)
if ! $RUN_PRESETUP && ! $RUN_CONFIG && ! $RUN_PROCESS; then
	color_echo Red "$(_ "⚠️  Error: You must specify a parameter (--presetup, --install, --config, --onlyconfig).")"
	exit 1
fi

# ------------------------------------------------------------
# Execute stages conditionally
# ------------------------------------------------------------
if $RUN_PRESETUP; then
	run_stage "${DISTRO_DIR}/Repository"
	run_stage "${DISTRO_DIR}/Presetup"
fi
if $RUN_PROCESS; then
	run_stage "${DISTRO_DIR}/Repository"
	run_stage "${DISTRO_DIR}/Process"
fi
if $RUN_CONFIG; then
	run_stage "${DISTRO_DIR}/Configure"
fi

color_echo Green "$(_ "✅ Setup completed successfully.")"
