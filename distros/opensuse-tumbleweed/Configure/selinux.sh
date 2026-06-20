#!/usr/bin/env bash
# Configure/selinux.sh — SELinux context and boolean configuration
set -euo pipefail

if is_command semanage; then
	sudo semanage fcontext -a -t textrel_shlib_t "~/.local/share/Steam/compatibilitytools.d(/.*)?"
	sudo restorecon -Rv ~/.local/share/Steam/compatibilitytools.d 2>/dev/null || true
	sudo semanage fcontext -a -t textrel_shlib_t "~/Games(/.*)?"
	sudo restorecon -Rv ~/Games 2>/dev/null || true
fi

if is_command setsebool; then
	sudo setsebool -P selinuxuser_execmod 1
	sudo setsebool -P selinuxuser_execstack 1
fi