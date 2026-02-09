# 🚀 Quick Start Guide

## Próximos Passos

Agora que o boilerplate está configurado, você pode:

### 1. Download das Skills (Opcional)

Execute o script para baixar todas as 600+ skills dos repositórios:

```bash
bash scripts/download_all_skills.sh
```

**Nota**: Este processo pode levar alguns minutos e requer conexão com a internet.

### 2. Usar em Novos Projetos

Para usar este boilerplate em um novo projeto:

```bash
# Clone o repositório
git clone https://github.com/LeoSemAcento/boilerplate-skills.git meu-novo-projeto
cd meu-novo-projeto

# Remova o histórico git original
rm -rf .git

# Inicie um novo repositório
git init
git add .
git commit -m "feat: initial project setup with boilerplate"

# Configure para sua IDE favorita
cp .clinerules .cursorrules  # Para Cursor
# ou
cp .clinerules .antigravity  # Para Antigravity
```

### 3. Customizar para Seu Projeto

#### Adicionar Skills Personalizadas

1. Crie um arquivo `.md` em `skills/` na categoria apropriada
2. Use YAML frontmatter:

```yaml
---
name: "Minha Skill Personalizada"
description: "Descrição da skill"
triggers:
  - "palavra-chave-1"
  - "palavra-chave-2"
category: "custom"
---
# Conteúdo da Skill
[Suas instruções aqui...]
```

3. Re-indexe as skills:

```bash
python scripts/index_skills.py
```

#### Adicionar Regras Personalizadas

1. Crie um arquivo em `.agent/rules/` seguindo o padrão:

```markdown
---
rule_number: 15
name: "Minha Regra"
slug: "minha-regra"
category: "custom"
severity: "high"
triggers:
  - "trigger personalizado"
---

# LEI 15: Minha Regra

## 🎯 MOTIVO

[Explicação do porquê]

## ⚡ GATILHO

[Quando aplicar]

## 🚫 RESTRIÇÕES INEGOCIÁVEIS

[Regras que não podem ser quebradas]

## ✅ EXEMPLO CORRETO

[Código de exemplo]
```

### 4. Sincronizar Mudanças

Use o script de sync para commits convencionais:

```bash
bash scripts/sync.sh
```

## 📊 Estrutura Atual

```
d:/Github/Boilerplate Skills/
├── .agent/rules/           ✅ 14 regras processadas
├── .clinerules            ✅ Configuração do agente
├── skills/                ⚠️  Vazio (execute download_all_skills.sh)
│   ├── mega-collection/
│   ├── methodology/
│   ├── frameworks/
│   ├── integrations/
│   ├── security/
│   └── official/
├── scripts/               ✅ 4 scripts prontos
├── docs/                  ✅ Estrutura criada
└── README.md             ✅ Documentação completa
```

## 🎯 Como o Agente Usa Isso

### Fluxo de Trabalho

1. **Você pede uma tarefa** → Agente lê `.clinerules`
2. **Agente carrega rules** → Lê `.agent/rules/` (14 leis)
3. **Agente analisa contexto** → Verifica triggers relevantes
4. **Carregamento lazy** → Só carrega skills necessárias (economia de 95%+ tokens)
5. **Execução segura** → Aplica restrições das rules

### Exemplo Prático

```
Você: "Crie uma rota de API para autenticação"

Agente:
1. ✅ Lê Rule 01 (Security Isolation)
2. ✅ Lê Rule 03 (Multi-Tenant Shield)
3. ✅ Lê Rule 05 (Session Hardening)
4. ✅ Carrega skill de autenticação (se disponível)
5. ✅ Gera código seguindo todas as restrições
```

## 🔥 Dicas Pro

### Performance

- **Não commite as skills baixadas** - Elas são grandes (100MB+)
- **Use .gitignore** - Já configurado para ignorar arquivos sensíveis
- **Re-indexe após adicionar skills** - `python scripts/index_skills.py`

### Segurança

- **Nunca commite .env** - Já está no .gitignore
- **Use secrets nos exemplos** - Todos os exemplos seguem as 14 leis
- **Revise código gerado** - Mesmo com rules, sempre revise

### Manutenção

- **Atualize skills periodicamente**:
  ```bash
  cd skills/mega-collection/antigravity
  git pull
  cd ../../..
  python scripts/index_skills.py
  ```

## 📚 Recursos

- [README Principal](../README.md)
- [14 Rules Originais](../14-rules-ides-agenticas-v2LionLab.md)
- [Lion Lab Academy](https://www.lionlabs.com.br)

## 🆘 Troubleshooting

### Scripts não executam no Windows

Use Git Bash ou WSL:

```bash
# Git Bash
bash scripts/download_all_skills.sh

# Windows (alternativa)
python scripts/split_rules.py 14-rules-ides-agenticas-v2LionLab.md .agent/rules
```

### Skills não carregam

1. Verifique se executou `download_all_skills.sh`
2. Execute `python scripts/index_skills.py`
3. Verifique se `skills/index.json` foi criado

### Agente não aplica rules

1. Verifique se `.clinerules` existe
2. Para Cursor: copie para `.cursorrules`
3. Reinicie a IDE

---

**Boilerplate criado com ❤️ por Breno Vieira Silva - Lion Lab Academy**
