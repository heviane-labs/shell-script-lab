#!/bin/bash

# ==============================================================================
# Script: script-to-clone-all-repositories.sh
# Descrição: Clona ou atualiza repositórios do GitHub organizando-os em pastas
#            específicas para cada conta/organização.
# Autor: Heviane
#
# Lembre-se de rodar dentro do terminal Git Bash no Windows.
# ==============================================================================

clear
echo "======================================================"
echo "         🐙 GitHub Repository Cloner"
echo "======================================================"
echo ""

# ------------------------------------------------------------------------------
# 1. Seleção da Conta (Organização ou Usuário)
# ------------------------------------------------------------------------------
echo "📌 Selecione a conta do GitHub"
echo "  1) heviane          (Profissional e Portifólio)"
echo "  2) heviane-labs     (Experimentos, protótipos e projetos em desenvolvimento)"
echo "  3) heviane-learning (Estudos, bootcamps, cursos e treinamentos)"
echo "  4) Informar outra conta manualmente"
read -p "Escolha [1-3] (Padrão: 1): " OPT_TARGET

case "$OPT_TARGET" in
    1)
        TARGET="heviane"
        ;;
	2)
	    TARGET="heviane-labs"
        ;;
	3)
	    TARGET="heviane-learning"
        ;;
    4)
        read -p "Digite o nome de usuário ou organização: " TARGET
        if [ -z "$TARGET" ]; then
            echo "❌ Nome não pode ser vazio. Operação cancelada."
            exit 1
        fi
        ;;
    *)
;
esac

echo ""

# ------------------------------------------------------------------------------
# 2. Seleção do Protocolo (HTTPS ou SSH)
# ------------------------------------------------------------------------------
echo "🔒 Selecione o protocolo de conexão:"
echo "  1) HTTPS  (Recomendado / Não exige chave SSH)"
echo "  2) SSH    (git@github.com:... / Requer chave configurada)"
read -p "Escolha [1-2] (Padrão: 1): " OPT_PROTO

case "$OPT_PROTO" in
    2)
        PROTOCOLO="ssh"
        URL_TYPE="ssh_url"
        ;;
    *)
        PROTOCOLO="https"
        URL_TYPE="clone_url"
        ;;
esac

# ------------------------------------------------------------------------------
# 3. Definição do Diretório de Destino
# ------------------------------------------------------------------------------
# Obtém a pasta onde o próprio script está armazenado (ex: E:/Projects/Github)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="${BASE_DIR}/${TARGET}"

echo ""
echo "======================================================"
echo "⚙️  Configuração selecionada:"
echo "   Conta:     $TARGET"
echo "   Protocolo: $(echo "$PROTOCOLO" | tr '[:lower:]' '[:upper:]')"
echo "   Destino:   $DEST_DIR"
echo "======================================================"
echo ""

# Cria a pasta de destino caso ela ainda não exista
if [ ! -d "$DEST_DIR" ]; then
    echo "📁 Criando diretório: '$DEST_DIR'..."
    mkdir -p "$DEST_DIR"
fi

# ------------------------------------------------------------------------------
# 4. Verificação do Perfil na API do GitHub (Usuário vs Organização)
# ------------------------------------------------------------------------------
echo "🔍 Verificando o perfil de '$TARGET' no GitHub..."
account_info=$(curl -s "https://api.github.com/users/${TARGET}")

if echo "$account_info" | grep -q '"message": *"Not Found"'; then
    echo "❌ Erro: Conta '$TARGET' não foi encontrada no GitHub."
    exit 1
fi

if echo "$account_info" | grep -q '"type": *"Organization"'; then
    API_ENDPOINT="orgs"
    echo "🏢 Conta identificada como: Organização"
else
    API_ENDPOINT="users"
    echo "👤 Conta identificada como: Usuário"
fi

# ------------------------------------------------------------------------------
# 5. Busca e Clonagem/Atualização dos Repositórios
# ------------------------------------------------------------------------------
PER_PAGE=100
PAGE=1

echo "📦 Buscando repositórios públicos..."

while : ; do
    response=$(curl -s "https://api.github.com/${API_ENDPOINT}/${TARGET}/repos?page=${PAGE}&per_page=${PER_PAGE}")

    # Verifica se atingiu limite de requisições ou outro erro da API
    if echo "$response" | grep -q '"message":'; then
        echo "⚠️ Mensagem da API do GitHub:"
        echo "$response" | sed -n 's/.*"message": *"\([^"]*\)".*/  -> \1/p'
        break
    fi

    # Filtra as URLs de acordo com o protocolo escolhido
    repositories=$(echo "$response" | awk -v campo="$URL_TYPE" '$0 ~ campo {print $2}' | sed -e 's/^"//g' -e 's/",$//g')

    # Se a página atual não retornar repositórios, encerra o loop
    [ -z "$repositories" ] && break

    for repo in $repositories; do
        repo_name=$(basename "$repo" .git)
        repo_path="${DEST_DIR}/${repo_name}"

        if [ -d "$repo_path" ]; then
            echo "🔄 Repositório '$repo_name' já existe. Atualizando com git pull..."
            git -C "$repo_path" pull
        else
            echo "📥 Clonando '$repo_name' em '$DEST_DIR'..."
            git clone "$repo" "$repo_path"
        fi
    done

    PAGE=$((PAGE + 1))
done

echo ""
echo "✅ Todos os repositórios foram processados com sucesso em:"
echo "   📂 $DEST_DIR"