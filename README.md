# 🧪 Laboratório de Shell Script (Automação e CLI)

Bem-vindo ao laboratório de estudos dedicado ao aprendizado e aprofundamento em **Shell Script** e ferramentas de linha de comando.

Este repositório serve como um ambiente de testes, documentação e desenvolvimento assistido por IA para dominar o terminal, centralizando conhecimento, exemplos práticos e scripts úteis.

---

## 📚 Conteúdo

* ➡️ **[Conceitos Fundamentais e Teoria](./docs/index.md)**: Roadmap de aprendizado do iniciante ao avançado.
* ➡️ **[Catálogo de Scripts](./scripts/index.md)**: Todos os scripts disponíveis, templates e exemplos.
* ➡️ **[Guia de Autenticação e Tokens](./docs/autenticacao-e-tokens.md)**: Como gerenciar segredos e tokens com segurança.
* ➡️ **[Diretrizes de IA (AGENTS.md)](./AGENTS.md)**: Padrões de engenharia e regras de desenvolvimento.

---

## 🛠️ Ambiente de Desenvolvimento (Dev Container)

Para executar e testar scripts com total segurança e sem alterar sua máquina host, este repositório conta com configuração de **Dev Container** ([`.devcontainer/`](./.devcontainer/)):

1. Instale a extensão **Dev Containers** no VS Code.
2. Abra o projeto e selecione **"Reopen in Container"**.
3. O ambiente subirá em Linux Ubuntu 24.04 com **Bash moderno, ShellCheck, shfmt, BATS, curl e jq** prontos para uso.

---

## 🧪 Qualidade e Testes Automatizados

* **Análise Estática (ShellCheck):**
  ```bash
  shellcheck scripts/*.sh
  ```
* **Testes Unitários (BATS):**
  ```bash
  bats tests/
  ```

A pipeline do GitHub Actions valida automaticamente a sintaxe, os linters e os testes a cada `push` ou `pull_request`.

---

## 🪝 Sincronização Automática do Catálogo

O índice de scripts em [`scripts/index.md`](./scripts/index.md) é gerado automaticamente a partir dos cabeçalhos dos scripts.

* **Se você desenvolve com IA:** O agente sincroniza o índice automaticamente seguindo as diretrizes do [`AGENTS.md`](./AGENTS.md).
* **Para desenvolvimento manual:** Para que o Git atualize o índice automaticamente antes de cada commit, ative os hooks locais uma única vez:

```bash
git config core.hooksPath .githooks
```
Ou execute manualmente quando desejar:
```bash
./scripts/update-index.sh
```
