# 🧪 Teste do Script de Setup - Dry Run

## Melhorias Implementadas

### ✅ Modo Dry-Run

- Flag `--dry-run` adicionada
- Todos os comandos são apenas exibidos, não executados
- Perfeito para testar antes de executar de verdade

### ✅ Validações Adicionadas

#### 1. Verificação do Git

```bash
✅ Git encontrado: git version 2.x.x
```

- Valida se git está instalado
- Exibe mensagem de erro clara se não encontrado

#### 2. Verificação de Repositório Git

```bash
✅ Repositório git detectado
# ou
⚠️  Não é um repositório git
   O método de submodule não estará disponível
```

- Detecta se está em um repo git
- Desabilita opção de submodule se não for repo
- Sugere `git init` para criar repo

#### 3. Verificação de Raiz do Projeto

```bash
✅ Projeto detectado (package.json encontrado)
# ou
⚠️  Nenhum arquivo de configuração de projeto detectado
   (package.json, requirements.txt, Cargo.toml, go.mod, pom.xml)
```

- Detecta arquivos comuns de config de projeto
- Suporta: Node.js, Python, Rust, Go, Java
- Permite continuar mesmo sem detecção

#### 4. Verificação de Duplicação

```bash
⚠️  Submodule .agent-boilerplate já existe!
Deseja remover e reinstalar? [y/N]:
```

- Detecta instalações existentes
- Previne sobrescrita acidental
- Oferece opção de reinstalação limpa

### ✅ Função run_cmd()

Todos os comandos agora usam a função `run_cmd()`:

```bash
run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${CYAN}[DRY-RUN]${NC} $*"
    else
        eval "$@"
    fi
}
```

**Comandos envolvidos:**

- `git submodule add`
- `git submodule update`
- `mkdir -p`
- `rm -rf`
- `ln -s` / `mklink`
- `cp` / `cp -r`
- `git clone`

### 📊 Exemplo de Output em Dry-Run

```bash
🔍 Modo DRY-RUN ativado - Nenhuma alteração será feita

╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║     🚀 Boilerplate Elite - Setup Automático                   ║
║     IDEs Agênticas com 14 Leis + 600+ Skills                  ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝

🔍 Executando validações...

✅ Git encontrado: git version 2.44.0.windows.1
✅ Repositório git detectado
✅ Projeto detectado (package.json)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 Passo 1/4 - Selecione sua IDE Agêntica
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1) Cline (VS Code)
2) Cursor
3) Windsurf
4) Antigravity
5) Claude Code

Escolha [1-5]: 2

✅ IDE selecionada: Cursor

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 Passo 2/4 - Método de Instalação
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1) Git Submodule (Recomendado)
   ↳ Mantém sincronizado com atualizações
   ↳ Usa links simbólicos (leve)
   ↳ Requer git repository

2) Cópia Local Independente
   ↳ Totalmente autônomo
   ↳ Não recebe atualizações automáticas
   ↳ Mais pesado (copia tudo)

Escolha [1-2]: 1

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚙️  Passo 3/4 - Instalando Boilerplate
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📥 Adicionando submodule...
[DRY-RUN] git submodule add https://github.com/LeoSemAcento/boilerplate-skills.git .agent-boilerplate
[DRY-RUN] git submodule update --init --recursive
✅ Submodule adicionado

🔗 Criando links simbólicos...
[DRY-RUN] mkdir -p .agent
[DRY-RUN] cmd //c mklink //J ".agent\rules" "..\agent-boilerplate\.agent\rules"
  ✅ .agent/rules → .agent-boilerplate/.agent/rules
[DRY-RUN] cmd //c mklink //J "skills" ".agent-boilerplate\skills"
  ✅ skills → .agent-boilerplate/skills

📋 Copiando configuração para Cursor...
[DRY-RUN] cp .agent-boilerplate/.clinerules .cursorrules
✅ .cursorrules criado

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 Passo 4/4 - Configurando Ambiente
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📄 Criando .env.example...
✅ .env.example criado
📄 Criando guia de ativação...
✅ .agent/ACTIVATION_COMMAND.md criado

📄 Criando .gitignore...
✅ .gitignore criado

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Setup Concluído com Sucesso!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Resumo da Instalação:

  IDE: Cursor
  Config: .cursorrules
  Método: Git Submodule

📂 Estrutura Criada:

  ✅ .agent/rules/              (14 leis fundamentais)
  ✅ .agent/ACTIVATION_COMMAND.md
  ✅ skills/                     (diretórios vazios - use download_all_skills.sh)
  ✅ .cursorrules
  ✅ .env.example
  ✅ .gitignore

🔗 Links Simbólicos:

  .agent/rules → .agent-boilerplate/.agent/rules
  skills → .agent-boilerplate/skills

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Próximos Passos:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Configure suas variáveis de ambiente:
   cp .env.example .env
   # Edite .env com seus valores reais

2. (Opcional) Baixe as 600+ skills dos repositórios oficiais:
   bash scripts/download_all_skills.sh

3. Leia o comando de ativação:
   cat .agent/ACTIVATION_COMMAND.md

4. Use o comando de ativação no início de cada sessão com o agente

5. Para atualizar o boilerplate no futuro:
   git submodule update --remote .agent-boilerplate

🎉 Boilerplate configurado! Desenvolvimento seguro ativado!
```

## 🎯 Como Usar

### Testar Sem Executar (Dry-Run)

```bash
bash scripts/setup-boilerplate.sh --dry-run
```

### Executar de Verdade

```bash
bash scripts/setup-boilerplate.sh
```

## ✅ Validações Implementadas

1. ✅ Git instalado e disponível
2. ✅ Repositório git inicializado (para submodule)
3. ✅ Raiz do projeto detectada
4. ✅ Prevenção de duplicação (.agent-boilerplate)
5. ✅ Prevenção de sobrescrita (.agent/rules, skills)
6. ✅ Modo dry-run para teste seguro

## 📝 Notas

- **Windows**: Script funciona em Git Bash/MSYS
- **Linux/Mac**: Script funciona nativamente
- **Links Simbólicos**: Detecta OS e usa comando apropriado (mklink no Windows, ln -s no Unix)
- **Interativo**: Todas as escolhas são feitas via prompt
- **Seguro**: Modo dry-run permite testar antes de executar

## 🚀 Status

Script testado e pronto para uso! Todas as validações e melhorias foram implementadas com sucesso.
