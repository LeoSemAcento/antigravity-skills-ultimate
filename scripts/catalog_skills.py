#!/usr/bin/env python3
"""
Cataloga skills REAIS dos repositórios baixados localmente.
"""
import os
import json
import re
from pathlib import Path
from typing import Dict, List

REPO_URLS = {
    'mega-collection/antigravity': 'https://github.com/sickn33/antigravity-awesome-skills',
    'methodology/superpowers': 'https://github.com/obra/superpowers',
    'methodology/context-engineering': 'https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering',
    'frameworks/vercel': 'https://github.com/vercel-labs/agent-skills',
    'frameworks/expo': 'https://github.com/expo/skills',
    'frameworks/cloudflare': 'https://github.com/cloudflare/skills',
    'integrations/supabase': 'https://github.com/supabase/agent-skills',
    'integrations/stripe': 'https://github.com/stripe/ai',
    'integrations/n8n': 'https://github.com/czlonkowski/n8n-skills',
    'security/trailofbits': 'https://github.com/trailofbits/skills',
    'security/sentry': 'https://github.com/getsentry/skills',
    'official/anthropic': 'https://github.com/anthropics/skills',
    'official/huggingface': 'https://github.com/huggingface/skills',
}

def extract_frontmatter(filepath: Path) -> Dict:
    """Extrai YAML frontmatter."""
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        if not content.startswith('---'):
            return {}
        
        end = content.find('---', 3)
        if end == -1:
            return {}
        
        fm = content[3:end].strip()
        data = {}
        for line in fm.split('\n'):
            if ':' in line:
                key, val = line.split(':', 1)
                data[key.strip()] = val.strip().strip('"\'')
        return data
    except:
        return {}

def extract_description(filepath: Path) -> str:
    """Extrai primeira descrição."""
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        if content.startswith('---'):
            end = content.find('---', 3)
            if end != -1:
                content = content[end+3:]
        
        for line in content.split('\n'):
            line = line.strip()
            if line and not line.startswith('#') and len(line) > 30:
                return line[:200]
        return "Sem descrição"
    except:
        return "Erro ao ler"

def catalog_skills(skills_dir: str) -> List[Dict]:
    """Cataloga todas as skills."""
    skills = []
    path = Path(skills_dir)
    
    if not path.exists():
        print(f"❌ {skills_dir} não existe")
        return skills
    
    for cat in path.iterdir():
        if not cat.is_dir() or cat.name.startswith('.'):
            continue
        
        for repo in cat.iterdir():
            if not repo.is_dir() or repo.name.startswith('.'):
                continue
            
            rel_path = f"{cat.name}/{repo.name}"
            repo_url = REPO_URLS.get(rel_path, "URL não mapeada")
            
            for md_file in repo.rglob('*.md'):
                if md_file.name.upper() in ['README.MD', 'LICENSE.MD']:
                    continue
                
                fm = extract_frontmatter(md_file)
                
                skills.append({
                    'category': cat.name,
                    'repository': repo.name,
                    'repo_url': repo_url,
                    'file_path': str(md_file.relative_to(path)),
                    'name': fm.get('name', md_file.stem.replace('-', ' ').replace('_', ' ').title()),
                    'description': fm.get('description', extract_description(md_file)),
                    'triggers': fm.get('triggers', '').split(',') if fm.get('triggers') else [],
                })
    
    return skills

def generate_catalog(skills: List[Dict], output: str):
    """Gera SKILLS_CATALOG.md."""
    by_cat = {}
    for s in skills:
        cat = s['category']
        if cat not in by_cat:
            by_cat[cat] = []
        by_cat[cat].append(s)
    
    with open(output, 'w', encoding='utf-8') as f:
        f.write("# 📚 Catálogo REAL de Skills - Gerado Automaticamente\n\n")
        f.write(f"**Total:** {len(skills)} skills catalogadas\n\n")
        f.write("**Gerado em:** {}\n\n".format(__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M:%S')))
        f.write("---\n\n")
        
        # Índice
        f.write("## 📑 Índice\n\n")
        for cat in sorted(by_cat.keys()):
            f.write(f"- [{cat.title()}](#{cat.lower()}) ({len(by_cat[cat])} skills)\n")
        f.write("\n---\n\n")
        
        for cat in sorted(by_cat.keys()):
            f.write(f"## 📁 {cat.title()} ({len(by_cat[cat])} skills)\n\n")
            
            by_repo = {}
            for s in by_cat[cat]:
                r = s['repository']
                if r not in by_repo:
                    by_repo[r] = []
                by_repo[r].append(s)
            
            for repo in sorted(by_repo.keys()):
                repo_skills = by_repo[repo]
                f.write(f"### {repo}\n\n")
                f.write(f"**Repositório:** [{repo_skills[0]['repo_url']}]({repo_skills[0]['repo_url']})\n\n")
                f.write(f"**Total de skills:** {len(repo_skills)}\n\n")
                
                # Mostrar até 30 skills por repo
                for s in sorted(repo_skills, key=lambda x: x['name'])[:30]:
                    f.write(f"#### {s['name']}\n\n")
                    f.write(f"{s['description']}\n\n")
                    f.write(f"**Arquivo:** `{s['file_path']}`\n\n")
                    if s['triggers']:
                        triggers = [t.strip() for t in s['triggers'] if t.strip()]
                        if triggers:
                            f.write(f"**Triggers:** {', '.join(triggers)}\n\n")
                    f.write("---\n\n")
                
                if len(repo_skills) > 30:
                    f.write(f"*... e mais {len(repo_skills)-30} skills neste repositório*\n\n")
                
                f.write("\n")

def generate_index(skills: List[Dict], output: str):
    """Gera index.json."""
    index = {'total': len(skills), 'categories': {}}
    
    for s in skills:
        cat = s['category']
        if cat not in index['categories']:
            index['categories'][cat] = []
        
        index['categories'][cat].append({
            'name': s['name'],
            'description': s['description'][:100] + '...' if len(s['description']) > 100 else s['description'],
            'path': f"skills/{s['file_path']}",
            'triggers': s['triggers']
        })
    
    with open(output, 'w', encoding='utf-8') as f:
        json.dump(index, f, indent=2, ensure_ascii=False)

if __name__ == '__main__':
    print("🔍 Catalogando skills REAIS...")
    print("")
    
    skills = catalog_skills('skills')
    
    if not skills:
        print("⚠️ Nenhuma skill encontrada. Execute: bash scripts/download_skills_local.sh")
        exit(1)
    
    print(f"✅ {len(skills)} skills encontradas")
    print("")
    
    print("📝 Gerando catálogo...")
    generate_catalog(skills, 'docs/SKILLS_CATALOG.md')
    print("   ✅ docs/SKILLS_CATALOG.md criado")
    
    print("📝 Gerando índice JSON...")
    generate_index(skills, 'skills/index.json')
    print("   ✅ skills/index.json criado")
    
    print("")
    print("🎉 Catalogação concluída!")
    print("")
    print(f"📊 Estatísticas:")
    print(f"   Total de skills: {len(skills)}")
    
    by_cat = {}
    for s in skills:
        cat = s['category']
        by_cat[cat] = by_cat.get(cat, 0) + 1
    
    for cat in sorted(by_cat.keys()):
        print(f"   - {cat}: {by_cat[cat]} skills")
