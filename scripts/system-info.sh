#!/usr/bin/env bash
# ==============================================================================
# Script: system-info.sh
# Descrição: Coleta e exibe informações básicas do ambiente e do sistema.
# Autor: Heviane
# ==============================================================================

set -euo pipefail

echo "=================================================="
echo "          💻 Informações do Sistema"
echo "=================================================="

# Sistema Operacional e Kernel
echo -e "\n📌 Sistema Operacional:"
uname -a 2>/dev/null || echo "Informação não disponível via uname"

# Shell em Execução
echo -e "\n🐚 Shell Atual:"
echo "Caminho: ${SHELL:-Não definido}"
if [ -n "${BASH_VERSION:-}" ]; then
    echo "Versão do Bash: $BASH_VERSION"
fi

# Usuário e Diretório Inicial
echo -e "\n👤 Usuário:"
echo "Nome: ${USER:-$(whoami)}"
echo "Home: ${HOME:-$USERPROFILE}"

# Uso de Disco (se df estiver disponível)
if command -v df >/dev/null 2>&1; then
    echo -e "\n💾 Uso de Disco:"
    df -h . 2>/dev/null || true
fi

echo -e "\n=================================================="
echo "Relatório concluído com sucesso."
exit 0
