#!/usr/bin/env bash
# Configure/printer.sh — Printer service (CUPS)
set -euo pipefail

if systemctl list-unit-files cups.service &>/dev/null; then
	sudo systemctl enable --now cups
fi