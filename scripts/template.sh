#!/usr/bin/env bash
# ==============================================================================
# Script: template.sh
# Description: Canonical production-grade baseline template with robust error
#              handling, colorized logging, help flags, and signal traps.
# Category: Template
# Author: Heviane
# ==============================================================================

# Strict error handling:
# -e: Exit immediately if any command fails
# -u: Treat unset variables as an error
# -o pipefail: Pipeline returns the status of the last command to fail
set -euo pipefail

# ------------------------------------------------------------------------------
# Global Configurations & Constants
# ------------------------------------------------------------------------------
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ------------------------------------------------------------------------------
# Logging Utilities
# ------------------------------------------------------------------------------
log_info() {
    echo -e "\033[1;34m[INFO]\033[0m $*"
}

log_success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $*"
}

log_warn() {
    echo -e "\033[1;33m[WARN]\033[0m $*" >&2
}

log_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $*" >&2
}

# ------------------------------------------------------------------------------
# Cleanup Hook (Executed on exit, interrupt or termination)
# ------------------------------------------------------------------------------
cleanup() {
    local exit_code=$?
    # Add temporary file cleanup here if needed
    if [ "$exit_code" -ne 0 ]; then
        log_error "Script terminated with exit code $exit_code."
    fi
    exit "$exit_code"
}
trap cleanup EXIT SIGINT SIGTERM

# ------------------------------------------------------------------------------
# Help / Usage Display
# ------------------------------------------------------------------------------
show_help() {
    cat << EOF
Usage: $SCRIPT_NAME [options]

Options:
  -h, --help       Show this help message and exit
  -n, --name NAME  Specify target name for execution
  -d, --dry-run    Simulate execution without applying changes

Examples:
  ./$SCRIPT_NAME --name "LabUser"
  ./$SCRIPT_NAME --help
EOF
}

# ------------------------------------------------------------------------------
# Main Application Logic
# ------------------------------------------------------------------------------
main() {
    local target_name=""
    local dry_run=false

    # Parse command line options
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -n|--name)
                if [[ -n "${2:-}" ]]; then
                    target_name="$2"
                    shift 2
                else
                    log_error "Option '$1' requires an argument."
                    exit 1
                fi
                ;;
            -d|--dry-run)
                dry_run=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    log_info "Starting execution from: $SCRIPT_DIR"

    if [ "$dry_run" = true ]; then
        log_warn "Dry-run mode enabled. No changes will be made."
    fi

    if [[ -n "$target_name" ]]; then
        log_success "Hello, $target_name! Script executed successfully."
    else
        log_info "Running in default mode. Use --help for available options."
    fi
}

main "$@"
