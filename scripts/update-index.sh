#!/usr/bin/env bash
# ==============================================================================
# Script: update-index.sh
# Description: Automatically inspects scripts/*.sh metadata headers and regenerates
#              the scripts/index.md catalog table.
# Category: Utility
# Author: Heviane
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# Global Configurations
# ------------------------------------------------------------------------------
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
readonly INDEX_FILE="$SCRIPT_DIR/index.md"
readonly TEMP_FILE="$(mktemp "${TMPDIR:-/tmp}/index_md.XXXXXX")"

# ------------------------------------------------------------------------------
# Cleanup Hook
# ------------------------------------------------------------------------------
cleanup() {
    rm -f "$TEMP_FILE"
}
trap cleanup EXIT SIGINT SIGTERM

# ------------------------------------------------------------------------------
# Help / Usage Display
# ------------------------------------------------------------------------------
show_help() {
    cat << EOF
Usage: $(basename "${BASH_SOURCE[0]}") [options]

Options:
  -h, --help    Show this help message and exit
  -c, --check   Check if scripts/index.md is up-to-date without modifying it (exits 1 if outdated)

Examples:
  ./scripts/update-index.sh
  ./scripts/update-index.sh --check
EOF
}

# ------------------------------------------------------------------------------
# Metadata Extraction Helpers
# ------------------------------------------------------------------------------
extract_description() {
    local file="$1"
    local desc=""

    # Extract first line after Description: or Descrição:
    desc=$(grep -i -E "^#\s*(Description|Descrição):" "$file" | head -n 1 | sed -E 's/^#\s*(Description|Descrição):\s*//I')

    if [[ -z "$desc" ]]; then
        desc="No description provided."
    fi

    echo "$desc"
}

extract_category() {
    local file="$1"
    local cat_val=""

    # Extract Category: or Categoria: or Level: or Nível:
    cat_val=$(grep -i -E "^#\s*(Category|Categoria|Level|Nível):" "$file" | head -n 1 | sed -E 's/^#\s*(Category|Categoria|Level|Nível):\s*//I')

    if [[ -z "$cat_val" ]]; then
        cat_val="General"
    fi

    echo "$cat_val"
}

# ------------------------------------------------------------------------------
# Index Generation Logic
# ------------------------------------------------------------------------------
generate_markdown() {
    cat << 'EOF' > "$TEMP_FILE"
# 📂 Scripts

Esta pasta reúne scripts utilitários, exemplos práticos e templates para automação e estudos em Shell Script.

> 🤖 **Nota:** Este índice é mantido e gerado automaticamente pelo script [`update-index.sh`](./update-index.sh).

---

## 📜 Lista de Scripts Disponíveis

| Script | Descrição | Categoria |
| --- | --- | --- |
EOF

    local script_path
    local script_name
    local desc
    local cat_name

    # Loop through all .sh scripts in alphabetical order
    while IFS= read -r script_path; do
        [[ -f "$script_path" ]] || continue

        script_name="$(basename "$script_path")"
        desc="$(extract_description "$script_path")"
        cat_name="$(extract_category "$script_path")"

        echo "| [${script_name}](./${script_name}) | ${desc} | ${cat_name} |" >> "$TEMP_FILE"
    done < <(find "$SCRIPT_DIR" -maxdepth 1 -type f -name "*.sh" | sort)

    cat << 'EOF' >> "$TEMP_FILE"

---

## 🚀 Como Executar

No terminal (Linux, macOS ou Git Bash no Windows):

```bash
# Conceda permissão de execução (se necessário)
chmod +x scripts/hello-world.sh

# Execute o script desejado
./scripts/hello-world.sh
```

---

## 🔄 Atualizando este Índice

Para atualizar este arquivo automaticamente após criar ou editar scripts:

```bash
./scripts/update-index.sh
```
EOF
}

# ------------------------------------------------------------------------------
# Main Application Logic
# ------------------------------------------------------------------------------
main() {
    local check_mode=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -c|--check)
                check_mode=true
                shift
                ;;
            *)
                echo "Error: Unknown option $1" >&2
                show_help
                exit 1
                ;;
        esac
    done

    generate_markdown

    if [ "$check_mode" = true ]; then
        if [ ! -f "$INDEX_FILE" ]; then
            echo "❌ Error: $INDEX_FILE does not exist." >&2
            exit 1
        fi

        # Compare ignoring CRLF differences
        if diff -u -w -B "$INDEX_FILE" "$TEMP_FILE" >/dev/null 2>&1; then
            echo "✅ scripts/index.md is fully up-to-date."
            exit 0
        else
            echo "❌ Error: scripts/index.md is outdated. Run './scripts/update-index.sh' to synchronize." >&2
            exit 1
        fi
    else
        cp "$TEMP_FILE" "$INDEX_FILE"
        echo "✅ scripts/index.md updated successfully."
    fi
}

main "$@"
