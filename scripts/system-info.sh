#!/usr/bin/env bash
# ==============================================================================
# Script: system-info.sh
# Description: Gathers and displays basic system environment, user, and disk metrics.
# Author: Heviane
# ==============================================================================

set -euo pipefail

echo "=================================================="
echo "          💻 System Information Report"
echo "=================================================="

# Operating System & Kernel
echo -e "\n📌 OS & Kernel:"
uname -a 2>/dev/null || echo "Uname not available on this platform"

# Active Shell
echo -e "\n🐚 Active Shell:"
echo "Path: ${SHELL:-Not defined}"
if [ -n "${BASH_VERSION:-}" ]; then
    echo "Bash Version: $BASH_VERSION"
fi

# User & Home Directory
echo -e "\n👤 Current User:"
echo "Username: ${USER:-$(whoami 2>/dev/null || echo 'unknown')}"
echo "Home:     ${HOME:-${USERPROFILE:-Not defined}}"

# Disk Space Usage
if command -v df >/dev/null 2>&1; then
    echo -e "\n💾 Disk Usage:"
    df -h . 2>/dev/null || true
fi

echo -e "\n=================================================="
echo "Report generated successfully."
exit 0
