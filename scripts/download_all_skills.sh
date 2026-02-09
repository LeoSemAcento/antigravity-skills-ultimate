#!/bin/bash
set -e

echo "🚀 Iniciando download de todas as skills..."

SKILLS_DIR="skills"

# Função auxiliar para clonar e limpar
clone_and_clean() {
    local url=$1
    local dir=$2
    local subdir=$3
    
    echo "📥 Clonando $url..."
    cd "$SKILLS_DIR/$subdir"
    
    git clone --depth 1 "$url" "$dir"
    rm -rf "$dir/.git"
    
    echo "✅ $dir concluído"
    cd - > /dev/null
}

# Mega Collection
clone_and_clean "https://github.com/sickn33/antigravity-awesome-skills.git" "antigravity" "mega-collection"

# Methodology
clone_and_clean "https://github.com/obra/superpowers.git" "superpowers" "methodology"
clone_and_clean "https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering.git" "context-engineering" "methodology"

# Frameworks
clone_and_clean "https://github.com/vercel-labs/agent-skills.git" "vercel" "frameworks"
clone_and_clean "https://github.com/expo/skills.git" "expo" "frameworks"
clone_and_clean "https://github.com/cloudflare/skills.git" "cloudflare" "frameworks"

# Integrations
clone_and_clean "https://github.com/supabase/agent-skills.git" "supabase" "integrations"
clone_and_clean "https://github.com/stripe/ai.git" "stripe" "integrations"
clone_and_clean "https://github.com/czlonkowski/n8n-skills.git" "n8n" "integrations"

# Security
clone_and_clean "https://github.com/trailofbits/skills.git" "trailofbits" "security"
clone_and_clean "https://github.com/getsentry/skills.git" "sentry" "security"

# Official
clone_and_clean "https://github.com/anthropics/skills.git" "anthropic" "official"
clone_and_clean "https://github.com/huggingface/skills.git" "huggingface" "official"

echo ""
echo "🎉 Download completo de todas as skills!"
echo "📊 Gerando índice..."

# Gerar índice de skills
python3 scripts/index_skills.py

echo "✨ Boilerplate pronto para uso!"
