# 📂 Scripts

Esta pasta reúne scripts utilitários, exemplos práticos e templates para automação e estudos em Shell Script.

---

## 📜 Lista de Scripts Disponíveis

| Script | Descrição | Nível |
| --- | --- | --- |
| [script-to-clone-all-repositories.sh](./script-to-clone-all-repositories.sh) | Clona ou atualiza em lote todos os repositórios de uma conta/organização do GitHub. | Intermediário |
| [template.sh](./template.sh) | Modelo canônico para novos scripts com `set -euo pipefail`, logs coloridos e tratamento de sinais (`trap`). | Padrão / Base |
| [hello-world.sh](./hello-world.sh) | Primeiro script de exemplo com variáveis, interpolação e verificação de saída. | Iniciante |
| [system-info.sh](./system-info.sh) | Coleta e exibe informações básicas do sistema, shell ativo e recursos de disco. | Iniciante |

---

## 🚀 Como Executar

No terminal (Linux, macOS ou Git Bash no Windows):

```bash
# Conceda permissão de execução (se necessário)
chmod +x scripts/hello-world.sh

# Execute o script
./scripts/hello-world.sh
```

> **Dica:** Para novos scripts, use sempre o [template.sh](./template.sh) como ponto de partida para manter segurança e consistência no código.
