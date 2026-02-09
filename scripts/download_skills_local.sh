#!/bin/bash
set -e

echo "📦 Baixando Skills Localmente"
echo "=============================="
echo ""
echo "⚠️  Atenção: Este conteúdo NÃO será commitado no GitHub"
echo "   Apenas o catálogo (docs/SKILLS_CATALOG.md) já está versionado"
echo ""

SKILLS_DIR="skills"

# Criar diretório se não existir
mkdir -p "$SKILLS_DIR"/{mega-collection,methodology,frameworks,integrations,security,official}

# Função para download
download_repo() {
    local url=$1
    local path=$2
    
    echo "📥 Baixando: $(basename $url)"
    echo "   Destino: $SKILLS_DIR/$path"
    
    if [ -d "$SKILLS_DIR/$path" ]; then
        echo "   ⏭️  Já existe, pulando..."
    else
        git clone --depth 1 "$url" "$SKILLS_DIR/$path" 2>/dev/null || {
            echo "   ❌ Erro ao clonar"
            return 1
        }
        rm -rf "$SKILLS_DIR/$path/.git"
        echo "   ✅ Concluído"
    fi
    echo ""
}

echo "🚀 Iniciando downloads..."
echo ""

# Mega Collection (1 repo)
echo "📁 Categoria: Mega Collection"
download_repo "https://github.com/sickn33/antigravity-awesome-skills.git" "mega-collection/antigravity"

# Methodology (2 repos)
echo "📁 Categoria: Methodology"
download_repo "https://github.com/obra/superpowers.git" "methodology/superpowers"
download_repo "https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering.git" "methodology/context-engineering"

# Frameworks (3 repos)
echo "📁 Categoria: Frameworks"
download_repo "https://github.com/vercel-labs/agent-skills.git" "frameworks/vercel"
download_repo "https://github.com/expo/skills.git" "frameworks/expo"
download_repo "https://github.com/cloudflare/skills.git" "frameworks/cloudflare"

# Integrations (3 repos)
echo "📁 Categoria: Integrations"
download_repo "https://github.com/supabase/agent-skills.git" "integrations/supabase"
download_repo "https://github.com/stripe/ai.git" "integrations/stripe"
download_repo "https://github.com/czlonkowski/n8n-skills.git" "integrations/n8n"

# Security (2 repos)
echo "📁 Categoria: Security"
download_repo "https://github.com/trailofbits/skills.git" "security/trailofbits"
download_repo "https://github.com/getsentry/skills.git" "security/sentry"

# Official (2 repos)
echo "📁 Categoria: Official"
download_repo "https://github.com/anthropics/skills.git" "official/anthropic"
download_repo "https://github.com/huggingface/skills.git" "official/huggingface"

echo ""
echo "🎉 Download Completo!"
echo ""
echo "📊 Estatísticas:"
echo "   Total de arquivos .md: $(find $SKILLS_DIR -name '*.md' 2>/dev/null | wc -l)"
echo "   Tamanho total: $(du -sh $SKILLS_DIR 2>/dev/null | cut -f1)"
echo ""
echo "📂 Skills disponíveis em: ./$SKILLS_DIR/"
echo "📖 Catálogo já versionado em: ./docs/SKILLS_CATALOG.md"
echo ""
echo "✅ Pronto para uso! O agente pode acessar localmente via lazy loading."
