# 15 Rules para IDEs Agenticas

### Cursor | Antigravity | Claude Code | Windsurf | Cline

Autor: Breno Vieira Silva - Lion Lab Academy
Versao: 1.0
Licenca: Livre para uso e modificacao

## www.lionlabs.com.br

## Indice

1. rule-01-security-isolation.md
2. rule-02-async-performance.md
3. rule-03-multi-tenant-shield.md
4. rule-04-secrets-vault.md
5. rule-05-session-hardening.md
6. rule-06-clean-architecture.md
7. rule-07-credential-hygiene.md
8. rule-08-error-handling.md
9. rule-09-dependency-hygiene.md
10. rule-10-test-first.md
11. rule-11-api-consistency.md
12. rule-12-commit-discipline.md
13. rule-13-env-isolation.md
14. rule-14-documentation-code.md
15. rule-15-pprevc-protocol.md

---

### Estrutura de Pastas

```
seu-projeto/
└── .agent/
    └── rules/
        ├── rule-01-security-isolation.md
        ├── rule-02-async-performance.md
        ├── rule-03-multi-tenant-shield.md
        └── ... (demais rules)
```

================================================================================
rule-01-security-isolation.md
LEI 01: Isolamento de Seguranca Smith
================================================================================

MOTIVO:
Impedir o erro historico de expor chaves sensiveis ou permitir que o frontend
ignore a camada de logica do backend.

GATILHO:
Ativado ao criar ou modificar arquivos em /app, /components, ou qualquer
codigo client-side que interaja com Supabase ou banco de dados.

RESTRICOES INEGOCIAVEIS:

- Proibicao de Service Role no Front: Nunca, sob qualquer pretexto, utilize a
  SUPABASE_SERVICE_ROLE_KEY em arquivos dentro de /app ou /components.
- Zero Supabase Direct Writing: O frontend nao deve realizar operacoes de
  escrita (insert, update, delete) diretamente via cliente Supabase do lado
  do cliente. Toda alteracao de estado deve passar por uma rota de API (/api/\*)
  que valide a sessao.
- Headers de Seguranca: Toda nova rota ou middleware deve manter os headers
  de CSP e Anti-Clickjacking (frame-ancestors 'none' para admin, '\*' apenas
  para /embed).

PADRAO DE AUTENTICACAO:

- Use sempre getIronSession com AES-256-GCM para verificar a identidade do
  usuario no Next.js.

EXEMPLO ERRADO:

```typescript
// app/components/AdminPanel.tsx
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!, // VAZAMENTO DE PRIVILEGIO!
);

export function AdminPanel() {
  const deleteUser = async (id: string) => {
    await supabase.from("users").delete().eq("id", id); // Escrita direta!
  };
}
```

EXEMPLO CORRETO:

```typescript
// app/components/AdminPanel.tsx
export function AdminPanel() {
  const deleteUser = async (id: string) => {
    await fetch("/api/admin/users", {
      method: "DELETE",
      body: JSON.stringify({ userId: id }),
      credentials: "include",
    });
  };
}

// app/api/admin/users/route.ts
import { getIronSession } from "iron-session";

export async function DELETE(req: Request) {
  const session = await getIronSession(cookies(), sessionOptions);

  if (!session.user?.isAdmin) {
    return Response.json({ error: "Forbidden" }, { status: 403 });
  }

  const supabase = createClient(url, process.env.SUPABASE_SERVICE_ROLE_KEY!);
  // ... delete logic seguro no servidor
}
```

================================================================================
rule-02-async-performance.md
LEI 02: Performance e Concorrencia Async
================================================================================

MOTIVO:
Garantir que o servidor FastAPI nunca trave por operacoes bloqueantes (I/O sincrono).

GATILHO:
Ativado sempre que o agente for criar ou modificar arquivos em /backend/app/api
ou /backend/app/services.

DIRETRIZES TECNICAS:

- Async First: Toda comunicacao com banco de dados, Redis ou APIs externas
  (OpenAI, Anthropic, Gemini) DEVE ser async.
- Proibicao de Codigo Bloqueante: Nunca use time.sleep() ou bibliotecas
  sincronas (como requests) dentro das rotas do FastAPI. Use asyncio.sleep()
  e httpx.AsyncClient().
- Background Tasks: Operacoes de longa duracao (billing, processamento de PDFs,
  treinamento de agentes) devem ser delegadas para Celery Workers standalone.

EXEMPLO ERRADO:

```python
from fastapi import FastAPI
import requests
import time

app = FastAPI()

@app.get("/fetch-data")
def fetch_data():
    time.sleep(2)  # Bloqueia o event loop!
    response = requests.get("https://api.externa.com/data")  # Bloqueante!
    return response.json()
```

EXEMPLO CORRETO:

```python
from fastapi import FastAPI
import httpx
import asyncio

app = FastAPI()

@app.get("/fetch-data")
async def fetch_data():
    await asyncio.sleep(2)  # Nao bloqueia
    async with httpx.AsyncClient() as client:
        response = await client.get("https://api.externa.com/data")
    return response.json()

# Para operacoes longas:
from app.workers.tasks import process_heavy_pdf

@app.post("/process-document")
async def process_document(file_id: str):
    process_heavy_pdf.delay(file_id)  # Delega para Celery
    return {"status": "processing", "file_id": file_id}
```

================================================================================
rule-03-multi-tenant-shield.md
LEI 03: Blindagem Multi-Tenant
================================================================================

MOTIVO:
Evitar o vazamento de dados entre empresas (a falha de expor UID de outra empresa).

GATILHO:
Ativado ao criar queries de banco de dados, migrations SQL, ou qualquer codigo
que acesse dados de usuarios/empresas.

VERIFICACOES OBRIGATORIAS:

- Clausula de Empresa: Toda e qualquer query ao banco de dados DEVE incluir
  explicitamente .eq('company_id', company_id).
- Origem da Identidade: O company_id nunca deve ser aceito como parametro
  vindo livremente do frontend (JSON body). Ele deve ser extraido
  obrigatoriamente do objeto de sessao autenticado (require_authenticated_user
  no FastAPI ou Iron Session no Next.js).
- RLS Enforcer: Ao sugerir novas tabelas em migracoes SQL, inclua sempre
  ENABLE ROW LEVEL SECURITY com politicas baseadas em auth.uid() ou company_id.

EXEMPLO ERRADO:

```python
from fastapi import APIRouter

router = APIRouter()

@router.get("/agents")
async def list_agents(company_id: str):  # company_id vem do query param!
    agents = await supabase.from_("agents") \
        .select("*") \
        .eq("company_id", company_id) \
        .execute()
    return agents.data
```

EXEMPLO CORRETO:

```python
from fastapi import APIRouter, Depends
from app.auth.dependencies import require_authenticated_user
from app.auth.schemas import AuthenticatedUser

router = APIRouter()

@router.get("/agents")
async def list_agents(
    user: AuthenticatedUser = Depends(require_authenticated_user)
):
    # company_id SEMPRE da sessao, nunca do request
    agents = await supabase.from_("agents") \
        .select("*") \
        .eq("company_id", user.company_id) \
        .execute()
    return agents.data
```

EXEMPLO SQL COM RLS:

```sql
CREATE TABLE agents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES companies(id),
    name TEXT NOT NULL
);

ALTER TABLE agents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation" ON agents
    FOR ALL
    USING (company_id = auth.jwt()->>'company_id');
```

================================================================================
rule-04-secrets-vault.md
LEI 04: Cofre de Segredos (Secrets Management)
================================================================================

MOTIVO:
Garantir que chaves de API de terceiros nunca fiquem em texto puro no banco de dados.

GATILHO:
Ativado ao manipular API keys, tokens, credenciais, ou criar logs que possam
conter dados sensiveis.

REGRAS DE IMPLEMENTACAO:

- Criptografia em Repouso: API Keys de provedores (OpenAI, Anthropic, Shopify)
  salvas nas tabelas agents ou companies devem ser criptografadas via
  EncryptionService antes do INSERT.
- Sanitizacao de Logs: O agente de desenvolvimento esta proibido de sugerir
  logs que imprimam variaveis de ambiente sensiveis ou dados PII (e-mail, CPF).
- Env Var Validation: Toda nova variavel de ambiente critica deve ser validada
  no startup (ex: ENCRYPTION_KEY deve ser Base64 URL-safe).

EXEMPLO ERRADO:

```python
async def save_agent(agent_data: dict):
    await supabase.from_("agents").insert({
        "name": agent_data["name"],
        "openai_api_key": agent_data["api_key"],  # Texto puro!
    }).execute()

    print(f"Agent criado com key: {agent_data['api_key']}")  # Log expondo!
```

EXEMPLO CORRETO:

```python
from app.services.encryption import EncryptionService

encryption = EncryptionService()

async def save_agent(agent_data: dict):
    encrypted_key = encryption.encrypt(agent_data["api_key"])

    await supabase.from_("agents").insert({
        "name": agent_data["name"],
        "openai_api_key_encrypted": encrypted_key,
    }).execute()

    logger.info(f"Agent criado: {agent_data['name']}")  # Sem dados sensiveis
```

VALIDACAO NO STARTUP:

```python
import base64
import os

class Settings:
    def __init__(self):
        self.encryption_key = os.getenv("ENCRYPTION_KEY")

        if not self.encryption_key:
            raise ValueError("ENCRYPTION_KEY nao configurada")

        try:
            base64.urlsafe_b64decode(self.encryption_key)
        except Exception:
            raise ValueError("ENCRYPTION_KEY deve ser Base64 URL-safe")
```

================================================================================
rule-05-session-hardening.md
LEI 05: Hardening de Sessao
================================================================================

MOTIVO:
Protecao contra ataques de sessao e sequestro de cookies.

GATILHO:
Ativado ao configurar cookies, sessoes, middleware de autenticacao, ou
logica de login/logout.

PADROES DE COOKIE:

- Atributos: Todos os cookies de sessao devem obrigatoriamente ter
  httpOnly: true, secure: true (em prod) e sameSite: 'lax'.
- Expiracao Dinamica: Use a logica de expiracao controlada para diferenciar
  sessoes curtas de sessoes "lembrar-me".
- Cleanup no Middleware: Em caso de sessao invalida ou expirada, o middleware
  deve garantir o cookies().delete() para evitar estados inconsistentes.

EXEMPLO ERRADO:

```typescript
export const sessionOptions = {
  cookieName: "session",
  password: process.env.SESSION_SECRET!,
  cookieOptions: {
    secure: false, // Funciona em HTTP!
    httpOnly: false, // Acessivel via JS (XSS)!
    sameSite: "none", // Enviado em qualquer request!
  },
};
```

EXEMPLO CORRETO:

```typescript
export const sessionOptions = {
  cookieName: "__Host-session",
  password: process.env.SESSION_SECRET!,
  cookieOptions: {
    secure: process.env.NODE_ENV === "production",
    httpOnly: true,
    sameSite: "lax" as const,
    maxAge: 60 * 60 * 24 * 7, // 7 dias
  },
};

// Logica de "lembrar-me"
export function getSessionTTL(rememberMe: boolean): number {
  return rememberMe
    ? 60 * 60 * 24 * 30 // 30 dias
    : 60 * 60 * 24; // 1 dia
}
```

CLEANUP NO MIDDLEWARE:

```typescript
export async function middleware(request: NextRequest) {
  const session = await getIronSession(cookies(), sessionOptions);

  if (session.expiresAt && Date.now() > session.expiresAt) {
    session.destroy();
    cookies().delete(sessionOptions.cookieName);
    return NextResponse.redirect(new URL("/login", request.url));
  }
}
```

================================================================================
rule-06-clean-architecture.md
LEI 06: Arquitetura Limpa Smith
================================================================================

MOTIVO:
Combater o codigo sujo e a duplicacao de logica (o "copia e cola" do passado).

GATILHO:
Ativado ao criar novos arquivos de routers, services, ou ao adicionar logica
de negocio em qualquer camada.

ESTRUTURA DE CAMADAS:

- Services (Logica de Negocio): Regras complexas (calculo de preco, RAG,
  processamento de WhatsApp) residem estritamente em /app/services/.
- Routers (Interface): Rotas de API devem apenas validar o input e chamar
  os servicos necessarios.
- DRY (Don't Repeat Yourself): Se a logica de calculo de tokens ou billing
  for necessaria em mais de um lugar, ela deve ser centralizada no
  UsageService ou BillingCore.

EXEMPLO ERRADO:

```python
# app/api/billing/router.py - logica de negocio no router!
@router.post("/charge")
async def charge_customer(customer_id: str, amount: float):
    customer = await supabase.from_("customers").select("*").eq("id", customer_id).single().execute()

    if customer.data["plan"] == "free":
        discount = 0
    elif customer.data["plan"] == "pro":
        discount = 0.1
    else:
        discount = 0.2

    final_amount = amount * (1 - discount)
    tokens_used = int(amount / 0.001)
    # ... mais 50 linhas de logica
```

EXEMPLO CORRETO:

```python
# app/services/billing_service.py
class BillingService:
    def __init__(self, usage_service: UsageService):
        self.usage = usage_service

    def calculate_discount(self, plan: str) -> float:
        discounts = {"free": 0, "pro": 0.1, "enterprise": 0.2}
        return discounts.get(plan, 0)

    async def charge(self, customer_id: str, amount: float) -> ChargeResult:
        customer = await self.get_customer(customer_id)
        discount = self.calculate_discount(customer.plan)
        final_amount = amount * (1 - discount)
        tokens = self.usage.calculate_tokens(amount)
        return ChargeResult(amount=final_amount, tokens=tokens)

# app/api/billing/router.py - router so valida e delega
@router.post("/charge")
async def charge_customer(
    request: ChargeRequest,
    billing: BillingService = Depends()
):
    result = await billing.charge(request.customer_id, request.amount)
    return result
```

================================================================================
rule-07-credential-hygiene.md
LEI 07: Higiene de Credenciais
================================================================================

MOTIVO:
Impedir o erro de usar senhas fracas ou hashes obsoletos.

GATILHO:
Ativado ao implementar cadastro de usuarios, login, reset de senha, ou
qualquer funcao que manipule senhas e tokens de acesso.

REQUISITOS DE SENHA:

- Hashing: Use estritamente bcrypt com fator de custo 12. Hashes SHA-256
  legados devem ser marcados para migracao imediata no proximo login.
- Complexidade: Valide obrigatoriamente: 8+ caracteres, 1 maiuscula,
  1 minuscula e 1 numero.
- Tokens Seguros: Geradores de tokens de convite ou reset devem usar
  secrets.token_urlsafe(32).

EXEMPLO ERRADO:

```python
import hashlib
import random

def create_user(email: str, password: str):
    # SHA-256 e rapido demais (brute-force facil)
    password_hash = hashlib.sha256(password.encode()).hexdigest()
    save_user(email, password_hash)  # Sem validacao de complexidade

def generate_reset_token():
    return str(random.randint(100000, 999999))  # Random previsivel!
```

EXEMPLO CORRETO:

```python
import bcrypt
import secrets
import re

class PasswordPolicy:
    MIN_LENGTH = 8
    PATTERN = re.compile(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$')

    @classmethod
    def validate(cls, password: str) -> tuple[bool, str | None]:
        if len(password) < cls.MIN_LENGTH:
            return False, f"Minimo {cls.MIN_LENGTH} caracteres"
        if not cls.PATTERN.match(password):
            return False, "Deve conter maiuscula, minuscula e numero"
        return True, None

def create_user(email: str, password: str):
    valid, error = PasswordPolicy.validate(password)
    if not valid:
        raise ValueError(error)

    password_hash = bcrypt.hashpw(
        password.encode(),
        bcrypt.gensalt(rounds=12)
    ).decode()

    save_user(email, password_hash)

def generate_reset_token() -> str:
    return secrets.token_urlsafe(32)
```

================================================================================
rule-08-error-handling.md
LEI 08: Tratamento de Erros com Contexto
================================================================================

MOTIVO:
Evitar debugging as cegas por falta de stack trace, correlation IDs ou
mensagens genericas.

GATILHO:
Ativado ao criar ou modificar blocos try/catch, handlers de excecao ou
middleware de erro.

PRINCIPIOS OBRIGATORIOS:

- Zero Swallow: Nunca capture excecoes sem logar ou re-lancar.
  except: pass e catch(e) {} sao estritamente proibidos.
- Correlation ID: Toda requisicao HTTP deve carregar um X-Request-ID que
  propaga entre servicos e aparece em todos os logs relacionados.
- Separacao de Audiencia: Mensagens de erro para usuario final devem ser
  amigaveis. Logs tecnicos devem conter stack trace completo, variaveis
  de contexto e timestamp ISO8601.
- Fail Fast: Valide inputs no inicio da funcao. Nao processe dados
  invalidos para falhar depois.

EXEMPLO ERRADO:

```python
async def process_payment(payment_id: str):
    try:
        result = await stripe.charges.create(...)
        return result
    except Exception:
        pass  # Erro silencioso!

    try:
        data = json.loads(response.text)
    except:
        return {"error": "Algo deu errado"}  # Mensagem inutil!
```

EXEMPLO CORRETO:

```python
import structlog
from uuid import uuid4

logger = structlog.get_logger()

class PaymentError(Exception):
    def __init__(self, message: str, payment_id: str, original_error: Exception = None):
        self.message = message
        self.payment_id = payment_id
        self.original_error = original_error
        super().__init__(message)

async def process_payment(payment_id: str, request_id: str = None):
    request_id = request_id or str(uuid4())
    log = logger.bind(request_id=request_id, payment_id=payment_id)

    try:
        log.info("payment.processing.started")
        result = await stripe.charges.create(...)
        log.info("payment.processing.success", amount=result.amount)
        return result

    except stripe.error.CardError as e:
        log.error(
            "payment.processing.card_declined",
            error_code=e.code,
            decline_code=e.decline_code,
            exc_info=True
        )
        raise PaymentError(
            message="Cartao recusado. Verifique os dados ou tente outro cartao.",
            payment_id=payment_id,
            original_error=e
        )
```

================================================================================
rule-09-dependency-hygiene.md
LEI 09: Higiene de Dependencias
================================================================================

MOTIVO:
Prevenir supply chain attacks e acumulo de vulnerabilidades em pacotes
desatualizados ou maliciosos.

GATILHO:
Ativado ao sugerir npm install, pip install, cargo add ou qualquer adicao
ao package.json/requirements.txt/Cargo.toml.

CRITERIOS DE ACEITACAO:

- Freshness: So sugira pacotes com ultima release < 12 meses.
- Popularity Threshold: Prefira pacotes com >1000 downloads semanais (npm)
  ou >500 stars (GitHub).
- Security Scan: Antes de adicionar dependencia, execute npm audit /
  pip-audit / cargo audit e rejeite pacotes com CVEs criticos ou altos.
- Minimal Footprint: Evite dependencias para funcoes triviais
  (ex: nao use left-pad, is-odd).

WORKFLOW DO AGENTE:

```
1. Verificar vulnerabilidades:
   $ pip-audit nome-do-pacote

2. Verificar popularidade e manutencao:
   - Downloads/semana: 50,000+
   - Ultima release: < 12 meses
   - GitHub stars: 2,000+
   - Maintainers ativos: 2+

3. Verificar se e realmente necessario:
   - Funcionalidade trivial? -> Implemente inline
   - Ja existe no stdlib? -> Use stdlib
```

EXEMPLO - FUNCAO TRIVIAL:

```python
# NAO FACA ISSO:
# import is_odd

# FACA ISSO:
def is_odd(n: int) -> bool:
    return n % 2 != 0
```

================================================================================
rule-10-test-first.md
LEI 10: Testes Antes da Implementacao
================================================================================

MOTIVO:
Garantir que o codigo gerado atenda aos requisitos definidos e nao apenas
"pareca funcionar".

GATILHO:
Ativado quando o usuario pedir nova feature, endpoint ou funcao de negocio.

WORKFLOW OBRIGATORIO:

1. Red: Escreva testes que definem o comportamento esperado.
   Eles DEVEM falhar inicialmente.
2. Green: Implemente o codigo minimo necessario para os testes passarem.
3. Refactor: Melhore a estrutura mantendo os testes verdes.

COBERTURA MINIMA:

- Funcoes de negocio: 80% de cobertura
- Edge cases obrigatorios: null/undefined, array vazio, strings vazias,
  limites numericos
- Casos de erro: pelo menos 1 teste de excecao por funcao que pode falhar

EXEMPLO:

```python
# 1. PRIMEIRO: Escreva os testes
# tests/test_discount.py
import pytest
from app.services.pricing import calculate_discount, InvalidCouponError

class TestCalculateDiscount:
    def test_valid_coupon_applies_discount(self):
        assert calculate_discount(100.0, "SAVE10") == 90.0

    def test_no_coupon_returns_original_price(self):
        assert calculate_discount(100.0, None) == 100.0

    def test_invalid_coupon_raises_error(self):
        with pytest.raises(InvalidCouponError):
            calculate_discount(100.0, "FAKE123")

    def test_negative_price_raises_error(self):
        with pytest.raises(ValueError):
            calculate_discount(-50.0, "SAVE10")

# 2. DEPOIS: Implemente para passar os testes
# app/services/pricing.py
def calculate_discount(price: float, coupon_code: str | None) -> float:
    if price < 0:
        raise ValueError("Preco nao pode ser negativo")

    if not coupon_code:
        return price

    coupon = COUPONS.get(coupon_code.upper())
    if not coupon:
        raise InvalidCouponError(f"Cupom invalido: {coupon_code}")

    return price * (1 - coupon["discount"])
```

================================================================================
rule-11-api-consistency.md
LEI 11: Consistencia de API REST
================================================================================

MOTIVO:
APIs previsiveis reduzem erros de integracao e facilitam onboarding de novos devs.

GATILHO:
Ativado ao criar routers, controllers ou endpoints de API.

CONVENCOES DE ROTAS:

```
| Acao      | Metodo | Rota             | Response        |
|-----------|--------|------------------|-----------------|
| Listar    | GET    | /resources       | 200 + array     |
| Detalhe   | GET    | /resources/:id   | 200 + objeto    |
| Criar     | POST   | /resources       | 201 + objeto    |
| Atualizar | PATCH  | /resources/:id   | 200 + objeto    |
| Substituir| PUT    | /resources/:id   | 200 + objeto    |
| Deletar   | DELETE | /resources/:id   | 204 (no content)|
```

PADRAO DE RESPOSTA DE ERRO:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email invalido",
    "field": "email",
    "request_id": "req_abc123"
  }
}
```

EXEMPLO ERRADO:

```python
@app.get("/getUsers")           # verbo no path
@app.post("/user/create")       # singular + verbo
@app.post("/delete-user/{id}")  # POST pra delete?
```

EXEMPLO CORRETO:

```python
@router.get("")                              # GET /users
async def list_users(): ...

@router.get("/{user_id}")                    # GET /users/:id
async def get_user(user_id: UUID): ...

@router.post("", status_code=201)            # POST /users
async def create_user(payload: UserCreate): ...

@router.patch("/{user_id}")                  # PATCH /users/:id
async def update_user(user_id: UUID, payload: UserUpdate): ...

@router.delete("/{user_id}", status_code=204) # DELETE /users/:id
async def delete_user(user_id: UUID): ...
```

================================================================================
rule-12-commit-discipline.md
LEI 12: Disciplina de Commits
================================================================================

MOTIVO:
Historico legivel facilita debugging, code review e geracao de changelogs automaticos.

GATILHO:
Ativado ao gerar mensagens de commit ou preparar releases.

FORMATO OBRIGATORIO (Conventional Commits):

```
<type>(<scope>): <description>

[body opcional]

[footer opcional]
```

TYPES PERMITIDOS:

- feat: nova funcionalidade
- fix: correcao de bug
- docs: apenas documentacao
- style: formatacao (nao altera logica)
- refactor: mudanca de codigo sem alterar comportamento
- test: adicao ou correcao de testes
- chore: manutencao, configs, deps

REGRAS ADICIONAIS:

- Description em minusculo, sem ponto final
- Maximo 72 caracteres na primeira linha
- Body explica "o que" e "por que", nao "como"

EXEMPLOS ERRADOS:

```bash
git commit -m "fix"
git commit -m "wip"
git commit -m "changes"
git commit -m "asdfasdf"
```

EXEMPLOS CORRETOS:

```bash
git commit -m "feat(auth): add Google OAuth2 login flow"
git commit -m "fix(billing): correct tax calculation for EU customers"
git commit -m "docs(api): add examples for webhook endpoints"
git commit -m "chore(deps): upgrade fastapi to 0.109.0"
```

================================================================================
rule-13-env-isolation.md
LEI 13: Isolamento de Ambientes
================================================================================

MOTIVO:
Prevenir vazamento de dados de producao para dev e execucao acidental de
codigo destrutivo no ambiente errado.

GATILHO:
Ativado ao configurar variaveis de ambiente, connection strings ou deploy configs.

SEGREGACAO OBRIGATORIA:

- Bancos Separados: Cada ambiente (dev, staging, prod) DEVE ter seu proprio
  banco de dados. Nunca compartilhe.
- Prefixos de Variaveis: Use prefixos claros: DEV*, STAGING*, PROD\_ para
  diferenciar configs.
- Feature Flags: Codigo nao finalizado deve estar atras de feature flags,
  nunca commitado diretamente em main/master.

PROIBICOES:

- Hardcode de URLs de producao em codigo fonte
- Uso de dados reais de clientes em ambiente de desenvolvimento
- Conexao de ambiente local com banco de producao

ARQUIVOS DE ENV SEPARADOS:

```bash
# .env.development
DEV_DATABASE_URL=postgresql://localhost/myapp_dev
DEV_STRIPE_KEY=sk_test_xxxxx

# .env.production (NUNCA commitado)
PROD_DATABASE_URL=postgresql://prod-db.internal/myapp
PROD_STRIPE_KEY=sk_live_xxxxx
```

VALIDACAO NO CODIGO:

```python
class Settings:
    def __init__(self):
        self.env = Environment(os.getenv("APP_ENV", "development"))
        self.prefix = self.env.name + "_"

        self.database_url = os.getenv(f"{self.prefix}DATABASE_URL")
        self.stripe_key = os.getenv(f"{self.prefix}STRIPE_KEY")

        # Validacao: nao permitir key de prod em dev
        if self.env == Environment.DEV and "live" in self.stripe_key:
            raise ValueError("Chave de producao detectada em ambiente dev!")
```

PROTECAO EM SCRIPTS:

```python
async def seed_test_data():
    settings = Settings()

    if settings.env == Environment.PROD:
        raise RuntimeError("SEED BLOQUEADO EM PRODUCAO!")

    await db.execute("DELETE FROM users")
```

================================================================================
rule-14-documentation-code.md
LEI 14: Documentacao como Codigo
================================================================================

MOTIVO:
Codigo auto-documentado reduz overhead de manutencao e evita docs desatualizados.

GATILHO:
Ativado ao criar funcoes, classes, modulos ou arquivos README.

HIERARQUIA DE CLAREZA:

1. Nomes Descritivos: Prefira user_email sobre ue, calculate_monthly_revenue
   sobre calc.
2. Funcoes Pequenas: Cada funcao deve fazer UMA coisa. Se precisar de "e"
   na descricao, quebre em duas.
3. Docstrings Obrigatorios: Toda funcao publica deve ter docstring com:
   descricao, parametros, retorno, excecoes.
4. README Vivo: Deve conter: setup, exemplos de uso, arquitetura basica.

PROIBICOES:

- Comentarios que repetem o codigo (i += 1 # incrementa i)
- Codigo comentado (use git para historico)
- TODOs sem issue/ticket associado

EXEMPLO ERRADO:

```python
def calc(a, b, c, t):
    # calcula o valor
    x = a * b  # multiplica a por b
    if t:
        x = x - c  # subtrai c se t
    return x

# TODO: fix this later
# def old_calc():
#     ... 50 linhas comentadas ...
```

EXEMPLO CORRETO:

```python
def calculate_order_total(
    unit_price: Decimal,
    quantity: int,
    discount_amount: Decimal = Decimal("0"),
    apply_discount: bool = True
) -> Decimal:
    """
    Calcula o valor total de um pedido.

    Args:
        unit_price: Preco unitario do produto (deve ser >= 0)
        quantity: Quantidade de itens (deve ser >= 1)
        discount_amount: Valor absoluto do desconto a aplicar
        apply_discount: Se True, subtrai o desconto do total

    Returns:
        Valor total do pedido apos desconto (se aplicavel)

    Raises:
        ValueError: Se unit_price < 0 ou quantity < 1

    Example:
        >>> calculate_order_total(Decimal("10.00"), 3, Decimal("5.00"))
        Decimal("25.00")
    """
    if unit_price < 0:
        raise ValueError("Preco unitario nao pode ser negativo")
    if quantity < 1:
        raise ValueError("Quantidade deve ser pelo menos 1")

    subtotal = unit_price * quantity

    if apply_discount:
        return max(subtotal - discount_amount, Decimal("0"))

    return subtotal
```

rule-15-pprevc-protocol.md
LEI 15: Protocolo P.P.R.E.V.C. de Desenvolvimento

MOTIVO:
Garantir que todo código seja precedido de planejamento rigoroso, evitando
implementações precipitadas que geram débito técnico, bugs de segurança ou
arquitetura inadequada.

GATILHO:
Ativado sempre que o usuário solicitar:

- Criação de nova feature
- Implementação de componente
- Modificação de código existente
- Correção de bugs complexos
- Refatoração de sistemas

RESTRIÇÕES INEGOCIÁVEIS:

Regra Absoluta:
NUNCA escrever código funcional na primeira resposta.

O agente DEVE seguir estritamente o fluxo P.P.R.E.V.C.:

1. Prévia (Input)
2. Planejamento (Obrigatório)
3. Revisão (Aprovação)
4. Execução (Código)
5. Validação (Testes)
6. Confirmação (Commit)

ETAPAS OBRIGATÓRIAS:

ETAPA 1: PRÉVIA (Input)
Receber e analisar o input do usuário. Não executar ainda.

ETAPA 2: PLANEJAMENTO (Template Mágico)
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

ETAPA 3: REVISÃO (Trava de Segurança)
Após apresentar o plano, o agente DEVE:

1. PARAR completamente
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

3. NÃO gerar código até aprovação

ETAPA 4: EXECUÇÃO (Mão na Massa)
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

ETAPA 5: VALIDAÇÃO (Testes)
Após gerar código:

````markdown
## ✅ Código Gerado - Próximos Passos

### Validações Recomendadas:

1. Teste de Compilação: Verificar se não há erros de sintaxe
2. Teste de Segurança: Validar contra Leis 01, 03, 04
3. Teste Funcional: Verificar requisitos funcionais

### Como Testar:

```bash
# Comandos de teste sugeridos
npm run build
npm run test
```
````

Se houver erros, compartilhe:

- Mensagem de erro completa
- Arquivo onde ocorreu
- Comportamento esperado vs real

````

ETAPA 6: CONFIRMAÇÃO (Commit)
Após validação bem-sucedida:

```markdown
## 🎉 Implementação Validada

Mensagem de Commit Sugerida (Lei 12):
```bash
feat(users): implement user registration with validation

- Add user schema with Zod validation
- Create API route with session validation (Lei 01)
- Implement company_id isolation (Lei 03)
- Add encrypted storage for sensitive data (Lei 04)

Closes #123
````

Merge pronto para: `main` / `develop`

````

MODO DEBUG (Se Houver Erros):

Quando o usuário reportar erro:

1. Diagnosticar:
```markdown
## 🔍 Análise do Erro

Erro Reportado:
[copiar mensagem]

Causa Raiz:
[análise técnica]

Arquivos Afetados:
[lista]
````

2. Backup Mental:
   - Identificar o que ESTÁ funcionando
   - Isolar apenas o que precisa ser corrigido

3. Correção Cirúrgica:
   - Reescrever APENAS o trecho problemático
   - Manter resto do código intacto

4. Validação:
   - Solicitar novo teste
   - Confirmar resolução

EXEMPLO ERRADO:

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

EXEMPLO CORRETO:
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
Stack: Next.js 14 (App Router)
Libs: iron-session, bcrypt, zod

### 4️⃣ Modelos de Ameaça
- [AME01] Brute force → Mitigação: Rate limit
- [AME02] SQL Injection → Mitigação: Prepared statements
- [AME03] Session hijacking → Mitigação: HttpOnly cookies

### 5️⃣ Plano de Execução
Passo 1: Criar schema de validação
Passo 2: Implementar rota POST /api/auth/login
Passo 3: Integrar Iron Session
Passo 4: Adicionar testes

---

## ✋ CHECKPOINT DE REVISÃO
O plano está aprovado?
````

INTEGRAÇÃO COM OUTRAS LEIS:

Esta lei se SOBREPÕE às outras:

- Lei 01: Validação de segurança no planejamento
- Lei 03: Multi-tenancy nos requisitos
- Lei 04: Secrets management nos modelos de ameaça
- Lei 12: Conventional commits na confirmação

BENEFÍCIOS:

✅ Reduz bugs em 80%+ (código planejado)
✅ Evita refatorações desnecessárias
✅ Documenta decisões automaticamente
✅ Identifica riscos antes de implementar
✅ Alinha expectativas com o usuário

EXCEÇÕES:

Esta lei pode ser RELAXADA apenas em:

1. Fixes triviais: Correção de typo, ajuste de CSS
2. Protótipos descartáveis: Usuário explicitamente pede "quick and dirty"
3. Debug emergencial: Sistema em produção quebrado

Em todos esses casos, o agente deve AVISAR que está pulando o protocolo.
