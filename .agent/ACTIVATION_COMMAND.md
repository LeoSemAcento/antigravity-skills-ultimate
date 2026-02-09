# 🔒 Comando de Ativação do Agente

## Quando Usar

**SEMPRE** inicie uma nova sessão ou após reiniciar a IDE com este comando para garantir que o agente carregue todas as 15 leis e esteja pronto para desenvolvimento seguro.

## Comando de Ativação

Cole este comando no chat da sua IDE agêntica:

```
🔒 CARREGAMENTO DE CONTEXTO OBRIGATÓRIO

Antes de qualquer ação:

1. Leia TODAS as 15 leis em `.agent/rules/` (ordem numérica)
2. Analise o arquivo de configuração da IDE (.clinerules, .cursorrules, etc)
3. Verifique quais skills são relevantes através do YAML Frontmatter
4. Aplique as restrições inegociáveis de cada lei relevante

Confirme que você:
- ✅ Leu as 15 leis
- ✅ Compreendeu as restrições de segurança (Leis 01, 03, 04, 07)
- ✅ Compreendeu o protocolo PPREVC (Lei 15)
- ✅ Está pronto para seguir os padrões estabelecidos

Responda com: "✅ Sistema de 15 leis carregado. Pronto para desenvolvimento seguro."
```

## Resposta Esperada

O agente deve responder:

```
✅ Sistema de 15 leis carregado. Pronto para desenvolvimento seguro.
```

## Leis Críticas

### 🔐 Segurança (Leis 01, 03, 04, 07)

- **Lei 01**: Service Role NUNCA no frontend
- **Lei 03**: Company_id SEMPRE da sessão
- **Lei 04**: API Keys criptografadas em repouso
- **Lei 07**: Bcrypt com custo 12, tokens seguros

### ⚡ Performance (Lei 02)

- **Lei 02**: Async first, sem código bloqueante

### 🏗️ Arquitetura (Lei 06)

- **Lei 06**: Clean Architecture, separação de camadas

### 🧪 Qualidade (Leis 08, 10, 14)

- **Lei 08**: Tratamento de erros com contexto
- **Lei 10**: TDD - testes antes da implementação
- **Lei 14**: Documentação como código

### 📦 Manutenção (Leis 09, 12, 13)

- **Lei 09**: Higiene de dependências
- **Lei 12**: Conventional Commits
- **Lei 13**: Isolamento de ambientes

### 🎯 Metodologia (Lei 15) - NOVA!

- **Lei 15**: Protocolo PPREVC
  - **P**révia: Receber input
  - **P**lanejamento: Template obrigatório
  - **R**evisão: Aprovação explícita
  - **E**xecução: Gerar código
  - **V**alidação: Testar
  - **C**onfirmação: Commit

## Verificação Rápida

Após ativar, teste com:

```
"Crie uma rota de autenticação"
```

O agente deve:

1. ❌ NÃO gerar código imediatamente
2. ✅ Apresentar um plano de execução estruturado
3. ✅ Solicitar aprovação explícita antes de gerar código
4. ✅ Referenciar leis relevantes (01, 03, 04, 07, 12)

## Troubleshooting

### Agente não carregou as leis?

```bash
# Verifique se os arquivos existem
ls -la .agent/rules/

# Deve listar:
# rule-01-security-isolation.md
# rule-02-async-performance.md
# ...
# rule-15-pprevc-protocol.md
```

### Agente ignora o protocolo PPREVC?

Relembre explicitamente:

```
"Lembre-se da Lei 15: você DEVE apresentar um plano antes de gerar código. Nunca pule direto para a implementação."
```

## Desenvolvimento Diário

**Boas Práticas:**

1. ✅ Ative o agente no início de cada sessão
2. ✅ Relembre leis específicas quando relevante
3. ✅ Solicite validação contra leis antes de commit
4. ✅ Use o protocolo PPREVC para features complexas

**Atalhos Úteis:**

```bash
# Validar contra Lei 01 (Segurança)
"Valide este código contra a Lei 01"

# Validar contra Lei 12 (Commits)
"Gere uma mensagem de commit seguindo a Lei 12"

# Forçar planejamento (Lei 15)
"Apresente o plano PPREVC para esta feature"
```

## Exceções da Lei 15

O protocolo PPREVC pode ser relaxado apenas em:

1. **Fixes triviais**: Typos, ajustes de CSS
2. **Protótipos descartáveis**: Usuário pede explicitamente "quick and dirty"
3. **Debug emergencial**: Sistema em produção quebrado

**Nesses casos, o agente deve AVISAR que está pulando o protocolo.**

---

## 📚 Recursos Adicionais

- **14 Leis Completas**: `14-rules-ides-agenticas-v2LionLab.md`
- **Rules Individuais**: `.agent/rules/rule-*.md`
- **Skills**: `skills/` (lazy loading)
- **README**: `README.md` (guia completo)

## 🆘 Suporte

Dúvidas ou problemas?

1. Consulte o `README.md`
2. Leia as leis em `.agent/rules/`
3. Abra uma issue no GitHub

---

**Versão**: 2.0 (com Lei 15 - PPREVC)  
**Autor**: Breno Vieira Silva - Lion Lab Academy  
**Website**: [www.lionlabs.com.br](https://www.lionlabs.com.br)
