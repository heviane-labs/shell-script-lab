#!/usr/bin/env bash
# ==============================================================================
# Script: sync-github-repos.sh
# Description: Clones or synchronizes all GitHub repositories for a given account or organization.
# Category: Automation
# Author: Heviane
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# Global Configurations & Constants
# ------------------------------------------------------------------------------
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly SCRIPT_NAME

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR

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
# Cleanup Hook
# ------------------------------------------------------------------------------
cleanup() {
    local exit_code=$?
    if [ "$exit_code" -ne 0 ]; then
        log_error "Execution terminated with exit code $exit_code."
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

Clones or updates all public/private GitHub repositories for a target user or organization.

Options:
  -h, --help               Show this help message and exit
  -t, --target ACCOUNT     Specify GitHub username or organization
  -p, --protocol PROTO     Protocol to use: 'https' (default) or 'ssh'
  -o, --output-dir DIR     Destination directory for cloned repositories
  -d, --dry-run            Simulate operations without cloning or pulling

Examples:
  ./$SCRIPT_NAME --target heviane-labs --protocol https
  ./$SCRIPT_NAME --target heviane --dry-run
  ./$SCRIPT_NAME           # Launches interactive wizard
EOF
}

# ------------------------------------------------------------------------------
# Helper Functions
# ------------------------------------------------------------------------------
is_token_valid() {
    local t="$1"
    [[ -n "$t" ]] || return 1
    local check
    check="$(curl -s -H "Authorization: Bearer $t" "https://api.github.com/user" | grep -E '"message": *"Bad credentials"' || true)"
    if [[ -n "$check" ]]; then
        return 1
    fi
    return 0
}

get_token() {
    # 1. Environment variable (e.g. from ~/.bashrc or terminal export)
    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
        if is_token_valid "$GITHUB_TOKEN"; then
            echo "$GITHUB_TOKEN"
            return 0
        else
            log_warn "Active GITHUB_TOKEN is invalid or revoked (Bad credentials)."
        fi
    fi

    # 2. Local .env file in repository root or current directory
    local env_token=""
    if [[ -f "$SCRIPT_DIR/../.env" ]]; then
        env_token="$(grep -E '^GITHUB_TOKEN=' "$SCRIPT_DIR/../.env" | head -n 1 | cut -d '=' -f 2- | tr -d '"' | tr -d "'" | tr -d '\r')"
    elif [[ -f "$PWD/.env" ]]; then
        env_token="$(grep -E '^GITHUB_TOKEN=' "$PWD/.env" | head -n 1 | cut -d '=' -f 2- | tr -d '"' | tr -d "'" | tr -d '\r')"
    fi

    if [[ -n "$env_token" ]]; then
        if is_token_valid "$env_token"; then
            echo "$env_token"
            return 0
        else
            log_warn "Token in .env is invalid or revoked (Bad credentials)."
        fi
    fi

    # 3. GitHub CLI system credentials (gh auth login)
    if command -v gh >/dev/null 2>&1; then
        local gh_token
        gh_token="$(gh auth token 2>/dev/null || true)"
        if [[ -n "$gh_token" ]] && is_token_valid "$gh_token"; then
            log_info "Using valid credentials from GitHub CLI (gh)." >&2
            echo "$gh_token"
            return 0
        fi
    fi

    echo ""
}

extract_repo_urls() {
    local json="$1"
    local field="$2"

    if command -v jq >/dev/null 2>&1; then
        echo "$json" | jq -r ".[].${field} // empty"
    else
        # Fallback regex extraction when jq is not installed.
        # '|| true' ensures pipefail doesn't trigger when zero matches are found on empty pages.
        echo "$json" | grep -E "\"${field}\"\s*:" | sed -E "s/.*\"${field}\"\s*:\s*\"([^\"]+)\".*/\1/" || true
    fi
}

detect_account_type() {
    local target="$1"
    local token="$2"
    local auth_header=()
    if [[ -n "$token" ]]; then
        auth_header=(-H "Authorization: Bearer $token")
    fi
    local account_info

    account_info="$(curl -s "${auth_header[@]}" "https://api.github.com/users/${target}")"

    if echo "$account_info" | grep -q '"message": *"Not Found"'; then
        log_error "GitHub account or organization '$target' not found."
        return 1
    fi

    if echo "$account_info" | grep -q '"type": *"Organization"'; then
        echo "orgs"
    else
        echo "users"
    fi
}

# ------------------------------------------------------------------------------
# Interactive Wizard
# ------------------------------------------------------------------------------
interactive_wizard() {
    echo "======================================================"
    echo "         🐙 GitHub Repository Cloner"
    echo "======================================================"
    echo ""

    # 1. Target Account Selection
    echo "📌 Select GitHub Account:"
    echo "  1) heviane          (Professional & Portfolio)"
    echo "  2) heviane-labs     (Experiments, prototypes & lab)"
    echo "  3) heviane-learning (Studies & training)"
    echo "  4) Enter custom username or organization"
    read -r -p "Choose [1-4] (Default: 1): " opt_target

    case "$opt_target" in
        2) TARGET="heviane-labs" ;;
        3) TARGET="heviane-learning" ;;
        4)
            read -r -p "Enter GitHub username or organization: " TARGET
            if [[ -z "$TARGET" ]]; then
                log_error "Account name cannot be empty."
                exit 1
            fi
            ;;
        *) TARGET="heviane" ;;
    esac

    # 2. Protocol Selection
    echo ""
    echo "🔒 Select Connection Protocol:"
    echo "  1) HTTPS  (Recommended, no SSH key required)"
    echo "  2) SSH    (git@github.com:... / Requires configured SSH key)"
    read -r -p "Choose [1-2] (Default: 1): " opt_proto

    case "$opt_proto" in
        2) PROTOCOL="ssh" ;;
        *) PROTOCOL="https" ;;
    esac

    # 3. Output Directory
    local default_base_dir
    default_base_dir="$(cd "$SCRIPT_DIR/../.." && pwd)"
    local default_dest="${default_base_dir}/${TARGET}"

    echo ""
    echo "📁 Destination Directory:"
    read -r -p "Path [Default: $default_dest]: " custom_dest
    OUTPUT_DIR="${custom_dest:-$default_dest}"
}

# ------------------------------------------------------------------------------
# Main Application Logic
# ------------------------------------------------------------------------------
main() {
    local TARGET=""
    local PROTOCOL="https"
    local OUTPUT_DIR=""
    local DRY_RUN=false
    local IS_INTERACTIVE=true

    # Parse CLI Arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -t|--target)
                TARGET="${2:-}"
                IS_INTERACTIVE=false
                shift 2
                ;;
            -p|--protocol)
                PROTOCOL="${2:-https}"
                IS_INTERACTIVE=false
                shift 2
                ;;
            -o|--output-dir)
                OUTPUT_DIR="${2:-}"
                IS_INTERACTIVE=false
                shift 2
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # Run wizard if not specified via CLI
    if [ "$IS_INTERACTIVE" = true ] && [[ -z "$TARGET" ]]; then
        interactive_wizard
    fi

    if [[ -z "$TARGET" ]]; then
        log_error "Target account is required. Use --target or run interactively."
        exit 1
    fi

    # Set default destination if not provided
    if [[ -z "$OUTPUT_DIR" ]]; then
        local base_parent
        base_parent="$(cd "$SCRIPT_DIR/../.." && pwd)"
        OUTPUT_DIR="${base_parent}/${TARGET}"
    fi

    # Normalize Windows backslashes to POSIX forward slashes
    OUTPUT_DIR="${OUTPUT_DIR//\\//}"

    local url_field
    if [[ "$PROTOCOL" == "ssh" ]]; then
        url_field="ssh_url"
    else
        url_field="clone_url"
    fi

    echo ""
    echo "======================================================"
    echo "⚙️  Configuration:"
    echo "   Target Account:  $TARGET"
    echo "   Protocol:        $(echo "$PROTOCOL" | tr '[:lower:]' '[:upper:]')"
    echo "   Destination:     $OUTPUT_DIR"
    echo "   Dry Run Mode:    $DRY_RUN"
    echo "======================================================"
    echo ""

    # Create destination directory if not in dry-run
    if [ "$DRY_RUN" = false ] && [ ! -d "$OUTPUT_DIR" ]; then
        log_info "Creating destination directory: '$OUTPUT_DIR'..."
        mkdir -p "$OUTPUT_DIR"
    fi

    local token
    token="$(get_token)"
    local auth_header=()
    if [[ -n "$token" ]]; then
        auth_header=(-H "Authorization: Bearer $token")
    fi

    log_info "Verifying profile for '$TARGET' on GitHub..."
    local api_endpoint
    if ! api_endpoint="$(detect_account_type "$TARGET" "$token")"; then
        exit 1
    fi

    log_info "Account identified as: $api_endpoint"
    log_info "Fetching repositories list..."

    local per_page=100
    local page=1
    local total_processed=0

    # Determine authenticated user to allow listing private repos
    local auth_user=""
    if [[ -n "$token" ]]; then
        auth_user="$(curl -s "${auth_header[@]}" "https://api.github.com/user" | grep -E '"login":' | head -n 1 | sed -E 's/.*"login": *"([^"]*)".*/\1/' || true)"
    fi

    # Build the endpoint URL (including private repos when authorized)
    local repos_api_url=""
    if [[ "$api_endpoint" == "orgs" ]]; then
        repos_api_url="https://api.github.com/orgs/${TARGET}/repos?type=all"
    elif [[ -n "$auth_user" && "${TARGET,,}" == "${auth_user,,}" ]]; then
        repos_api_url="https://api.github.com/user/repos?affiliation=owner&visibility=all"
    else
        repos_api_url="https://api.github.com/users/${TARGET}/repos?type=all"
    fi

    while : ; do
        local response
        response="$(curl -s "${auth_header[@]}" "${repos_api_url}&page=${page}&per_page=${per_page}")"

        # Check for rate limit or API error
        if echo "$response" | grep -q '"message":'; then
            local api_msg
            api_msg="$(echo "$response" | sed -n -E 's/.*"message": *"([^"]*)".*/\1/p' | head -n 1)"
            if [[ -n "$api_msg" ]]; then
                log_warn "GitHub API response: $api_msg"
                break
            fi
        fi

        local repo_urls
        repo_urls="$(extract_repo_urls "$response" "$url_field")"

        if [[ -z "$repo_urls" ]]; then
            break
        fi

        while IFS= read -r repo_url; do
            [[ -n "$repo_url" ]] || continue

            local repo_name
            repo_name="$(basename "$repo_url" .git)"
            local repo_path="${OUTPUT_DIR}/${repo_name}"

            total_processed=$((total_processed + 1))

            if [ -d "$repo_path" ]; then
                if [ "$DRY_RUN" = true ]; then
                    log_info "[DRY-RUN] Would update '$repo_name' (git pull in $repo_path)"
                else
                    log_info "Updating '$repo_name' via git pull..."
                    git -C "$repo_path" pull --ff-only || log_warn "Pull failed for '$repo_name', skipping..."
                fi
            else
                if [ "$DRY_RUN" = true ]; then
                    log_info "[DRY-RUN] Would clone '$repo_name' from $repo_url to $repo_path"
                else
                    log_info "Cloning '$repo_name'..."
                    git clone "$repo_url" "$repo_path" || log_warn "Clone failed for '$repo_name', skipping..."
                fi
            fi
        done <<< "$repo_urls"

        page=$((page + 1))
    done

    echo ""
    log_success "Completed processing $total_processed repository/repositories."
    log_info "Location: $OUTPUT_DIR"
}

main "$@"
