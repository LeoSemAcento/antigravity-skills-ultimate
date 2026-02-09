#!/bin/bash
# Setup automático do Boilerplate Elite para IDEs Agênticas
# Autor: Breno Vieira Silva - Lion Lab Academy
# Uso: bash setup-boilerplate.sh [--dry-run]

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

BOILERPLATE_REPO="https://github.com/LeoSemAcento/boilerplate-skills.git"
TEMP_DIR=".temp-boilerplate-setup"

# Modo dry-run
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo -e "${YELLOW}🔍 Modo DRY-RUN ativado - Nenhuma alteração será feita${NC}\n"
fi

# Função para executar comando ou simular
run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${CYAN}[DRY-RUN]${NC} $*"
    else
        eval "$@"
    fi
}

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║     🚀 Boilerplate Elite - Setup Automático                   ║"
echo "║     IDEs Agênticas com 14 Leis + 600+ Skills                  ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# VALIDAÇÕES PRELIMINARES
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${BLUE}🔍 Executando validações...${NC}\n"

# 1. Verificar se git está disponível
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git não encontrado!${NC}"
    echo -e "${YELLOW}Por favor, instale o Git: https://git-scm.com/downloads${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Git encontrado: $(git --version)${NC}"

# 2. Verificar se está em um repositório git (para método submodule)
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Não é um repositório git${NC}"
    echo -e "${YELLOW}   O método de submodule não estará disponível${NC}"
    echo -e "${YELLOW}   Use 'git init' primeiro ou escolha método de cópia local${NC}\n"
    GIT_REPO=false
else
    echo -e "${GREEN}✅ Repositório git detectado${NC}"
    GIT_REPO=true
fi

# 3. Verificar se está na raiz de um projeto (tem algum arquivo de config comum)
if [ ! -f "package.json" ] && [ ! -f "requirements.txt" ] && [ ! -f "Cargo.toml" ] && [ ! -f "go.mod" ] && [ ! -f "pom.xml" ]; then
    echo -e "${YELLOW}⚠️  Nenhum arquivo de configuração de projeto detectado${NC}"
    echo -e "${YELLOW}   (package.json, requirements.txt, Cargo.toml, go.mod, pom.xml)${NC}"
    read -p "Deseja continuar mesmo assim? [y/N]: " continue_anyway
    if [[ "$continue_anyway" != "y" && "$continue_anyway" != "Y" ]]; then
        echo -e "${RED}❌ Setup cancelado${NC}"
        exit 0
    fi
    echo ""
else
    echo -e "${GREEN}✅ Projeto detectado${NC}"
fi

# 4. Verificar se já existe .agent-boilerplate
if [ -d ".agent-boilerplate" ]; then
    echo -e "${YELLOW}⚠️  Submodule .agent-boilerplate já existe!${NC}"
    read -p "Deseja remover e reinstalar? [y/N]: " remove_existing
    if [[ "$remove_existing" != "y" && "$remove_existing" != "Y" ]]; then
        echo -e "${RED}❌ Setup cancelado${NC}"
        exit 0
    fi
    echo ""
fi

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Verificar se já existe instalação
if [ -d ".agent/rules" ] || [ -d "skills" ] || [ -d ".agent-boilerplate" ]; then
    echo -e "${YELLOW}⚠️  Detectada instalação existente!${NC}"
    echo ""
    echo "Arquivos encontrados:"
    [ -d ".agent/rules" ] && echo "  - .agent/rules/"
    [ -d "skills" ] && echo "  - skills/"
    [ -d ".agent-boilerplate" ] && echo "  - .agent-boilerplate/"
    echo ""
    read -p "Deseja sobrescrever? [y/N]: " overwrite
    if [[ "$overwrite" != "y" && "$overwrite" != "Y" ]]; then
        echo -e "${RED}❌ Setup cancelado${NC}"
        exit 0
    fi
    echo ""
fi

# Passo 1: Escolher IDE
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📝 Passo 1/4 - Selecione sua IDE Agêntica${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "1) Cline (VS Code)"
echo "2) Cursor"
echo "3) Windsurf"
echo "4) Antigravity"
echo "5) Claude Code"
echo ""
read -p "Escolha [1-5]: " ide_choice

case $ide_choice in
    1) 
        IDE_NAME="Cline"
        CONFIG_FILE=".clinerules"
        ;;
    2) 
        IDE_NAME="Cursor"
        CONFIG_FILE=".cursorrules"
        ;;
    3) 
        IDE_NAME="Windsurf"
        CONFIG_FILE=".windsurfrules"
        ;;
    4) 
        IDE_NAME="Antigravity"
        CONFIG_FILE=".antigravity"
        ;;
    5) 
        IDE_NAME="Claude Code"
        CONFIG_FILE=".clauderules"
        ;;
    *) 
        echo -e "${RED}❌ Opção inválida${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}✅ IDE selecionada: $IDE_NAME${NC}\n"

# Passo 2: Escolher método de instalação
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📦 Passo 2/4 - Método de Instalação${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ "$GIT_REPO" = true ]; then
    echo "1) Git Submodule (Recomendado)"
    echo "   ↳ Mantém sincronizado com atualizações"
    echo "   ↳ Usa links simbólicos (leve)"
    echo "   ↳ Requer git repository"
    echo ""
    echo "2) Cópia Local Independente"
    echo "   ↳ Totalmente autônomo"
    echo "   ↳ Não recebe atualizações automáticas"
    echo "   ↳ Mais pesado (copia tudo)"
    echo ""
    read -p "Escolha [1-2]: " install_method
else
    echo -e "${YELLOW}⚠️  Git Submodule não disponível (não é um repositório git)${NC}"
    echo ""
    echo "2) Cópia Local Independente"
    echo "   ↳ Totalmente autônomo"
    echo "   ↳ Não recebe atualizações automáticas"
    echo "   ↳ Mais pesado (copia tudo)"
    echo ""
    read -p "Pressione ENTER para continuar com cópia local..." 
    install_method="2"
fi

if [[ "$install_method" != "1" && "$install_method" != "2" ]]; then
    echo -e "${RED}❌ Opção inválida${NC}"
    exit 1
fi

echo ""

# Passo 3: Executar instalação
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}⚙️  Passo 3/4 - Instalando Boilerplate${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ "$install_method" == "1" ]; then
    # Método 1: Git Submodule
    echo -e "${YELLOW}📥 Adicionando submodule...${NC}"
    
    # Verificar se já existe
    if [ -d ".agent-boilerplate" ]; then
        echo -e "${YELLOW}⚠️  Removendo submodule existente...${NC}"
        git submodule deinit -f .agent-boilerplate 2>/dev/null || true
        git rm -rf .agent-boilerplate 2>/dev/null || true
        rm -rf .agent-boilerplate
        rm -rf .git/modules/.agent-boilerplate
    fi
    
    # Adicionar submodule
    run_cmd git submodule add "$BOILERPLATE_REPO" .agent-boilerplate
    run_cmd git submodule update --init --recursive
    echo -e "${GREEN}✅ Submodule adicionado${NC}\n"
    
    # Criar estrutura .agent
    echo -e "${YELLOW}🔗 Criando links simbólicos...${NC}"
    run_cmd mkdir -p .agent
    
    # Link para rules
    if [ -L ".agent/rules" ] || [ -d ".agent/rules" ]; then
        run_cmd rm -rf .agent/rules
    fi
    
    # Detectar OS para comando de link apropriado
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        # Windows (Git Bash/MSYS)
        run_cmd cmd //c mklink //J ".agent\\rules" "..\\agent-boilerplate\\.agent\\rules"
    else
        # Unix/Linux/Mac
        run_cmd ln -s ../.agent-boilerplate/.agent/rules .agent/rules
    fi
    echo -e "${GREEN}  ✅ .agent/rules → .agent-boilerplate/.agent/rules${NC}"
    
    # Link para skills
    if [ -L "skills" ] || [ -d "skills" ]; then
        run_cmd rm -rf skills
    fi
    
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        run_cmd cmd //c mklink //J "skills" ".agent-boilerplate\\skills"
    else
        run_cmd ln -s .agent-boilerplate/skills skills
    fi
    echo -e "${GREEN}  ✅ skills → .agent-boilerplate/skills${NC}\n"
    
    # Copiar arquivo de configuração
    echo -e "${YELLOW}📋 Copiando configuração para $IDE_NAME...${NC}"
    run_cmd cp .agent-boilerplate/.clinerules "$CONFIG_FILE"
    echo -e "${GREEN}✅ $CONFIG_FILE criado${NC}\n"
    
else
    # Método 2: Cópia Local
    echo -e "${YELLOW}📥 Clonando repositório temporariamente...${NC}"
    
    # Remover temp dir se existir
    [ -d "$TEMP_DIR" ] && run_cmd rm -rf "$TEMP_DIR"
    
    # Clonar
    run_cmd git clone --depth 1 "$BOILERPLATE_REPO" "$TEMP_DIR"
    echo -e "${GREEN}✅ Repositório clonado${NC}\n"
    
    # Copiar estruturas
    echo -e "${YELLOW}📂 Copiando arquivos...${NC}"
    
    # Copiar .agent/rules
    run_cmd mkdir -p .agent
    if [ -d ".agent/rules" ]; then
        run_cmd rm -rf .agent/rules
    fi
    run_cmd cp -r "$TEMP_DIR/.agent/rules" .agent/
    echo -e "${GREEN}  ✅ .agent/rules copiado${NC}"
    
    # Copiar skills
    if [ -d "skills" ]; then
        run_cmd rm -rf skills
    fi
    run_cmd cp -r "$TEMP_DIR/skills" .
    echo -e "${GREEN}  ✅ skills copiado${NC}"
    
    # Copiar scripts
    if [ ! -d "scripts" ]; then
        run_cmd mkdir -p scripts
    fi
    run_cmd cp "$TEMP_DIR/scripts/index_skills.py" scripts/ 2>/dev/null || true
    run_cmd cp "$TEMP_DIR/scripts/download_all_skills.sh" scripts/ 2>/dev/null || true
    echo -e "${GREEN}  ✅ scripts copiados${NC}"
    
    # Copiar arquivo de configuração
    run_cmd cp "$TEMP_DIR/.clinerules" "$CONFIG_FILE"
    echo -e "${GREEN}  ✅ $CONFIG_FILE criado${NC}\n"
    
    # Limpar
    echo -e "${YELLOW}🧹 Limpando arquivos temporários...${NC}"
    run_cmd rm -rf "$TEMP_DIR"
    echo -e "${GREEN}✅ Limpeza concluída${NC}\n"
fi

# Passo 4: Criar arquivos auxiliares
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📝 Passo 4/4 - Configurando Ambiente${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Criar .env.example
if [ ! -f ".env.example" ]; then
    echo -e "${YELLOW}📄 Criando .env.example...${NC}"
    cat > .env.example << 'EOF'
# ════════════════════════════════════════════════════════════════════
# .env.example - Variáveis de Ambiente do Projeto
# ════════════════════════════════════════════════════════════════════
# ⚠️  LEI 13: ISOLAMENTO DE AMBIENTES
#
# NUNCA use dados de produção em desenvolvimento!
# Use prefixos claros: DEV_, STAGING_, PROD_
# Mantenha bancos de dados completamente separados
# ════════════════════════════════════════════════════════════════════

# Ambiente
APP_ENV=development
NODE_ENV=development

# ──────────────────────────────────────────────────────────────────
# 🔐 AUTENTICAÇÃO E SESSÃO (Leis 01, 05, 07)
# ──────────────────────────────────────────────────────────────────

# Session Secret (Gere com: openssl rand -base64 32)
SESSION_SECRET=change-me-to-a-secure-random-string

# Iron Session (Gere com: openssl rand -base64 32)
IRON_SESSION_PASSWORD=change-me-to-a-secure-random-string-minimum-32-chars

# ──────────────────────────────────────────────────────────────────
# 🗄️  DATABASE (Leis 03, 13)
# ──────────────────────────────────────────────────────────────────

# PostgreSQL/Supabase
DEV_DATABASE_URL=postgresql://user:password@localhost:5432/myapp_dev
DEV_DATABASE_POOL_MAX=10

# ⚠️  NUNCA use Service Role no frontend (Lei 01)
DEV_SUPABASE_URL=https://xxxxx.supabase.co
DEV_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
DEV_SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# ──────────────────────────────────────────────────────────────────
# 🤖 AI / LLM PROVIDERS (Lei 04)
# ──────────────────────────────────────────────────────────────────

# OpenAI
DEV_OPENAI_API_KEY=sk-...

# Anthropic
DEV_ANTHROPIC_API_KEY=sk-ant-...

# Google Gemini
DEV_GOOGLE_API_KEY=AI...

# ──────────────────────────────────────────────────────────────────
# 💳 PAGAMENTOS (Lei 04)
# ──────────────────────────────────────────────────────────────────

# Stripe
DEV_STRIPE_PUBLISHABLE_KEY=pk_test_...
DEV_STRIPE_SECRET_KEY=sk_test_...
DEV_STRIPE_WEBHOOK_SECRET=whsec_...

# ──────────────────────────────────────────────────────────────────
# 🔒 CRIPTOGRAFIA (Lei 04)
# ──────────────────────────────────────────────────────────────────

# Encryption Key (Gere com: openssl rand -base64 32)
ENCRYPTION_KEY=your-base64-url-safe-encryption-key-here

# ──────────────────────────────────────────────────────────────────
# 📧 EMAIL / COMUNICAÇÃO
# ──────────────────────────────────────────────────────────────────

# SendGrid / Mailgun / Resend
DEV_EMAIL_API_KEY=
DEV_EMAIL_FROM=noreply@example.com

# ──────────────────────────────────────────────────────────────────
# 🌐 APLICAÇÃO
# ──────────────────────────────────────────────────────────────────

# URLs
DEV_APP_URL=http://localhost:3000
DEV_API_URL=http://localhost:8000

# Ports
PORT=3000
API_PORT=8000

# ──────────────────────────────────────────────────────────────────
# 📊 OBSERVABILIDADE
# ──────────────────────────────────────────────────────────────────

# Sentry
DEV_SENTRY_DSN=

# Logging Level
LOG_LEVEL=debug

# ════════════════════════════════════════════════════════════════════
# 🚨 IMPORTANTE: 
# 1. Copie este arquivo para .env (git ignore já configurado)
# 2. Nunca commite o arquivo .env
# 3. Use prefixos diferentes para cada ambiente (DEV_, STAGING_, PROD_)
# 4. API Keys devem ser criptografadas antes de salvar no banco (Lei 04)
# 5. Valide todas as variáveis críticas no startup
# ════════════════════════════════════════════════════════════════════
EOF
    echo -e "${GREEN}✅ .env.example criado${NC}"
else
    echo -e "${YELLOW}⚠️  .env.example já existe, pulando...${NC}"
fi

# Criar ACTIVATION_COMMAND.md
echo -e "${YELLOW}📄 Criando guia de ativação...${NC}"
mkdir -p .agent
cat > .agent/ACTIVATION_COMMAND.md << 'EOF'
# 🚀 Comando de Ativação do Agente

## Para Usar o Boilerplate Corretamente

Antes de iniciar qualquer tarefa de desenvolvimento, **cole este comando** no chat com o agente:

```
🔒 CARREGAMENTO DE CONTEXTO OBRIGATÓRIO

Antes de qualquer ação:

1. Leia TODAS as 14 leis em `.agent/rules/` (ordem numérica)
2. Analise o arquivo de configuração da IDE (`.clinerules`, `.cursorrules`, etc)
3. Verifique quais skills são relevantes através do YAML Frontmatter
4. Aplique as restrições inegociáveis de cada lei relevante

Confirme que você:
- ✅ Leu as 14 leis
- ✅ Compreendeu as restrições de segurança (Leis 01, 03, 04, 07)
- ✅ Está pronto para seguir os padrões estabelecidos

Responda com: "✅ Sistema de leis carregado. Pronto para desenvolvimento seguro."
```

## Por Que Isso é Necessário?

As IDEs agênticas nem sempre carregam automaticamente os arquivos de configuração. Este comando garante que:

1. **Segurança**: O agente não vai expor credenciais (Lei 01, 04, 07)
2. **Arquitetura**: Código seguirá Clean Architecture (Lei 06)
3. **Multi-tenancy**: Proteção contra vazamento de dados (Lei 03)
4. **Performance**: Código async-first (Lei 02)
5. **Qualidade**: Testes e documentação adequados (Leis 10, 14)

## Atalho Rápido

Se preferir, use a versão curta:

```
📚 Carregue: .agent/rules/ (14 leis) + configuração da IDE
```

## Quando Usar

Use **sempre** que:

- ✅ Iniciar uma nova sessão de desenvolvimento
- ✅ O agente sugerir código que viola as leis
- ✅ Começar uma nova feature ou módulo
- ✅ Trabalhar com autenticação, banco de dados ou APIs

## Verificação Rápida

Se o agente propor código que:

- ❌ Usa `SUPABASE_SERVICE_ROLE_KEY` no frontend → **VIOLAÇÃO LEI 01**
- ❌ Aceita `company_id` do request body → **VIOLAÇÃO LEI 03**
- ❌ Salva API keys em texto puro → **VIOLAÇÃO LEI 04**
- ❌ Usa código síncrono em FastAPI → **VIOLAÇÃO LEI 02**

**PARE** e reforce o comando de ativação.

## Exemplo de Uso

```
👤 Você: [Cole o comando de ativação acima]

🤖 Agente: ✅ Sistema de leis carregado. Pronto para desenvolvimento seguro.

👤 Você: Crie uma rota de API para autenticação OAuth

🤖 Agente: [Gera código seguindo Leis 01, 03, 05, 07, 11]
```

---

**Dica Pro**: Salve o comando de ativação em um snippet da sua IDE para acesso rápido!
EOF
echo -e "${GREEN}✅ .agent/ACTIVATION_COMMAND.md criado${NC}\n"

# Adicionar ao .gitignore se não existir
if [ ! -f ".gitignore" ]; then
    echo -e "${YELLOW}📄 Criando .gitignore...${NC}"
    cat > .gitignore << 'EOF'
# Environment variables
.env
.env.local
.env.*.local

# Python
__pycache__/
*.py[cod]
*$py.class
venv/
env/

# Node
node_modules/
npm-debug.log*

# IDEs
.vscode/
.idea/
*.swp

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/
EOF
    echo -e "${GREEN}✅ .gitignore criado${NC}\n"
else
    echo -e "${YELLOW}⚠️  .gitignore já existe, verificando entradas...${NC}"
    
    # Adicionar entradas essenciais se não existirem
    grep -q "^.env$" .gitignore || echo ".env" >> .gitignore
    grep -q "^.env.local$" .gitignore || echo ".env.local" >> .gitignore
    echo -e "${GREEN}✅ .gitignore verificado${NC}\n"
fi

# Finalização
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Setup Concluído com Sucesso!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}📦 Resumo da Instalação:${NC}"
echo ""
echo -e "  IDE: ${GREEN}$IDE_NAME${NC}"
echo -e "  Config: ${GREEN}$CONFIG_FILE${NC}"
echo -e "  Método: ${GREEN}$([ "$install_method" == "1" ] && echo "Git Submodule" || echo "Cópia Local")${NC}"
echo ""
echo -e "${CYAN}📂 Estrutura Criada:${NC}"
echo ""
echo "  ✅ .agent/rules/              (14 leis fundamentais)"
echo "  ✅ .agent/ACTIVATION_COMMAND.md"
echo "  ✅ skills/                     (diretórios vazios - use download_all_skills.sh)"
echo "  ✅ $CONFIG_FILE"
echo "  ✅ .env.example"
echo "  ✅ .gitignore"
echo ""

if [ "$install_method" == "1" ]; then
    echo -e "${CYAN}🔗 Links Simbólicos:${NC}"
    echo ""
    echo "  .agent/rules → .agent-boilerplate/.agent/rules"
    echo "  skills → .agent-boilerplate/skills"
    echo ""
fi

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📋 Próximos Passos:${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "1. Configure suas variáveis de ambiente:"
echo -e "   ${CYAN}cp .env.example .env${NC}"
echo -e "   ${CYAN}# Edite .env com seus valores reais${NC}"
echo ""
echo "2. (Opcional) Baixe as 600+ skills dos repositórios oficiais:"
echo -e "   ${CYAN}bash scripts/download_all_skills.sh${NC}"
echo ""
echo "3. Leia o comando de ativação:"
echo -e "   ${CYAN}cat .agent/ACTIVATION_COMMAND.md${NC}"
echo ""
echo "4. Use o comando de ativação no início de cada sessão com o agente"
echo ""

if [ "$install_method" == "1" ]; then
    echo "5. Para atualizar o boilerplate no futuro:"
    echo -e "   ${CYAN}git submodule update --remote .agent-boilerplate${NC}"
    echo ""
fi

echo -e "${GREEN}🎉 Boilerplate configurado! Desenvolvimento seguro ativado!${NC}"
echo ""
echo -e "${CYAN}Documentação: https://github.com/LeoSemAcento/boilerplate-skills${NC}"
echo -e "${CYAN}Autor: Breno Vieira Silva - Lion Lab Academy${NC}"
echo -e "${CYAN}Website: www.lionlabs.com.br${NC}"
echo ""
