# 📚 Documentação e Roadmap de Estudos

Bem-vindo à central de conhecimento do Laboratório de Shell. Este espaço organiza todo o conteúdo teórico, desde os conceitos mais básicos até os tópicos avançados, servindo como um guia completo para seus estudos.

---

## 🗺️ Roadmap de Estudos

Este é um guia sugerido para aprender Shell Script de forma progressiva.

### 🔰 Nível Iniciante: Os Fundamentos

O objetivo aqui é se sentir confortável no terminal e entender como os comandos básicos se conectam.

- [ ] **Conceitos Básicos:**
  - [ ] O que é Shell?

- [ ] **Comandos Essenciais de Navegação e Manipulação:**
  - [ ] Navegação: `ls`, `cd`, `pwd`.
  - [ ] Criação/Exclusão: `touch`, `mkdir`, `rm`, `rmdir`.
  - [ ] Cópia/Movimentação: `cp`, `mv`.
  - [ ] Visualização de Conteúdo: `cat`, `less`, `more`, `head`, `tail`.
- [ ] **Conceitos Chave do Terminal:**
  - [ ] **Pipes (`|`):** Conectar a saída de um comando à entrada de outro. Ex: `ls -l | grep ".md"`.
  - [ ] **Redirecionamento (`>`, `>>`):** Salvar a saída de um comando em um arquivo.
  - [ ] **Permissões (`chmod`):** Entender e alterar permissões, principalmente para tornar scripts executáveis (`chmod +x meu_script.sh`).
- [ ] **Seu Primeiro Script:**
  - [ ] **Shebang (`#!/bin/bash`):** O que é e por que usar.
  - [ ] **Comandos `echo`:** Imprimir texto na tela.
  - [ ] **Variáveis:** Como declarar (`VAR="valor"`) e usar (`echo $VAR`).
  - [ ] **Comentários (`#`):** Documentar seu código.

---

### 🛠️ Nível Intermediário: Construindo Lógica

Neste nível, você começa a criar scripts que tomam decisões e executam tarefas repetitivas.

- [ ] **Estruturas de Controle:**
  - [ ] **Condicionais:** `if`, `else`, `elif` e a sintaxe de teste `[[ ... ]]`.
  - [ ] **Laços de Repetição:** `for` para iterar sobre listas (arquivos, números) e `while` para executar algo enquanto uma condição for verdadeira.
  - [ ] **Estrutura `case`:** Uma alternativa mais limpa para múltiplos `if`s.
- [ ] **Funções:**
  - [ ] Como declarar e chamar funções para organizar e reutilizar código.
  - [ ] Passar argumentos para funções (`$1`, `$2`, ... `$@`).
- [ ] **Interação e Processamento de Dados:**
  - [ ] **Lendo input do usuário:** `read`.
  - [ ] **Substituição de Comando:** `VARIAVEL=$(comando)` para capturar a saída de um comando em uma variável.
  - [ ] **Processamento de Texto:** O trio essencial `grep` (buscar), `sed` (editar) e `cut` (recortar).
  - [ ] **Exit Codes (`$?`):** Verificar se o comando anterior foi executado com sucesso.

---

### 🚀 Nível Avançado: Automação e Maestria

Aqui você domina o Shell para criar ferramentas poderosas e automatizar tarefas complexas.

- [ ] **Tópicos Avançados:**
  - [ ] **Expressões Regulares (Regex):** Usar padrões complexos com `grep`, `sed` e `awk`.
  - [ ] **Arrays:** Armazenar e manipular listas de dados.
  - [ ] **Scripting com `awk`:** Uma linguagem poderosa para processamento de texto estruturado.
  - [ ] **Gerenciamento de Processos:** `ps`, `kill`, `jobs`, `fg`, `bg`.
  - [ ] **Sinais e `trap`:** Capturar eventos do sistema (como `Ctrl+C`) para finalizar um script de forma segura.
  - [ ] **Argumentos de Linha de Comando:** Processar opções e argumentos de forma robusta com `getopts`.
- [ ] **Boas Práticas e Segurança:**
  - [ ] Usar `set -euo pipefail` para criar scripts mais seguros e previsíveis.
  - [ ] Evitar armadilhas comuns e vulnerabilidades de segurança (injeção de código).
  - [ ] Escrever código legível e de fácil manutenção.

---
