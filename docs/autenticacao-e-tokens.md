# 🔐 Guia de Autenticação e Gerenciamento Seguro de Tokens

Este guia documenta as **3 formas recomendadas** de gerenciar e armazenar tokens de acesso pessoal (PAT) ou credenciais do GitHub no seu ambiente de desenvolvimento, além dos métodos de **conferência e validação** para cada uma delas.

---

## 🚨 A Regra de Ouro da Segurança

> **NUNCA versione arquivos contendo tokens, senhas ou chaves de API no Git.**  
> Mesmo em repositórios privados, segredos commitados podem vazar em clones, forks, branches ou logs públicos.

---

## 🧭 As 3 Opções de Armazenamento

```plaintext
┌─────────────────────────────────────────────────────────────────────────────┐
│                           ONDE SALVAR MEU TOKEN?                            │
├──────────────────────────┬──────────────────────────┬───────────────────────┤
│ Opção 1: GitHub CLI (gh) │ Opção 2: Arquivo .env    │ Opção 3: ~/.bashrc    │
├──────────────────────────┼──────────────────────────┼───────────────────────┤
│ 🥇 Mais Segura e Prática │ 🥈 Padrão por Projeto    │ 🥉 Global de Terminal │
│ Não salva texto em disco │ Fica no projeto          │ Fica na pasta de home │
│ Gerenciado pelo Windows  │ Protegido por .gitignore │ Carrega a cada sessão │
└──────────────────────────┴──────────────────────────┴───────────────────────┘
```

---

### 🥇 Opção 1: GitHub CLI (`gh`) — *Padrão Ouro (Recomendado)*

Esta é a opção mais segura porque **você não cria nenhum arquivo de texto com senhas no computador**. O token é gerenciado de forma segura pelo cofre de credenciais do sistema operacional (Windows Credential Manager).

#### Como configurar:
Execute no terminal uma única vez:
```bash
gh auth login
```
*Siga as instruções na tela escolhendo `GitHub.com` ➔ `HTTPS` ➔ Login via navegador.*

#### Como conferir:
1. **Verificar status da autenticação:**
   ```bash
   gh auth status
   ```
   *Retorno esperado:* Deve mostrar `Logged in to github.com account <seu-usuario>`.
2. **Exibir o token ativo em memória:**
   ```bash
   gh auth token
   ```
   *Retorno esperado:* O hash do token será exibido.

> 💡 Nossos scripts (como o [`sync-github-repos.sh`](../scripts/sync-github-repos.sh)) detectam o `gh auth token` automaticamente sem você precisar fazer nada.

---

### 🥈 Opção 2: Arquivo `.env` Local — *Padrão de Projetos*

Ideal para projetos onde você quer que o token fique restrito à pasta do projeto, sem depender de ferramentas instaladas no sistema.

#### Como configurar:
1. Copie o arquivo de exemplo disponibilizado na raiz:
   ```bash
   cp .env.example .env
   ```
2. Abra o arquivo `.env` e adicione seu token:
   ```bash
   GITHUB_TOKEN="ghp_seuTokenAqui..."
   ```
3. O arquivo `.env` já está listado no [`.gitignore`](../.gitignore), garantindo que ele nunca será enviado para o repositório remoto.

#### Como conferir:
1. **Verificar se o `.env` existe e contém o token:**
   ```bash
   cat .env
   ```
2. **Garantir que o `.env` está mesmo sendo ignorado pelo Git:**
   ```bash
   git status
   ```
   *Retorno esperado:* O arquivo `.env` **não** pode aparecer na lista de arquivos rastreados ou untracked.

> 💡 O script [`sync-github-repos.sh`](../scripts/sync-github-repos.sh) lê o arquivo `.env` automaticamente caso ele exista.

---

### 🥉 Opção 3: Arquivo de Perfil `~/.bashrc` — *Global para o Usuário*

Ideal quando você quer que qualquer terminal Git Bash aberto no seu computador já tenha a variável `$GITHUB_TOKEN` carregada na memória, sem precisar configurar projeto por projeto.

#### Como configurar:
1. Abra o arquivo de perfil do Git Bash com um editor:
   ```bash
   nano ~/.bashrc
   ```
2. Adicione a seguinte linha ao final do arquivo:
   ```bash
   export GITHUB_TOKEN="ghp_seuTokenAqui..."
   ```
3. Salve o arquivo (`Ctrl + O`, `Enter`) e saia (`Ctrl + X`).
4. Recarregue o arquivo na sessão atual:
   ```bash
   source ~/.bashrc
   ```

#### Como conferir (Passo a Passo de Verificação):
Para ter 100% de certeza de que a Opção 3 está funcionando:

1. **Checar se o arquivo salvou a linha:**
   ```bash
   tail -n 5 ~/.bashrc
   ```
   *Retorno esperado:* A linha `export GITHUB_TOKEN="ghp_..."` deve aparecer entre as últimas linhas.

2. **Checar se a variável está na memória do terminal atual:**
   ```bash
   echo "$GITHUB_TOKEN"
   ```
   *Retorno esperado:* O token deve ser impresso na tela.

3. **O "Teste de Fogo" da Persistência:**
   * Feche completamente o Git Bash.
   * Abra uma **nova janela** do Git Bash.
   * Digite novamente:
     ```bash
     echo "$GITHUB_TOKEN"
     ```
   * *Se o token for exibido na nova janela, significa que a configuração está permanente e funcionará para sempre nesta máquina.*

4. **Teste de Conexão Real com a API do GitHub:**
   ```bash
   curl -s -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/user | grep '"login":'
   ```
   *Retorno esperado:* `"login": "seu-usuario"`.

---

## 📊 Tabela Comparativa

| Critério | Opção 1: GitHub CLI (`gh`) | Opção 2: Arquivo `.env` | Opção 3: `~/.bashrc` |
| :--- | :--- | :--- | :--- |
| **Onde fica salvo?** | Windows Credential Manager | Na pasta raiz do projeto | `C:\Users\<usuario>\.bashrc` |
| **Risco de vazar no Git?** | **Zero** (fora do repo) | **Muito baixo** (no `.gitignore`) | **Zero** (fora do repo) |
| **Frequência de configuração** | Uma única vez por máquina | Uma vez por projeto | Uma única vez por máquina |
| **Escopo** | Todos os repositórios | Apenas este projeto | Todo terminal Git Bash |
| **Ideal para** | Máquinas de desenvolvimento pessoal | Servidores, CI/CD, ambientes isolados | Usuários frequentes de Bash no Windows |

---

## 🚨 O que fazer se um Token vazar acidentalmente?

Se por engano você colar um token em um chat público, commit ou screenshot:

1. Acesse imediatamente: **GitHub** ➔ **Settings** ➔ **Developer Settings** ➔ **Personal access tokens**.
2. Localize o token comprometido na lista e clique em **Delete / Revoke**.
3. Gere um novo token e atualize seu `.env` ou `~/.bashrc`.
*(Tokens revogados deixam de funcionar instantaneamente em todo o mundo).*
