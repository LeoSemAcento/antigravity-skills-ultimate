#!/bin/bash
# Download de repositório específico de skills sob demanda

SKILL_PATH=$1

if [ -z "$SKILL_PATH" ]; then
    echo "❌ Uso: bash scripts/download_skill_on_demand.sh <categoria/repositorio>"
    echo ""
    echo "📚 Repositórios disponíveis:"
    echo ""
    echo "  Mega Collection:"
    echo "    - mega-collection/antigravity"
    echo ""
    echo "  Methodology:"
    echo "    - methodology/superpowers"
    echo "    - methodology/context-engineering"
    echo ""
    echo "  Frameworks:"
    echo "    - frameworks/vercel"
    echo "    - frameworks/expo"
    echo "    - frameworks/cloudflare"
    echo ""
    echo "  Integrations:"
    echo "    - integrations/supabase"
    echo "    - integrations/stripe"
    echo "    - integrations/n8n"
    echo ""
    echo "  Security:"
    echo "    - security/trailofbits"
    echo "    - security/sentry"
    echo ""
    echo "  Official:"
    echo "    - official/anthropic"
    echo "    - official/huggingface"
    echo ""
    echo "Exemplo: bash scripts/download_skill_on_demand.sh security/trailofbits"
    exit 1
fi

# Mapeamento de URLs
declare -A REPOS
REPOS[mega-collection/antigravity]="https://github.com/sickn33/antigravity-awesome-skills.git"
REPOS[methodology/superpowers]="https://github.com/obra/superpowers.git"
REPOS[methodology/context-engineering]="https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering.git"
REPOS[frameworks/vercel]="https://github.com/vercel-labs/agent-skills.git"
REPOS[frameworks/expo]="https://github.com/expo/skills.git"
REPOS[frameworks/cloudflare]="https://github.com/cloudflare/skills.git"
REPOS[integrations/supabase]="https://github.com/supabase/agent-skills.git"
REPOS[integrations/stripe]="https://github.com/stripe/ai.git"
REPOS[integrations/n8n]="https://github.com/czlonkowski/n8n-skills.git"
REPOS[security/trailofbits]="https://github.com/trailofbits/skills.git"
REPOS[security/sentry]="https://github.com/getsentry/skills.git"
REPOS[official/anthropic]="https://github.com/anthropics/skills.git"
REPOS[official/huggingface]="https://github.com/huggingface/skills.git"

URL="${REPOS[$SKILL_PATH]}"

if [ -z "$URL" ]; then
    echo "❌ Skill não encontrada: $SKILL_PATH"
    echo ""
    echo "Use sem argumentos para ver lista completa:"
    echo "  bash scripts/download_skill_on_demand.sh"
    exit 1
fi

if [ -d "skills/$SKILL_PATH" ]; then
    echo "✅ Skill já existe: skills/$SKILL_PATH"
    echo "   Arquivos .md: $(find skills/$SKILL_PATH -name '*.md' | wc -l)"
    exit 0
fi

echo "📥 Baixando: $URL"
echo "   → skills/$SKILL_PATH"
echo ""

git clone --depth 1 "$URL" "skills/$SKILL_PATH" 2>/dev/null || {
    echo "❌ Erro ao baixar repositório"
    exit 1
}

rm -rf "skills/$SKILL_PATH/.git"

echo ""
echo "✅ Download concluído!"
echo "   Arquivos .md: $(find skills/$SKILL_PATH -name '*.md' | wc -l)"
echo "   Tamanho: $(du -sh skills/$SKILL_PATH | cut -f1)"
