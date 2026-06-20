#!/usr/bin/env bash
# Configure/tun.sh — Configure TUN module for automatic loading
set -euo pipefail

echo tun | sudo tee /etc/modules-load.d/tun.conf >/dev/null
