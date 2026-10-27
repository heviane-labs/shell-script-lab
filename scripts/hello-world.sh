#!/usr/bin/env bash
# ==============================================================================
# Script: hello-world.sh
# Description: Introductory script demonstrating variables, shebang, interpolation,
#              and standard exit codes.
# Category: Basics
# Author: Heviane
# ==============================================================================

set -euo pipefail

# 1. Variables
readonly MESSAGE="Welcome to the Shell Script Laboratory!"
readonly CURRENT_USER="$(whoami 2>/dev/null || echo "${USER:-unknown}")"
readonly RUN_DATE="$(date '+%Y-%m-%d %H:%M:%S')"

# 2. Terminal Output
echo "=================================================="
echo "👋 $MESSAGE"
echo "👤 Current User: $CURRENT_USER"
echo "🕒 Executed At:  $RUN_DATE"
echo "📁 Working Dir:  $PWD"
echo "=================================================="

echo "Tip: Try editing this file or creating new scripts based on template.sh!"
exit 0
