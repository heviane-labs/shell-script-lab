# 🐙 Sincronização de Repositórios GitHub (`sync-github-repos.sh`)

> [!NOTE]
> **Aviso sobre Informações de Terceiros e Validade Temporal:**  
> As informações sobre limites de requisições, endpoints da REST API do GitHub e comandos de instalação de utilitários externos (`jq`, `gh`, `winget`, `brew`, `apt`) refletem as especificações vigentes no momento da elaboração deste guia (Outubro/2026). Políticas, versões e limites de serviços de terceiros podem sofrer alterações ao longo do tempo. Em caso de divergência ou comportamento inesperado, consulte sempre a [Documentação Oficial da REST API do GitHub](https://docs.github.com/rest).

O script [`sync-github-repos.sh`](../scripts/sync-github-repos.sh) automatiza o processo de clonagem e atualização em lote de repositórios do GitHub para uma determinada conta ou organização.

Ele foi construído para funcionar tanto de forma **interativa** (via assistente no terminal) quanto **programática** (via argumentos de linha de comando), com suporte a modo de simulação (*dry-run*), detecção automática de credenciais e paginação da API do GitHub.

---

## 🚀 Formas de Execução

### 1. Modo Interativo (Assistente no Terminal)
Recomendado para uso manual no dia a dia. Basta rodar o script sem nenhum argumento:

```bash
./scripts/sync-github-repos.sh
```

O script exibirá um menu numerado para:
1. Escolher a conta (`heviane`, `heviane-labs`, `heviane-learning` ou informar outra manualmente).
2. Selecionar o protocolo de rede (`HTTPS` ou `SSH`).
3. Confirmar ou customizar o diretório de destino local.

---

### 2. Modo Linha de Comando (CLI com Flags)
Ideal para automações, rotinas de backup ou quem prefere comandos diretos sem perguntas.

#### Opções Disponíveis (`--help`):
| Flag | Descrição | Valor Padrão |
| :--- | :--- | :--- |
| `-h, --help` | Exibe a mensagem de ajuda e encerra | - |
| `-t, --target <CONTA>` | Nome do usuário ou organização no GitHub | - |
| `-p, --protocol <PROTO>` | Protocolo de conexão: `https` ou `ssh` | `https` |
| `-o, --output-dir <DIR>` | Diretório local de destino dos clones | `../<CONTA>` |
| `-d, --dry-run` | Simula a execução sem clonar ou atualizar nada | `false` |

#### Exemplos de Uso:

* **Simulação de execução (Dry-Run):**
  Lista todos os repositórios que seriam clonados ou atualizados sem fazer nenhum download:
  ```bash
  ./scripts/sync-github-repos.sh --target heviane-labs --dry-run
  ```

* **Clonar/atualizar todos os repositórios de uma organização via HTTPS:**
  ```bash
  ./scripts/sync-github-repos.sh --target heviane-labs
  ```

* **Sincronizar via SSH especificando um diretório de destino:**
  ```bash
  ./scripts/sync-github-repos.sh --target heviane --protocol ssh --output-dir /e/Projetos/Backup
  ```

---

## 🧩 O que é o `jq` e Como Instalar?

### O que é?
O **[`jq`](https://jqlang.github.io/jq/)** é um utilitário de linha de comando leve e poderoso projetado para fatiar, filtrar e transformar dados no formato **JSON**. No ecossistema Shell, ele é o equivalente a um *"sed/awk voltado para JSON"*.

Como a API do GitHub responde em JSON, o script utiliza o `jq` para extrair de forma precisa as URLs dos repositórios (`clone_url` ou `ssh_url`).

> 💡 **Nota de Compatibilidade:** O script possui um mecanismo de *fallback* automático. Se o `jq` não estiver instalado, ele utiliza filtros via `grep` e `sed`. No entanto, ter o `jq` instalado garante maior robustez.

### Como Instalar:

* **Windows (via PowerShell):**
  ```powershell
  winget install jqlang.jq
  # ou via Chocolatey: choco install jq
  # ou via Scoop:      scoop install jq
  ```
* **No Dev Container deste repositório (Ubuntu):**
  O `jq` já vem instalado de fábrica na imagem Docker. Se estiver em outro ambiente Debian/Ubuntu:
  ```bash
  sudo apt-get update && sudo apt-get install -y jq
  ```
* **macOS:**
  ```bash
  brew install jq
  ```

---

## 🔑 Autenticação e Limites da API (Tokens)

Por padrão, a API do GitHub permite consultas anônimas a repositórios públicos. No entanto, existem diferenças fundamentais:

| Modo | Limite da API | Acesso a Repositórios |
| :--- | :--- | :--- |
| **Sem Token (Anônimo)** | **60 requisições / hora** por IP | Somente repositórios públicos |
| **Com Token Autenticado** | **5.000 requisições / hora** | Repositórios públicos e **privados** |

O script busca e aplica seu token automaticamente seguindo a ordem abaixo:

### Método 1: GitHub CLI (`gh`) — Recomendado
Se você tem o GitHub CLI (`gh`) configurado na sua máquina, o script detecta o token automaticamente através de `gh auth token`. Nenhuma configuração extra é necessária.

Se precisar se autenticar no `gh` em um novo computador:
```bash
gh auth login
```

### Método 2: Arquivo Local `.env`
Você pode salvar o token em um arquivo `.env` na raiz do projeto (copiando o `.env.example`):
```bash
cp .env.example .env
# Em seguida, edite o .env e adicione seu token
```
O script lerá o token automaticamente de lá, e o arquivo já está protegido no `.gitignore`.

### Método 3: Variável de Ambiente `GITHUB_TOKEN` (ou `~/.bashrc`)
Se preferir exportar manualmente ou configurar no seu `~/.bashrc`:
```bash
export GITHUB_TOKEN="ghp_seuTokenAqui..."
./scripts/sync-github-repos.sh --target heviane-labs
```

> 📖 Para um guia completo com passo a passo e testes de conferência para cada uma das opções, consulte o **[Guia de Autenticação e Tokens](./autenticacao-e-tokens.md)**.

---

## 🛡️ Segurança e Idempotência

* **Idempotente:** O script pode ser executado repetidamente com segurança. Se o repositório já existir na pasta de destino, ele executa um `git pull --ff-only` para atualizá-lo; se não existir, realiza o `git clone`.
* **Fim de Linha e Tratamento de Erros:** Segue rigorosamente o padrão `set -euo pipefail` e captura de encerramento via `trap cleanup`.

