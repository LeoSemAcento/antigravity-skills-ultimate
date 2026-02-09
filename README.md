# 🚀 Antigravity Skills Ultimate - Boilerplate Elite

> **Boilerplate de Elite com 15 Leis Fundamentais + 2,202 Skills Catalogadas**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Skills](https://img.shields.io/badge/Skills-2202-blue)](docs/SKILLS_CATALOG.md)
[![Laws](https://img.shields.io/badge/Laws-15-green)](.agent/rules/)

---

## ⚠️ Para Contribuidores

**Este é um repositório público PROTEGIDO:**

- ✅ Você pode clonar e usar livremente.
- ✅ Você pode fazer FORK para suas modificações.
- ❌ Você **NÃO** pode fazer push direto para este repo.
- 🔄 Contribuições são via Pull Request (após minha aprovação).

**Como usar:**
1. Faça o **Fork** do projeto.
2. Clone o **seu fork**: `git clone https://github.com/seu-usuario/antigravity-skills-ultimate.git`
3. Crie sua branch e, se quiser sugerir algo, abra um Pull Request.

---

## 🎯 O Que É Este Boilerplate?

Uma fundação pronta para usar com IDEs agênticas (Cursor, Antigravity, Claude Code, Windsurf, Cline) que inclui:

- ✅ **15 Leis Fundamentais** - Sistema imunológico contra anti-patterns
- ✅ **600+ Skills** - Biblioteca completa de melhores práticas
- ✅ **Lazy Loading** - Economia de tokens com carregamento inteligente
- ✅ **Segurança First** - Zero exposição de credenciais
- ✅ **Offline First** - Todo conhecimento localmente disponível

## 🏗️ Estrutura

```
.
├── .agent/
│   └── rules/              # 14 Leis com YAML frontmatter
├── skills/
│   ├── mega-collection/    # 600+ skills do Antigravity
│   ├── methodology/        # Superpowers + Context Engineering
│   ├── frameworks/         # Vercel, Expo, Cloudflare
│   ├── integrations/       # Supabase, Stripe, N8N
│   ├── security/           # Trail of Bits, Sentry
│   ├── official/           # Anthropic, Hugging Face
│   └── index.json         # Índice para lazy loading
├── scripts/
│   ├── split_rules.py     # Processa as 14 rules
│   ├── download_all_skills.sh
│   ├── index_skills.py
│   └── sync.sh            # Git sync com Conventional Commits
└── docs/
    ├── architecture/
    └── guides/
```

## 🚀 Como Usar Este Boilerplate em Novos Projetos

### 📌 Escolha Seu Método

Você tem **4 formas** de usar este boilerplate. Escolha a que melhor se adapta ao seu caso:

---

### 🎯 Método 1: Setup Automático (RECOMENDADO)

**Ideal para:** Adicionar o boilerplate a um projeto existente

#### Passo a Passo

**1️⃣ Navegue até seu projeto**

```bash
cd meu-projeto-existente
```

**2️⃣ Execute o script de setup**

```bash
# Testar primeiro (dry-run - não faz alterações)
bash <(curl -sSL https://raw.githubusercontent.com/LeoSemAcento/boilerplate-skills/main/scripts/setup-boilerplate.sh) --dry-run

# Executar de verdade
bash <(curl -sSL https://raw.githubusercontent.com/LeoSemAcento/boilerplate-skills/main/scripts/setup-boilerplate.sh)
```

**3️⃣ O script vai perguntar:**

- 📝 Qual IDE você usa? (Cline, Cursor, Windsurf, Antigravity, Claude Code)
- 📦 Método de instalação?
  - **Git Submodule** (recomendado - mantém atualizado)
  - **Cópia Local** (autônomo - não recebe updates)

**4️⃣ O que o script faz automaticamente:**

- ✅ Cria `.agent/rules/` com as 14 leis
- ✅ Cria `skills/` para as skills
- ✅ Cria arquivo de config da sua IDE (`.cursorrules`, `.clinerules`, etc)
- ✅ Cria `.env.example` com todas as variáveis documentadas
- ✅ Cria `.agent/ACTIVATION_COMMAND.md` com o comando de ativação
- ✅ Atualiza `.gitignore` para proteger arquivos sensíveis

**✨ Vantagens:**

- ⚡ Rápido (1 minuto)
- 🔒 Seguro (validações incluídas)
- 🎯 Personalizado (escolhe IDE e método)
- 🧪 Testável (modo dry-run)

---

### 🎨 Método 2: Usar como Template do GitHub

**Ideal para:** Criar um novo projeto do zero

#### Como Fazer

**1️⃣ Torne este repo um template** (só se você for o dono)

```
Vá em: Settings → ☑️ Template repository
```

**2️⃣ Use o template para criar novo projeto**

```
1. Clique em "Use this template" no GitHub
2. Escolha nome do novo repositório
3. Clone seu novo repositório
4. Configure a IDE:
   cp .clinerules .cursorrules  # ou sua IDE
```

**3️⃣ (Opcional) Baixe as 600+ skills**

```bash
bash scripts/download_all_skills.sh
```

**✨ Vantagens:**

- 🆕 Projeto novo completo
- 📦 Tudo incluído desde o início
- 🔄 Pode sincronizar com template depois

---

### 🛠️ Método 3: Git Submodule Manual

**Ideal para:** Quem quer entender o processo ou customizar

#### Passo a Passo Detalhado

**1️⃣ Adicione como submodule**

```bash
cd seu-projeto
git submodule add https://github.com/LeoSemAcento/boilerplate-skills.git .agent-boilerplate
git submodule update --init --recursive
```

**2️⃣ Crie links simbólicos**

**Linux/Mac:**

```bash
mkdir -p .agent
ln -s ../.agent-boilerplate/.agent/rules .agent/rules
ln -s .agent-boilerplate/skills skills
```

**Windows (Git Bash):**

```bash
mkdir -p .agent
cmd //c mklink //J ".agent\rules" "..\agent-boilerplate\.agent\rules"
cmd //c mklink //J "skills" ".agent-boilerplate\skills"
```

**3️⃣ Copie o arquivo de configuração**

```bash
# Para Cursor
cp .agent-boilerplate/.clinerules .cursorrules

# Para Cline
cp .agent-boilerplate/.clinerules .clinerules

# Para Windsurf
cp .agent-boilerplate/.clinerules .windsurfrules

# Para Antigravity
cp .agent-boilerplate/.clinerules .antigravity

# Para Claude Code
cp .agent-boilerplate/.clinerules .clauderules
```

**4️⃣ Crie arquivo de ambiente**

```bash
cp .agent-boilerplate/.env.example .env
# Edite .env com suas chaves
```

**✨ Vantagens:**

- 🎓 Entende o processo
- 🔧 Máximo controle
- 🔄 Fácil de atualizar (git submodule update --remote)

---

### 📋 Método 4: Clone Simples

**Ideal para:** Estudar, testar ou usar como base

#### Como Fazer

**1️⃣ Clone o repositório**

```bash
git clone https://github.com/LeoSemAcento/boilerplate-skills.git meu-projeto
cd meu-projeto
```

**2️⃣ Remova o histórico git (opcional)**

```bash
rm -rf .git
git init
git add .
git commit -m "feat: initial setup with boilerplate"
```

**3️⃣ Configure sua IDE**

```bash
cp .clinerules .cursorrules  # ou sua IDE
```

**4️⃣ (Opcional) Baixe as skills**

```bash
bash scripts/download_all_skills.sh
```

**✨ Vantagens:**

- 🎯 Simples e direto
- 📦 Tudo local
- 🆓 Totalmente autônomo

---

### 🎬 Após a Instalação (Todos os Métodos)

#### 1️⃣ Configure o Ambiente

```bash
# Copie o template de variáveis
cp .env.example .env

# Edite com suas chaves reais
# Use o editor de sua preferência
code .env  # VS Code
vim .env   # Vim
nano .env  # Nano
```

**Variáveis importantes:**

```bash
# Sessão (Gere com: openssl rand -base64 32)
SESSION_SECRET=sua-chave-aqui
IRON_SESSION_PASSWORD=sua-chave-minimo-32-chars

# Database
DEV_DATABASE_URL=postgresql://user:pass@localhost:5432/db_dev

# APIs (Lei 01: NUNCA use Service Role no frontend!)
DEV_SUPABASE_URL=https://xxx.supabase.co
DEV_SUPABASE_ANON_KEY=eyJ...  # OK no frontend
DEV_SUPABASE_SERVICE_ROLE_KEY=eyJ...  # APENAS no backend!

# OpenAI, Anthropic, etc.
DEV_OPENAI_API_KEY=sk-...
DEV_ANTHROPIC_API_KEY=sk-ant-...
```

#### 2️⃣ Leia o Comando de Ativação

```bash
cat .agent/ACTIVATION_COMMAND.md
```

#### 3️⃣ Ative o Agente na Primeira Sessão

**Cole este comando no chat da sua IDE agêntica:**

```
🔒 CARREGAMENTO DE CONTEXTO OBRIGATÓRIO

Antes de qualquer ação:

1. Leia TODAS as 14 leis em `.agent/rules/` (ordem numérica)
2. Analise o arquivo de configuração da IDE
3. Verifique quais skills são relevantes através do YAML Frontmatter
4. Aplique as restrições inegociáveis de cada lei relevante

Confirme que você:
- ✅ Leu as 14 leis
- ✅ Compreendeu as restrições de segurança (Leis 01, 03, 04, 07)
- ✅ Está pronto para seguir os padrões estabelecidos

Responda com: "✅ Sistema de leis carregado. Pronto para desenvolvimento seguro."
```

**O agente deve responder:** ✅ Sistema de leis carregado. Pronto para desenvolvimento seguro.

#### 4️⃣ (Opcional) Baixe as 600+ Skills

```bash
bash scripts/download_all_skills.sh
```

**Isso vai clonar:**

- 600+ skills do Antigravity
- Skills oficiais do Anthropic, Vercel, Supabase
- Skills de segurança do Trail of Bits, Sentry
- Metodologias de Context Engineering

**⚠️ Nota:** Ocupa ~100MB, mas vale a pena!

---

### 🔄 Como Atualizar o Boilerplate

#### Se usou Git Submodule:

```bash
# Atualizar para última versão
git submodule update --remote .agent-boilerplate

# Commitar a atualização
git add .agent-boilerplate
git commit -m "chore: update boilerplate to latest version"
```

#### Se usou Cópia Local:

```bash
# Você precisará re-executar o script de setup
bash <(curl -sSL https://raw.githubusercontent.com/LeoSemAcento/boilerplate-skills/main/scripts/setup-boilerplate.sh)

# Ou fazer pull manual e copiar arquivos atualizados
```

---

### 🤝 Como Contribuir Melhorias

Encontrou um bug ou tem uma sugestão?

**1️⃣ Fork este repositório**

**2️⃣ Crie uma branch para sua feature**

```bash
git checkout -b feat/minha-melhoria
```

**3️⃣ Faça suas alterações**

**4️⃣ Commit com Conventional Commits (Lei 12)**

```bash
git commit -m "feat(rules): add rule 15 for GraphQL best practices"
# ou
git commit -m "fix(scripts): correct Windows path in setup script"
# ou
git commit -m "docs: improve README examples"
```

**5️⃣ Push e abra Pull Request**

```bash
git push origin feat/minha-melhoria
```

---

### 📊 Comparação Rápida dos Métodos

| Método                  | Tempo    | Atualização        | Customização | Ideal Para          |
| ----------------------- | -------- | ------------------ | ------------ | ------------------- |
| 🎯 **Setup Automático** | ⚡ 1 min | ✅ Sim (submodule) | 🎨 Alta      | Projetos existentes |
| 🎨 **Template GitHub**  | ⚡ 2 min | ⚠️ Manual          | 🎨 Total     | Projetos novos      |
| 🛠️ **Submodule Manual** | ⏱️ 5 min | ✅ Fácil           | 🎨 Total     | Aprendizado         |
| 📋 **Clone Simples**    | ⚡ 1 min | ❌ Não             | 🎨 Total     | Testes/estudos      |

---

## 🚀 Quick Start

### Método 1: Setup Automático (Recomendado) 🎯

Use o script de setup automático em seu projeto existente:

```bash
# No diretório do seu projeto
curl -sSL https://raw.githubusercontent.com/LeoSemAcento/boilerplate-skills/main/scripts/setup-boilerplate.sh | bash
```

O script irá:

- ✅ Perguntar qual IDE você usa (Cline, Cursor, Windsurf, Antigravity, Claude Code)
- ✅ Escolher entre Git Submodule (recomendado) ou cópia local
- ✅ Configurar automaticamente as 14 leis e estrutura de skills
- ✅ Criar `.env.example` e guia de ativação

### Método 2: Manual

#### 1. Clone este repositório

```bash
git clone https://github.com/LeoSemAcento/boilerplate-skills.git meu-projeto
cd meu-projeto
```

#### 2. Configure sua IDE

```bash
# Para Cursor
cp .clinerules .cursorrules

# Para Antigravity
cp .clinerules .antigravity

# Para Claude Code
cp .clinerules .claude
```

#### 3. Download das Skills (Opcional)

```bash
# Baixar todas as 600+ skills dos repositórios
bash scripts/download_all_skills.sh
```

#### 4. Pronto! 🎉

O agente já tem acesso a:

- 14 leis de arquitetura e segurança
- Sistema de lazy loading otimizado
- Skills especializadas (após download)

### ⚡ Uso em Projeto Existente

Se você já tem um projeto e quer adicionar o boilerplate:

```bash
# Opção 1: Download e execute o script
curl -sSL https://raw.githubusercontent.com/LeoSemAcento/boilerplate-skills/main/scripts/setup-boilerplate.sh -o setup.sh
bash setup.sh

# Opção 2: Como Git Submodule
git submodule add https://github.com/LeoSemAcento/boilerplate-skills.git .agent-boilerplate
ln -s .agent-boilerplate/.agent/rules .agent/rules
ln -s .agent-boilerplate/skills skills
cp .agent-boilerplate/.clinerules .cursorrules  # ou .clinerules, .windsurfrules, etc
```

## 📚 Como o Lazy Loading Funciona

### 1️⃣ Agente Lê o Índice

```json
{
  "security": [
    {
      "name": "Zero Trust Auth",
      "description": "Enforce session validation...",
      "triggers": ["authentication", "API routes"],
      "path": "security/trailofbits/zero-trust.md"
    }
  ]
}
```

### 2️⃣ Identifica Skills Relevantes

Baseado nos **triggers**, o agente decide quais skills carregar.

### 3️⃣ Carrega Apenas o Necessário

Em vez de carregar 600 skills (milhões de tokens), carrega apenas 2-3 relevantes.

## 💾 Download Local de Skills

### Como Funciona

**GitHub (Versionado):**

- ✅ docs/SKILLS_CATALOG.md (~1 MB)
- ✅ Estrutura de pastas vazias
- ❌ Conteúdo das skills (NÃO uploadado)

**Seu PC (Local):**

- ✅ skills/ com todo conteúdo (~150 MB)
- ✅ Disponível offline
- ✅ Lazy loading automático

### Baixar Todas as Skills

```bash
# No diretório do boilerplate
bash scripts/download_skills_local.sh
```

**Isso baixa:**

- 13 repositórios
- ~945 skills
- ~100-150 MB

### Baixar Skill Específica

```bash
# Ver lista
bash scripts/download_skill_on_demand.sh

# Baixar uma
bash scripts/download_skill_on_demand.sh integrations/supabase
```

### Verificar Status

```bash
# Quantas skills baixadas
find skills/ -name "*.md" | wc -l

# Tamanho total
du -sh skills/
```

### Por Que Não Está no GitHub?

1. ✅ **Repo Leve:** 10 MB vs 150 MB
2. ✅ **Sem Duplicação:** Skills já são públicas
3. ✅ **Performance:** Clone rápido
4. ✅ **Flexibilidade:** Baixe só o que precisar

---

## 🔒 Segurança e Compliance

Todas as 15 leis são aplicadas automaticamente:

- **Lei 01**: Service Role nunca no frontend
- **Lei 03**: Company_id sempre da sessão
- **Lei 04**: API Keys criptografadas em repouso
- **Lei 12**: Conventional Commits obrigatórios
- **Lei 13**: Ambientes completamente isolados
- **Lei 15**: Protocolo PPREVC - Planejamento antes de código

## 🛠️ Scripts Disponíveis

```bash
# 🚀 Setup automático do boilerplate em novo projeto
bash scripts/setup-boilerplate.sh

# 🔄 Sincronizar com Git (Conventional Commits)
bash scripts/sync.sh

# 📥 Baixar todas as 600+ skills
bash scripts/download_all_skills.sh

# 📊 Re-indexar skills após adicionar novas
python scripts/index_skills.py

# 🔧 Processar 14 rules (já executado automaticamente)
python scripts/split_rules.py 14-rules-ides-agenticas-v2LionLab.md .agent/rules
```

### 📋 Como Ativar o Agente

Após o setup, **sempre** inicie suas sessões com o comando de ativação:

```
🔒 CARREGAMENTO DE CONTEXTO OBRIGATÓRIO

Antes de qualquer ação:

1. Leia TODAS as 14 leis em `.agent/rules/` (ordem numérica)
2. Analise o arquivo de configuração da IDE
3. Verifique quais skills são relevantes através do YAML Frontmatter
4. Aplique as restrições inegociáveis de cada lei relevante

Confirme que você:
- ✅ Leu as 14 leis
- ✅ Compreendeu as restrições de segurança (Leis 01, 03, 04, 07)
- ✅ Está pronto para seguir os padrões estabelecidos

Responda com: "✅ Sistema de leis carregado. Pronto para desenvolvimento seguro."
```

> **Dica**: O arquivo `.agent/ACTIVATION_COMMAND.md` contém este comando e mais detalhes

## 📦 Repositórios Incluídos

> **📚 Documentação Completa:** Veja [SKILLS_CATALOG.md](docs/SKILLS_CATALOG.md) para informações detalhadas de cada repositório.

### 🎯 Mega Coleção

- **[Antigravity Awesome Skills](https://github.com/sickn33/antigravity-awesome-skills)** (~1.2K⭐) - Maior coleção open-source com 600+ skills cobrindo web, backend, DevOps, AI/ML e testing para IDEs agênticas.

### 🧠 Metodologia

- **[Superpowers](https://github.com/obra/superpowers)** (~800⭐) - Meta-habilidades que ensinam o agente como pensar, se comunicar e estruturar processos de desenvolvimento.
- **[Agent Skills for Context Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering)** (~300⭐) - Engenharia de contexto: lazy loading, token optimization e retrieval seletivo para projetos grandes.

### 🏗️ Frameworks

- **[Vercel Agent Skills](https://github.com/vercel-labs/agent-skills)** (~500⭐) - Skills oficiais para Next.js App Router, React Server Components e Vercel Platform.
- **[Expo Skills](https://github.com/expo/skills)** (~200⭐) - Desenvolvimento React Native: mobile apps, EAS Build, App Store e Google Play submission.
- **[Cloudflare Skills](https://github.com/cloudflare/skills)** (~150⭐) - Edge computing com Workers, Pages, KV storage e segurança em camada de rede.

### 🔌 Integrações

- **[Supabase Agent Skills](https://github.com/supabase/agent-skills)** (~400⭐) - Backend-as-a-Service: PostgreSQL, Auth, Storage, Realtime e Edge Functions.
- **[Stripe AI](https://github.com/stripe/ai)** (~300⭐) - Pagamentos, assinaturas, billing e checkout com compliance PCI e segurança.
- **[N8N Skills](https://github.com/czlonkowski/n8n-skills)** (~100⭐) - Workflow automation: integração com 400+ serviços através de workflows visuais.

### 🛡️ Segurança

- **[Trail of Bits Skills](https://github.com/trailofbits/skills)** (~600⭐) - Segurança ofensiva: vulnerability detection, secure coding e smart contract auditing.
- **[Sentry Skills](https://github.com/getsentry/skills)** (~200⭐) - Error tracking, performance monitoring e observability para produção.

### 🏢 Oficiais

- **[Anthropic Skills](https://github.com/anthropics/skills)** (~500⭐) - Skills oficiais da Anthropic para Claude: prompt engineering e tool use optimization.
- **[Hugging Face Skills](https://github.com/huggingface/skills)** (~400⭐) - ML/AI com transformers: fine-tuning, deployment e inference optimization.

## 🎓 Lazy Loading Técnico

O sistema usa **YAML Frontmatter** para metadados:

```yaml
---
name: "Clean Architecture Enforcer"
description: "Prevent business logic in controllers"
triggers:
  - "controller creation"
  - "route handlers"
category: "architecture"
---
# Corpo da Skill
[Instruções completas aqui...]
```

O agente:

1. Lê apenas o frontmatter (50 bytes)
2. Decide se é relevante
3. Carrega o corpo completo só se necessário

**Economia**: 99% de tokens economizados em tarefas simples.

## 📈 Performance

- **Sem Boilerplate**: ~500K tokens por sessão (carregamento completo)
- **Com Boilerplate**: ~8K tokens inicial + 4K por skill ativada
- **Economia Média**: 95%+

## 🤝 Contribuindo

Para adicionar novas skills ou rules:

1. Adicione na pasta apropriada
2. Use YAML frontmatter
3. Execute `python scripts/index_skills.py`
4. Commit com `bash scripts/sync.sh`

## 📄 Licença

Este boilerplate é livre para uso e modificação.

**Autor das 14 Rules**: Breno Vieira Silva - Lion Lab Academy  
**Website**: [www.lionlabs.com.br](https://www.lionlabs.com.br)

---

**Nota**: Este boilerplate maximiza performance e segurança através de:

- Soberania de dados (offline first)
- Lazy loading inteligente
- Sistema imunológico (14 leis)
- Zero desperdício de tokens
