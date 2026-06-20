#!/usr/bin/env bash
# ------------------------------------------------------------
# compile_translations.sh
#   Scans the ./locale directory for *.po files and compiles them
#   into binary *.mo files using msgfmt. This script can be run
#   manually or invoked from other scripts (e.g., setup.sh) to ensure
#   translations are up-to-date.
# ------------------------------------------------------------
set -euo pipefail
IFS=$'\n\t'

# Base directory of the script (project root)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCALE_DIR="${BASE_DIR}/locale"

if [[ ! -d "$LOCALE_DIR" ]]; then
	echo "Locale directory not found: $LOCALE_DIR"
	exit 1
fi

# Find all .po files and compile them to .mo if needed
while IFS= read -r po_file; do
	mo_file="${po_file%.po}.mo"
	# Compile if .mo does not exist or .po is newer
	if [[ ! -f "$mo_file" ]] || [[ "$po_file" -nt "$mo_file" ]]; then
		echo "Compiling $po_file -> $mo_file"
		msgfmt "$po_file" -o "$mo_file"
	else
		echo "Up-to-date: $mo_file"
	fi
done < <(find "$LOCALE_DIR" -type f -name "*.po")
