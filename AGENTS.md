# 🤖 AI Agent Guidelines & Engineering Standards

Welcome! This repository (`shell-script-lab`) is an automated learning and development environment for Shell scripting and CLI tools. All AI assistants, agents, and contributors operating in this codebase must adhere strictly to the following standards.

---

## 🚨 1. CRITICAL RULE: English-Only for Code & Technical Artifacts

**ALL code, scripts, tests, configuration files, and git commits MUST ALWAYS be written in English.**

* **Scripts & Code:**
  * Function names, variable names, and parameters must be in English (e.g., `parse_args`, `is_directory`, `user_name`).
  * Inline comments, block comments, and docstrings must be in English.
  * User-facing terminal messages, log outputs, help messages (`--help`), and error outputs must be in English.
* **Tests:**
  * Test descriptions and assertions must be in English (e.g., `@test "prints help message when --help flag is passed"`).
* **Git Commits:**
  * All commit messages must follow Conventional Commits in English (e.g., `feat(scripts): add network health monitor`, `fix(cli): handle empty target error`).
* **Documentation (`docs/`):**
  * Educational notes directed to human learners may be bilingual or in Portuguese when updating existing study guides, but **all embedded code snippets and script names must remain in English**.

---

## 🛡️ 2. Shell Scripting Standards (Bash Best Practices)

Every script must follow these safety and quality requirements:

### A. Shebang & Safety Flags
* Use portable bash shebang:
  ```bash
  #!/usr/bin/env bash
  ```
* Enforce strict error handling at the very beginning of the script:
  ```bash
  set -euo pipefail
  ```
  * `-e`: Exit immediately if any command exits with a non-zero status.
  * `-u`: Treat unset/unbound variables as an error and exit immediately.
  * `-o pipefail`: Return the exit status of the last command in the pipeline that failed.

### B. Cleanups and Signals
* Always handle script terminations and cleanup temporary files using `trap`:
  ```bash
  cleanup() {
    local exit_code=$?
    # Remove temporary files if created
    exit "$exit_code"
  }
  trap cleanup EXIT SIGINT SIGTERM
  ```

### C. Variables & Functions
* **Variable Scope:** Always declare variables inside functions with `local`.
  ```bash
  my_function() {
    local file_path="$1"
    local count=0
  }
  ```
* **Quotes:** ALWAYS quote variable references to prevent word splitting and glob expansion:
  ```bash
  # Good
  rm -f "$target_file"
  if [[ -d "$dir_path" ]]; then ...

  # Bad
  rm -f $target_file
  ```
* **Naming Conventions:**
  * Constants / Global read-only: `SCREAMING_SNAKE_CASE` (e.g., `readonly SCRIPT_DIR="..."`).
  * Local variables & function names: `snake_case` (e.g., `local file_name`, `process_file()`).

### D. CLI Interface & Dry-Run Support
* Every non-trivial script must support:
  * `-h, --help`: Displays usage, options, and examples.
  * `--dry-run`: Mandatory for scripts performing destructive or file-modifying operations (deletions, bulk moves, external API writes).

---

## 📂 3. Directory Structure

```plaintext
shell-script-lab/
├── .devcontainer/        # VS Code Dev Container (Docker environment)
├── .github/
│   └── workflows/
│       └── lint.yml      # CI pipeline: ShellCheck & BATS automated test runner
├── docs/                 # Theoretical learning material and study guides
├── scripts/              # Executable shell scripts (.sh)
│   ├── template.sh       # Canonical script template to follow
│   └── ...
├── tests/                # BATS automated test files (.bats)
│   └── ...
├── .gitignore
├── .shellcheckrc         # Linter configuration
├── AGENTS.md             # This guideline file
├── LICENSE
└── README.md
```

---

## 🧪 4. Testing & Verification Standards

Before completing any task, an AI agent must verify:

1. **Syntax Check:**
   Ensure the script passes bash syntax validation:
   ```bash
   bash -n scripts/your-script.sh
   ```
2. **Static Analysis (ShellCheck):**
   Scripts must pass ShellCheck without errors or warnings:
   ```bash
   shellcheck scripts/your-script.sh
   ```
3. **Automated Unit Tests (BATS):**
   * Every new script must have a corresponding test file in `tests/<script-name>.bats`.
   * Run the test suite:
   ```bash
   bats tests/
   ```

---

## 💡 5. Canonical Script Template

When generating a new script, use [`scripts/template.sh`](file:///e:/Projects/GitHub_Old2/heviane-labs/shell-script-lab/scripts/template.sh) as the baseline structure.
