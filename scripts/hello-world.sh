#!/usr/bin/env bash
# ==============================================================================
# Script: hello-world.sh
# Descrição: Primeiro script do laboratório demonstrando variáveis, shebang,
#            interpolação e códigos de saída.
# Autor: Heviane
# ==============================================================================

set -euo pipefail

# 1. Variáveis
MENSAGEM="Bem-vindo ao Laboratório de Shell Script!"
USUARIO="$(whoami 2>/dev/null || echo "$USER")"
DATA_HORA="$(date '+%d/%m/%Y às %H:%M:%S')"

# 2. Saída na tela
echo "=================================================="
echo "👋 $MENSAGEM"
echo "👤 Usuário ativo: $USUARIO"
echo "🕒 Executado em:  $DATA_HORA"
echo "📁 Diretório:     $PWD"
echo "=================================================="

echo "Dica: experimente editar este arquivo para criar seus próprios testes!"
exit 0
