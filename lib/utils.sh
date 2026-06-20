#!/usr/bin/env bash
# ------------------------------------------------------------
# lib/utils.sh — Helper functions
#   is_command        – command existence check
#   run_stage         – executes scripts in a stage directory sequentially
#   flatpakOverrideFs – flatpak filesystem override
#   CreateDirectory   – directory creation + optional KDE icon assignment
#   Dependencies: colors.sh, i18n.sh
# ------------------------------------------------------------

# Guard: prevent multiple sourcing
[[ -n "${_LIB_UTILS_LOADED:-}" ]] && return 0
readonly _LIB_UTILS_LOADED=1

# ----------------------------------------------------------------
# is_command <command>
#   Checks if the command exists in PATH.
# ----------------------------------------------------------------
is_command() {
	command -v "$1" >/dev/null 2>&1
}

# ----------------------------------------------------------------
# run_stage <stage_dir>
#   Executes *.sh files in the given directory in alphabetical order.
#   Each script is sourced in its own subshell — this provides access
#   to shared functions while preventing environment pollution.
#   Parameters:
#       $1 – stage directory (absolute or relative path)
# ----------------------------------------------------------------
run_stage() {
	local stage_dir="$1"
	if [[ ! -d "$stage_dir" ]]; then
		printf "%s\n" "$(printf "$(_ "⚠️  Stage directory not found: %s")" "$stage_dir")" >&2
		return 0 # silently skip missing stage
	fi

	local script
	while IFS= read -r -d '' script; do
		printf "%s\n" "$(printf "$(_ "▶️  Executing: %s")" "$script")"
		# source to allow access to lib functions
		# within a subshell to prevent environment pollution
		( source "$script" )
	done < <(find "$stage_dir" -maxdepth 1 -type f -name '*.sh' -print0 | sort -z)
}

# ----------------------------------------------------------------
# flatpakOverrideFs <user_bool> <filesystem> [appname]
#   Applies a flatpak filesystem override.
#   $1 – if "true", adds the --user flag
#   $2 – filesystem path
#   $3 – (optional) application name; if omitted, applies global override
# ----------------------------------------------------------------
flatpakOverrideFs() {
	is_command flatpak || return 0

	local user="$1"
	local fsystem="$2"
	local appname="${3:-}"
	local -a flatargs=()

	if [[ "$user" == "true" ]]; then
		flatargs+=("--user")
	fi

	if [[ -n "$appname" ]]; then
		flatpak "${flatargs[@]}" override --filesystem="$fsystem" "$appname"
	else
		flatpak "${flatargs[@]}" override --filesystem="$fsystem"
	fi
}

# ----------------------------------------------------------------
# CreateDirectory <path> [icon_name]
#   Creates a directory. Optionally writes an icon name to a KDE
#   .directory file.
#   Parameters:
#       $1 – directory path to create
#       $2 – (optional) KDE icon name
# ----------------------------------------------------------------
CreateDirectory() {
	local dir_path="$1"
	local icon_name="${2:-}"

	mkdir -p "$dir_path"

	if [[ -n "$icon_name" ]]; then
		local dir_file="${dir_path}/.directory"
		cat > "$dir_file" <<-EOF
			[Desktop Entry]
			Icon=$icon_name
		EOF
	fi
}
