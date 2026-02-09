#!/usr/bin/env python3
"""
Script para separar as 14 Rules em arquivos individuais
Uso: python split_rules.py <input_file> <output_dir>
"""
import re
import sys
from pathlib import Path


def extract_rules(input_file: str, output_dir: str):
    """Extrai cada rule para arquivo separado com YAML frontmatter."""

    with open(input_file, "r", encoding="utf-8") as f:
        content = f.read()

    # Regex para capturar cada seção de rule
    pattern = r"={80}\nrule-(\d+)-([\w-]+)\.md\n(.*?)(?====|$)"
    matches = re.finditer(pattern, content, re.DOTALL)

    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    for match in matches:
        rule_num = match.group(1)
        rule_slug = match.group(2)
        rule_content = match.group(3).strip()

        # Extrair metadados
        title_match = re.search(r"LEI \d+: (.+)", rule_content)
        title = title_match.group(1) if title_match else rule_slug

        # Determinar categoria
        category = categorize_rule(rule_slug)
        severity = determine_severity(rule_num)
        triggers = extract_triggers(rule_content)

        # Gerar YAML frontmatter
        frontmatter = f"""---
rule_number: {rule_num}
name: "{title}"
slug: "{rule_slug}"
category: "{category}"
severity: "{severity}"
triggers:
{chr(10).join(f'  - "{t}"' for t in triggers)}
---

"""

        # Salvar arquivo
        filename = f"rule-{rule_num}-{rule_slug}.md"
        filepath = output_path / filename

        with open(filepath, "w", encoding="utf-8") as f:
            f.write(frontmatter + rule_content)

        print(f"✅ Criado: {filename}")


def categorize_rule(slug: str) -> str:
    """Categoriza a rule por tipo."""
    categories = {
        "security": ["security", "secrets", "credential", "isolation", "session"],
        "performance": ["async", "performance"],
        "architecture": ["clean", "multi-tenant", "architecture"],
        "quality": ["test", "error", "documentation"],
        "api": ["api", "consistency"],
        "devops": ["commit", "env", "dependency"],
    }

    for category, keywords in categories.items():
        if any(kw in slug for kw in keywords):
            return category
    return "general"


def determine_severity(rule_num: str) -> str:
    """Define severidade baseada na importância da rule."""
    critical_rules = ["01", "03", "04", "07", "13"]  # Segurança e isolamento
    high_rules = ["02", "05", "06", "08", "10"]  # Performance e qualidade

    if rule_num in critical_rules:
        return "critical"
    elif rule_num in high_rules:
        return "high"
    return "medium"


def extract_triggers(content: str) -> list:
    """Extrai gatilhos de ativação da rule."""
    triggers = []

    # Buscar seção GATILHO
    gatilho_match = re.search(r"GATILHO:\s*\n(.+?)(?:\n\n|\n[A-Z])", content, re.DOTALL)
    if gatilho_match:
        gatilho_text = gatilho_match.group(1).lower()

        # Extrair termos-chave
        if "frontend" in gatilho_text or "/app" in gatilho_text:
            triggers.append("frontend code")
        if "backend" in gatilho_text or "api" in gatilho_text:
            triggers.append("backend code")
        if "database" in gatilho_text or "supabase" in gatilho_text:
            triggers.append("database operations")
        if "migration" in gatilho_text or "sql" in gatilho_text:
            triggers.append("migrations")
        if "test" in gatilho_text:
            triggers.append("testing")

    return triggers if triggers else ["general development"]


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Uso: python split_rules.py <input_file> <output_dir>")
        sys.exit(1)

    extract_rules(sys.argv[1], sys.argv[2])
    print("\n🎉 Processamento completo!")
