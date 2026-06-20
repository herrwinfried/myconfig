#!/usr/bin/env bash
# ------------------------------------------------------------
# lib/package_manager.sh — Package manager detection and commands
#   Functions:
#     detect_package_manager   – Selects PM based on $DISTRO
#     PackageManagerVariable   – Sets PM command variables
#     PackageInstall           – Installs system packages
#     PackageUnInstall         – Removes system packages
#     FlatpakPackageInstall    – Installs flatpak packages
#   Dependencies: colors.sh, i18n.sh, config.sh (NAME, VERSION)
# ------------------------------------------------------------

# Guard: prevent multiple sourcing
[[ -n "${_LIB_PM_LOADED:-}" ]] && return 0
readonly _LIB_PM_LOADED=1

# ----------------------------------------------------------------
# _get_update_type <pm>
#   Determines the update command depending on the distribution.
#   Rolling distros (tumbleweed, slowroll, microos, kubic) use
#   a different command than stable distros (leap).
#   Merged function replacing zypperUpdateValue + dnfUpdateValue.
# ----------------------------------------------------------------
_get_update_type() {
	local pm="$1"
	local distro_str
	distro_str="$(echo "${NAME:-} ${VERSION:-}" | tr '[:upper:]' '[:lower:]')"

	local dup_val up_val
	case "$pm" in
		zypper)    dup_val="dup";         up_val="up"      ;;
		dnf|dnf5)  dup_val="distro-sync"; up_val="upgrade" ;;
		*)         echo "up"; return      ;;
	esac

	local -a rolling_distros=("tumbleweed" "slowroll" "microos" "kubic")
	for pattern in "${rolling_distros[@]}"; do
		if [[ "$distro_str" == *"$pattern"* ]]; then
			echo "$dup_val"
			return
		fi
	done

	echo "$up_val"
}

# ----------------------------------------------------------------
# PackageManagerVariable <pm_name>
#   Sets global PM_* variables based on the given package manager.
# ----------------------------------------------------------------
PackageManagerVariable() {
	local pm="$1"
	local yes_flag="-y"

	case "$pm" in
		zypper)
			PM="zypper"
			PM_Refresh="refresh ${yes_flag}"
			PM_Upgrade="$(_get_update_type zypper) ${yes_flag}"
			PM_Install="--no-gpg-checks install ${yes_flag}"
			PM_Uninstall="remove ${yes_flag}"
			;;
		dnf)
			PM="dnf"
			PM_Refresh="makecache ${yes_flag}"
			PM_Upgrade="$(_get_update_type dnf) ${yes_flag}"
			PM_Install="install --no-gpg-checks ${yes_flag}"
			PM_Uninstall="remove ${yes_flag}"
			;;
		dnf5)
			PM="dnf5"
			PM_Refresh="makecache ${yes_flag}"
			PM_Upgrade="$(_get_update_type dnf5) ${yes_flag}"
			PM_Install="install --no-gpg-checks ${yes_flag}"
			PM_Uninstall="remove ${yes_flag}"
			;;
		pacman)
			PM="pacman"
			PM_Refresh="-Sy"
			PM_Upgrade="-Syu --noconfirm"
			PM_Install="-S --noconfirm"
			PM_Uninstall="-Rns --noconfirm"
			;;
		apt)
			PM="apt"
			PM_Refresh="update ${yes_flag}"
			PM_Upgrade="upgrade ${yes_flag}"
			PM_Install="install ${yes_flag}"
			PM_Uninstall="remove ${yes_flag}"
			;;
		flatpak)
			FPM="flatpak"
			FPM_Refresh="update ${yes_flag}"
			FPM_Upgrade="update ${yes_flag}"
			FPM_Install="install ${yes_flag}"
			FPM_Uninstall="uninstall ${yes_flag}"
			;;
		brew)
			BPM="/home/linuxbrew/.linuxbrew/bin/brew"
			BPM_Refresh="update"
			BPM_Upgrade="upgrade"
			BPM_Install="install"
			BPM_Uninstall="uninstall"
			;;
		snap)
			SPM="snap"
			SPM_Refresh="refresh ${yes_flag}"
			SPM_Upgrade="refresh ${yes_flag}"
			SPM_Install="install ${yes_flag}"
			SPM_Uninstall="uninstall ${yes_flag}"
			;;
		*)
			color_echo Red "$(_ "⚠️  Invalid package manager:") $pm"
			return 1
			;;
	esac
}

# ----------------------------------------------------------------
# detect_package_manager
#   Detects the appropriate package manager based on $DISTRO
#   and calls PackageManagerVariable.
# ----------------------------------------------------------------
detect_package_manager() {
	local pm=""
	case "${DISTRO}" in
		*opensuse*|*suse*) pm="zypper" ;;
		*fedora*|*rhel*|*centos*) pm="dnf" ;;
		*ubuntu*|*debian*) pm="apt" ;;
		*arch*|*manjaro*) pm="pacman" ;;
		*alpine*) pm="apk" ;;
		*) pm="" ;;
	esac

	if [[ -z "$pm" ]]; then
		color_echo Red "$(printf "$(_ "⚠️  Unsupported distribution: %s")" "$DISTRO")"
		exit 1
	fi

	PackageManagerVariable "$pm"
	PackageManagerVariable "flatpak"
	PackageManagerVariable "brew"
	PackageManagerVariable "snap"
}

# ----------------------------------------------------------------
# Package installation/removal functions
#   Executes via sudo with proper quoting.
# ----------------------------------------------------------------
PackageInstall() {
	[[ $# -eq 0 ]] && return 0
	local IFS=$' \n\t'
	# shellcheck disable=SC2086
	sudo $PM $PM_Install "$@"
}

PackageUnInstall() {
	[[ $# -eq 0 ]] && return 0
	local IFS=$' \n\t'
	# shellcheck disable=SC2086
	sudo $PM $PM_Uninstall "$@"
}

FlatpakPackageInstall() {
	[[ $# -eq 0 ]] && return 0
	local IFS=$' \n\t'
	# shellcheck disable=SC2086
	sudo $FPM $FPM_Install "$@"
}
