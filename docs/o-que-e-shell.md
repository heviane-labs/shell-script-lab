# Shell

Imagine que o sistema operacional (Windows, macOS, Linux) é um "reino".
E você, o usuário, quer dar ordens, mas não fala a língua do "núcleo" (kernel) do reino. Você precisa de um intérprete.

## O que é SHELL?

É o intérprete. É o nome genérico para qualquer programa que pega seus comandos de texto e os traduz em ações que o sistema operacional entende. Ele é a "casca" (shell) que envolve o núcleo do sistema.
Exemplos: `bash`, `zsh`, `powershell`, etc.

## O que é CLI (Command Line Interface)?

CLI (Command Line Interface) é uma forma de interagir com um programa de computador usando apenas texto. Em vez de clicar em botões e menus com o mouse (como em uma Interface Gráfica - GUI), você digita comandos para dizer ao programa o que fazer. Muitos programas que usamos no dia a dia, como `git`, `npm` ou `docker`, são CLIs.

## Shell vs CLI (Command Line Interface)

Shell e CLI não são a mesma coisa.

Pense da seguinte forma:

- **Shell (como bash, zsh, powershell, etc)** é o ambiente, o programa principal que está sempre rodando no seu terminal. Ele é o intérprete que lê o que você digita, entende o comando e o executa.
- **CLI (Command Line Interface)** é qualquer programa que você executa dentro desse ambiente.

Analogia Simples:

Imagine que o Shell é o seu navegador de internet (como Chrome ou Firefox).
Os programas de linha de comando são os sites que você acessa (como Google, Wikipedia, etc.).
Você usa o navegador (o Shell) para rodar e interagir com os sites (os programas de linha de comando). `git`, por exemplo, é um programa de linha de comando poderoso, mas ele não é um Shell. Você o executa dentro de um Shell.

**Em resumo**: Todo Shell é um programa de linha de comando, mas nem todo programa de linha de comando é um Shell. O Shell é o programa específico que serve como seu intérprete de comandos.

## Tipos de Shell

Agora, existem diferentes tipos de intérpretes, cada um com seu estilo e habilidades:

- **Bash (Bourne Again Shell)**: É o intérprete clássico, poderoso e mais comum no mundo Linux, tendo sido também o padrão no macOS por muitos anos. Quase todo script e documentação para Linux/macOS funciona nativamente com ele, tornando-o o padrão de fato para scripts portáveis.

- **Zsh (Z Shell)**: É um *superset* do Bash, moderno e com recursos aprimorados. Inclui autocompletar inteligente, correção de digitação, temas visuais e um vasto ecossistema de plugins (famoso pelo framework "Oh My Zsh"). É o shell padrão nas versões recentes do macOS e muito popular entre desenvolvedores.

- **PowerShell**: Intérprete moderno e poderoso da Microsoft. Ao contrário de Bash e Zsh que operam com fluxos de texto, o PowerShell trabalha diretamente com **objetos**. Embora nativo do Windows, é multiplataforma (roda também em Linux e macOS) e excelente para automação e administração de sistemas.

- **Command Prompt (CMD ou `cmd.exe`)**: O shell legado do Windows. É mais simples e mantido primariamente para compatibilidade com scripts antigos (`.bat`). Para novas tarefas no Windows, o PowerShell é quase sempre a melhor escolha.

- **fish (Friendly Interactive Shell)**: Focado em ser amigável e funcional logo após a instalação, sem necessidade de configurações complexas. Traz sugestões de comandos baseadas no histórico e realce de sintaxe (*syntax highlighting*) ativados por padrão.

## Resumo da Diferença

| Tipo de Shell | O que é? | Principal Característica | Onde é mais comum? |
| --- | --- | --- | --- |
| Shell | Categoria/Conceito | O programa que interpreta seus comandos | Todos os sistemas |
| Bash | Implementação de Shell | O padrão "clássico", universal e confiável | Maioria das distribuições Linux |
| Zsh | Implementação de Shell | Moderno, customizável e com autocompletar avançado | macOS recentes |
| PowerShell | Implementação de Shell | Orientado a objetos, focado em automação | Windows |

> **Em suma**:
> - Shell é o tipo de programa.
> - Bash, Zsh e PowerShell são implementações específicas desse tipo de programa.
