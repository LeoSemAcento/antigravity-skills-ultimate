#!/usr/bin/env python3
"""
Gera índice de todas as skills com metadados para lazy loading
"""
import os
import json
import yaml
from pathlib import Path
from typing import Dict, List


def extract_frontmatter(filepath: Path) -> Dict:
    """Extrai YAML frontmatter de um arquivo markdown."""
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    if not content.startswith("---"):
        return {}

    try:
        end_index = content.find("---", 3)
        if end_index == -1:
            return {}

        frontmatter = content[3:end_index].strip()
        return yaml.safe_load(frontmatter) or {}
    except:
        return {}


def index_skills(skills_dir: str) -> Dict[str, List[Dict]]:
    """Indexa todas as skills por categoria."""
    index = {}
    skills_path = Path(skills_dir)

    for category in skills_path.iterdir():
        if not category.is_dir():
            continue

        index[category.name] = []

        # Buscar todos os SKILL.md ou *.md
        for skill_file in category.rglob("*.md"):
            metadata = extract_frontmatter(skill_file)

            if not metadata:
                # Tentar extrair do nome do arquivo
                metadata = {
                    "name": skill_file.stem.replace("-", " ").title(),
                    "description": f"Skill localizada em {skill_file.relative_to(skills_path)}",
                }

            index[category.name].append(
                {
                    "path": str(skill_file.relative_to(skills_path)),
                    "name": metadata.get("name", skill_file.stem),
                    "description": metadata.get("description", ""),
                    "triggers": metadata.get("triggers", []),
                    "size_kb": skill_file.stat().st_size / 1024,
                }
            )

    return index


def generate_readme(index: Dict, output_path: str):
    """Gera README.md com lista organizada de skills."""
    with open(output_path, "w", encoding="utf-8") as f:
        f.write("# 📚 Índice de Skills do Boilerplate\n\n")
        f.write("> Gerado automaticamente - Não edite manualmente\n\n")

        total_skills = sum(len(skills) for skills in index.values())
        total_size = sum(
            skill["size_kb"] for skills in index.values() for skill in skills
        )

        f.write(f"**Total de Skills**: {total_skills}\n")
        f.write(f"**Tamanho Total**: {total_size:.2f} KB\n\n")
        f.write("---\n\n")

        for category, skills in sorted(index.items()):
            f.write(f"## 📁 {category.title()} ({len(skills)} skills)\n\n")

            for skill in sorted(skills, key=lambda x: x["name"]):
                f.write(f"### {skill['name']}\n")
                f.write(f"**Path**: `{skill['path']}`\n")
                if skill["description"]:
                    f.write(f"**Descrição**: {skill['description']}\n")
                if skill["triggers"]:
                    f.write(f"**Triggers**: {', '.join(skill['triggers'])}\n")
                f.write(f"**Tamanho**: {skill['size_kb']:.2f} KB\n\n")


if __name__ == "__main__":
    print("🔍 Indexando skills...")

    index = index_skills("skills")

    # Salvar índice JSON
    with open("skills/index.json", "w", encoding="utf-8") as f:
        json.dump(index, f, indent=2, ensure_ascii=False)

    # Gerar README
    generate_readme(index, "skills/README.md")

    print(f"✅ Índice criado: {sum(len(s) for s in index.values())} skills catalogadas")
