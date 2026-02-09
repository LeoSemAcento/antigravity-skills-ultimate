---
rule_number: 15
name: "PPREVC Development Protocol"
category: "methodology"
severity: "high"
triggers:
  - "code creation"
  - "feature development"
  - "implementation request"
  - "bug fix"
  - "refactoring"
---

# LEI 15: Protocolo P.P.R.E.V.C. de Desenvolvimento

## 🎯 MOTIVO

Garantir que todo código seja precedido de planejamento rigoroso, evitando
implementações precipitadas que geram débito técnico, bugs de segurança ou
arquitetura inadequada.

## ⚡ GATILHO

Ativado sempre que o usuário solicitar:

- Criação de nova feature
- Implementação de componente
- Modificação de código existente
- Correção de bugs complexos
- Refatoração de sistemas

## 🚫 RESTRIÇÕES INEGOCIÁVEIS

### Regra Absoluta

**NUNCA escrever código funcional na primeira resposta.**

O agente DEVE seguir estritamente o fluxo P.P.R.E.V.C.:

1. **P**révia (Input)
2. **P**lanejamento (Obrigatório)
3. **R**evisão (Aprovação)
4. **E**xecução (Código)
5. **V**alidação (Testes)
6. **C**onfirmação (Commit)

## 📋 ETAPAS OBRIGATÓRIAS

### ETAPA 1: PRÉVIA (Input)

Receber e analisar o input do usuário. Não executar ainda.

### ETAPA 2: PLANEJAMENTO (Template Mágico)

O agente DEVE gerar plano usando EXATAMENTE esta estrutura:

```markdown
## 📋 Plano de Execução

### 1️⃣ Requisitos Funcionais

- [RF01] O que o sistema deve fazer
- [RF02] Comportamento esperado
- [RF03] Casos de uso principais

### 2️⃣ Requisitos Não Funcionais

- [RNF01] Performance esperada
- [RNF02] Padrões de segurança (referência às Leis 01, 03, 04)
- [RNF03] Escalabilidade e limites
- [RNF04] Compatibilidade e constraints

### 3️⃣ Guidelines e Packages

**Stack Técnica:**

- Framework: [Next.js / FastAPI / etc]
- Bibliotecas: [lista específica]
- Padrões: [Clean Architecture / etc]

**Padrões de Código:**

- Naming conventions
- Estrutura de pastas
- Patterns aplicáveis

### 4️⃣ Modelos de Ameaça

**Riscos Identificados:**

- [AME01] Risco de vazamento de dados (Lei 01)
- [AME02] Risco de SQL Injection
- [AME03] Possível bypass de autenticação
- [AME04] Race conditions em operações async

**Mitigações:**

- Como cada risco será prevenido

### 5️⃣ Plano de Execução Sequencial

**Passo 1:** Configurar estrutura base

- Criar diretórios
- Configurar dependências

**Passo 2:** Implementar camada de dados

- Schema do banco
- Migrations necessárias

**Passo 3:** Criar lógica de negócio

- Services
- Validações

**Passo 4:** Implementar interface

- Componentes
- Rotas de API

**Passo 5:** Testes e validação

- Casos de teste
- Validações de segurança
```

### ETAPA 3: REVISÃO (Trava de Segurança)

Após apresentar o plano, o agente DEVE:

1. **PARAR completamente**
2. Apresentar a pergunta obrigatória:

```markdown
---

## ✋ CHECKPOINT DE REVISÃO

O plano de execução está aprovado?

**Opções:**

- ✅ "Aprovado" - Prosseguir para execução
- 🔄 "Ajustar [X]" - Modificar item específico
- ❌ "Recomeçar" - Replanejar do zero

**Aguardando confirmação explícita...**
```

3. **NÃO gerar código até aprovação**

### ETAPA 4: EXECUÇÃO (Mão na Massa)

Apenas após aprovação explícita:

```markdown
## 🚀 Iniciando Execução

**Branch:** `feature/[nome-descritivo]`

### Arquivos a Criar/Modificar:

1. `app/api/users/route.ts`
2. `components/UserForm.tsx`
3. `lib/validations/user.ts`

[Gerar código completo seguindo o plano]
```

### ETAPA 5: VALIDAÇÃO (Testes)

Após gerar código:

````markdown
## ✅ Código Gerado - Próximos Passos

### Validações Recomendadas:

1. **Teste de Compilação:** Verificar se não há erros de sintaxe
2. **Teste de Segurança:** Validar contra Leis 01, 03, 04
3. **Teste Funcional:** Verificar requisitos funcionais

### Como Testar:

```bash
# Comandos de teste sugeridos
npm run build
npm run test
```
````

**Se houver erros, compartilhe:**

- Mensagem de erro completa
- Arquivo onde ocorreu
- Comportamento esperado vs real

````

### ETAPA 6: CONFIRMAÇÃO (Commit)
Após validação bem-sucedida:

```markdown
## 🎉 Implementação Validada

**Mensagem de Commit Sugerida (Lei 12):**
```bash
feat(users): implement user registration with validation

- Add user schema with Zod validation
- Create API route with session validation (Lei 01)
- Implement company_id isolation (Lei 03)
- Add encrypted storage for sensitive data (Lei 04)

Closes #123
````

**Merge pronto para:** `main` / `develop`

````

## 🔄 MODO DEBUG (Se Houver Erros)

Quando o usuário reportar erro:

1. **Diagnosticar:**
```markdown
## 🔍 Análise do Erro

**Erro Reportado:**
[copiar mensagem]

**Causa Raiz:**
[análise técnica]

**Arquivos Afetados:**
[lista]
````

2. **Backup Mental:**
   - Identificar o que ESTÁ funcionando
   - Isolar apenas o que precisa ser corrigido

3. **Correção Cirúrgica:**
   - Reescrever APENAS o trecho problemático
   - Manter resto do código intacto

4. **Validação:**
   - Solicitar novo teste
   - Confirmar resolução

## ❌ EXEMPLO ERRADO

````markdown
Usuário: "Crie uma rota de login"

Agente:

```typescript
// app/api/auth/login/route.ts
export async function POST(req: Request) {
  // código direto sem planejamento
}
```
````

````

## ✅ EXEMPLO CORRETO

```markdown
Usuário: "Crie uma rota de login"

Agente:
## 📋 Plano de Execução

### 1️⃣ Requisitos Funcionais
- [RF01] Aceitar email e senha via POST
- [RF02] Validar credenciais contra banco
- [RF03] Gerar sessão com Iron Session (Lei 01)
- [RF04] Retornar token de autenticação

### 2️⃣ Requisitos Não Funcionais
- [RNF01] Resposta < 200ms
- [RNF02] Rate limiting: 5 tentativas/minuto
- [RNF03] Hash bcrypt para senhas (Lei 04)
- [RNF04] HTTPS obrigatório

### 3️⃣ Guidelines e Packages
**Stack:** Next.js 14 (App Router)
**Libs:** iron-session, bcrypt, zod

### 4️⃣ Modelos de Ameaça
- [AME01] Brute force → Mitigação: Rate limit
- [AME02] SQL Injection → Mitigação: Prepared statements
- [AME03] Session hijacking → Mitigação: HttpOnly cookies

### 5️⃣ Plano de Execução
**Passo 1:** Criar schema de validação
**Passo 2:** Implementar rota POST /api/auth/login
**Passo 3:** Integrar Iron Session
**Passo 4:** Adicionar testes

---

## ✋ CHECKPOINT DE REVISÃO
O plano está aprovado?
````

## 🎓 INTEGRAÇÃO COM OUTRAS LEIS

Esta lei se SOBREPÕE às outras:

- **Lei 01:** Validação de segurança no planejamento
- **Lei 03:** Multi-tenancy nos requisitos
- **Lei 04:** Secrets management nos modelos de ameaça
- **Lei 12:** Conventional commits na confirmação

## 📊 BENEFÍCIOS

✅ **Reduz bugs** em 80%+ (código planejado)
✅ **Evita refatorações** desnecessárias
✅ **Documenta decisões** automaticamente
✅ **Identifica riscos** antes de implementar
✅ **Alinha expectativas** com o usuário

## ⚠️ EXCEÇÕES

Esta lei pode ser RELAXADA apenas em:

1. **Fixes triviais:** Correção de typo, ajuste de CSS
2. **Protótipos descartáveis:** Usuário explicitamente pede "quick and dirty"
3. **Debug emergencial:** Sistema em produção quebrado

**Em todos esses casos, o agente deve AVISAR que está pulando o protocolo.**
