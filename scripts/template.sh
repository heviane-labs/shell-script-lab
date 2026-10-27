#!/usr/bin/env bash
# ==============================================================================
# Script: template.sh
# Descrição: Template base profissional com boas práticas de segurança,
#            tratamento de erros e padronização para scripts Bash.
# Autor: Heviane
# ==============================================================================

# Boas práticas de segurança do Bash:
# -e: encerra o script imediatamente se um comando falhar
# -u: trata variáveis não declaradas como erro fatal
# -o pipefail: garante que falhas intermediárias em pipes (|) sejam propagadas
set -euo pipefail

# ------------------------------------------------------------------------------
# Configurações e Variáveis Globais
# ------------------------------------------------------------------------------
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ------------------------------------------------------------------------------
# Funções Utilitárias de Log
# ------------------------------------------------------------------------------
log_info() {
    echo -e "\033[1;34m[INFO]\033[0m $*"
}

log_success() {
    echo -e "\033[1;32m[SUCESSO]\033[0m $*"
}

log_warn() {
    echo -e "\033[1;33m[AVISO]\033[0m $*" >&2
}

log_error() {
    echo -e "\033[1;31m[ERRO]\033[0m $*" >&2
}

# ------------------------------------------------------------------------------
# Função de Limpeza (Executada no encerramento ou interrupção)
# ------------------------------------------------------------------------------
cleanup() {
    local exit_code=$?
    # Adicione aqui remoção de arquivos temporários se necessário
    if [ "$exit_code" -ne 0 ]; then
        log_error "O script foi interrompido com o código de saída $exit_code."
    fi
    exit "$exit_code"
}
trap cleanup EXIT SIGINT SIGTERM

# ------------------------------------------------------------------------------
# Exibição de Ajuda
# ------------------------------------------------------------------------------
show_help() {
    cat << EOF
Uso: $SCRIPT_NAME [opções]

Opções:
  -h, --help       Exibe esta mensagem de ajuda e encerra
  -n, --name NOME  Especifica um nome para execução

Exemplo:
  ./$SCRIPT_NAME --name "Estudante"
EOF
}

# ------------------------------------------------------------------------------
# Função Principal (main)
# ------------------------------------------------------------------------------
main() {
    local target_name=""

    # Parsing de argumentos
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -n|--name)
                if [[ -n "${2:-}" ]]; then
                    target_name="$2"
                    shift 2
                else
                    log_error "A opção '$1' requer um argumento."
                    exit 1
                fi
                ;;
            *)
                log_error "Opção desconhecida: $1"
                show_help
                exit 1
                ;;
        esac
    done

    log_info "Iniciando execução em: $SCRIPT_DIR"
    
    if [[ -n "$target_name" ]]; then
        log_success "Olá, $target_name! Script executado com sucesso."
    else
        log_info "Executando em modo padrão. Use --help para opções adicionais."
    fi
}

# Inicia a execução chamando a função main com todos os argumentos
main "$@"
