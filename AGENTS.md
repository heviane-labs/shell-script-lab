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
  * **Third-Party Service & API Disclaimer Rule:** Whenever documentation (`docs/*.md`) references third-party services, APIs (e.g., GitHub REST API), external CLI tools (`jq`, `gh`), rate limits, or package managers (`winget`, `apt`, `brew`), you MUST ALWAYS include a GitHub alert callout (`> [!NOTE]`) warning that third-party specifications, endpoints, and policies may change over time, stating the date of reference and linking to the official vendor documentation.

---

## 🛡️ 2. Universal Golden Rules (Inviolable)

1. **Human-in-the-Loop (Mandatory Prior Approval):** The agent MUST ALWAYS present the plan and request explicit approval from the developer before modifying files, executing environment-altering commands, or making commits/pushes.
2. **Anti-Lazy Code (Complete Implementation):** Never omit code or documentation with ellipses or shortcut comments (`// ... rest of code ...`). Deliver complete, functional, and ready-to-run content.
3. **Surgical Modification (Minimal Diff):** Make focused, minimal edits. Do not rewrite entire files or modules just to adjust specific lines, and preserve existing formatting and conventions.
4. **Evidence-Based Completion:** Validate your delivery by running automated test suites (BATS, syntax checks, linters) before considering work finished. Never declare a task complete without verifiable terminal output.
5. **Dependency Parsimony & Security:** Do not install third-party tools, packages, or libraries without prior approval and compatibility verification.
6. **Security First (Zero Secrets & Host Privacy):** Never commit or expose credentials, API keys, tokens, certificates, sensitive personal data, or absolute local host paths (e.g., drive letters or internal user directory structures). In public documentation, tests, and examples, strictly use relative paths, environment variables, or conceptual placeholders (e.g., `<workspace-root>`, `<cloud-vault>`).
7. **Living Documentation in Commit Cycle:** Keep documentation, index catalogs, and test specifications perfectly synchronized within the same commit cycle as code changes.
8. **Defensive Asset Preservation:** Never overwrite or delete configuration files, inventories, or governance scripts without explicit consent.
9. **Cross-Platform Integrity & Encoding:** Rigorously respect line endings (LF) and encoding conventions from `.editorconfig`. PowerShell scripts (`.ps1`) must be saved with UTF-8 BOM (`0xEF, 0xBB, 0xBF`) for native Windows PowerShell 5.1 compatibility.
10. **Documentation Trigger in New Directories (README Heuristic):** When creating any significant new directory (modules, templates, test suites, or utilities), the agent MUST ALWAYS evaluate the need for an explanatory `README.md`. Avoid mute directories across the repository.
11. **Single-Topic Living Dossier Pattern:** When conducting reviews, multi-model audits, or governance improvements, keep each dossier strictly single-topic and atomic. Create the plan in `reviews/active/[SEQ]-[DATE]-[TARGET]-[TOPIC]-plano-mestre.md` at minute zero and maintain it alive until archived in `reviews/archive/`.
12. **Strict Scaffolding Isolation (Sandbox Hygiene):** Automated or manual tests of code generators, bootstrap scripts, or scaffolding must NEVER be executed from the root of an active repository. Run exclusively within an isolated temporary sandbox (`$TMPDIR` or `/tmp`), with compulsory cleanup (`trap` / `teardown`).
13. **Multi-Shell Interoperability in CLI Commands (Safe CLI Chaining):** When executing terminal commands on Windows, respect compatibility with PowerShell 5.1 and 7+, NEVER using `&&` (invalid in native PS 5.1). Use `; if ($?) { ... }` for safe conditional chaining.
14. **Bidirectional Documentation Linking (Graph Interconnection):** When creating any new documentation or governance file (`README.md`, `SPEC.md`, `ADR.md`), map adjacent artifacts and add cross-cutting bidirectional links to avoid orphan documents.
15. **Canonical Placeholders & Scaffold Parity:** In templates, boilerplates, or generators, strictly use canonical uppercase snake-case bracketed placeholders `[UPPER_SNAKE_CASE]`. Ensure zero orphan placeholders remain in active delivered code or documentation.

---

## 🐚 3. Shell Scripting Standards (Bash Best Practices)

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

## 📂 4. Directory Structure

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

## 🧪 5. Testing & Verification Standards

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

4. **Catalog Index Synchronization:**
   * Whenever a script is created, modified, or removed, the scripts index catalog must be synchronized:

   ```bash
   ./scripts/update-index.sh
   ```

   Verify with `bash scripts/update-index.sh --check`.

---

## 💡 6. Canonical Script Template

When generating a new script, use [`scripts/template.sh`](./scripts/template.sh) as the baseline structure.

---

## 📝 7. Commit Standards (Conventional Commits)

All commit messages created or suggested by AI agents must strictly follow the **Conventional Commits** specification:

```text
<type>(<scope>): <short description in english imperative>

[optional body explaining motivation]

[optional footer referencing issues, e.g. Closes #12]
```

### Allowed Types:

* `feat`: New shell script, CLI utility, or capability.
* `fix`: Bug fix in existing shell scripts or test suites.
* `refactor`: Structural refactoring without altering CLI behaviour.
* `test`: Adding or updating BATS unit tests or syntax checks.
* `docs`: Documentation, study notes, or guide updates.
* `chore`: Maintenance of linters, devcontainers, or build tasks.
* `perf`: Performance optimizations in script execution or I/O.

### Recommended Canonical Scopes:

* `scripts`: Automation and utility shell scripts (`scripts/`).
* `tests`: BATS automated unit test suites (`tests/`).
* `docs`: Architecture, study materials, and guidelines (`docs/`).
* `ci`: GitHub Actions workflows and ShellCheck automation.
* `docker`: DevContainer, Dockerfile, or containerized environments.

### Mandatory Rules for Atomicity and Language:

1. **Atomic Commits (Single-Purpose):** Every commit MUST serve a single logical purpose. Never mix script refactoring with documentation or test updates.
2. **Clean Revertability:** Commits must be self-contained so that `git revert <hash>` undoes the change cleanly without collateral effects.
3. **Always Green State:** No intermediate commit should break the repository. ShellCheck, syntax check (`bash -n`), and BATS tests must pass on every commit.
4. **Canonical English & Imperative Mood:** All commit messages MUST be written in **English** using imperative verbs (`add`, `fix`, `sync`, `enforce`, `bump`, `polish`, `remove`).
