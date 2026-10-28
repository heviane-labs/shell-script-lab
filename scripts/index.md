# 📂 Scripts

Esta pasta reúne scripts utilitários, exemplos práticos e templates para automação e estudos em Shell Script.

> 🤖 **Nota:** Este índice é mantido e gerado automaticamente pelo script [`update-index.sh`](./update-index.sh).

---

## 📜 Lista de Scripts Disponíveis

| Script | Descrição | Categoria |
| --- | --- | --- |
| [clone-github-repos.sh](./clone-github-repos.sh) | Clones or synchronizes all GitHub repositories for a given account or organization. | Automation |
| [hello-world.sh](./hello-world.sh) | Introductory script demonstrating variables, shebang, interpolation, | Basics |
| [system-info.sh](./system-info.sh) | Gathers and displays basic system environment, user, and disk metrics. | System |
| [template.sh](./template.sh) | Canonical production-grade baseline template with robust error | Template |
| [update-index.sh](./update-index.sh) | Automatically inspects scripts/*.sh metadata headers and regenerates | Utility |

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

Para atualizar este arquivo manualmente após criar ou editar scripts:

```bash
./scripts/update-index.sh
```

### 🪝 Automação com Git Hook (Recomendado)

Para que o Git sincronize este índice automaticamente sempre que você fizer um `git commit` manual, ative os hooks locais uma única vez:

```bash
git config core.hooksPath .githooks
```
