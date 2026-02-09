import { NextRequest, NextResponse } from "next/server";
import bcrypt from "bcrypt";
import { RegisterSchema } from "@/lib/validations/auth";
import { supabaseServer } from "@/lib/supabase/server";
import { createSession } from "@/lib/session";

/**
 * LEI 15: Protocolo PPREVC
 * LEI 01: Isolamento de Segurança (Service Role apenas no backend)
 * LEI 03: Blindagem Multi-Tenant (company_id da sessão)
 * LEI 05: Hardening de Sessão (cookies seguros)
 * LEI 07: Higiene de Credenciais (bcrypt custo 12)
 * LEI 08: Tratamento de Erros com Contexto
 * LEI 11: Consistência de API REST (201 para criação)
 */

export async function POST(req: NextRequest) {
  try {
    // 1. Parse e valida o body (Lei 08: Fail Fast)
    const body = await req.json();
    const validation = RegisterSchema.safeParse(body);

    if (!validation.success) {
      return NextResponse.json(
        {
          error: {
            code: "VALIDATION_ERROR",
            message: "Dados inválidos",
            fields: validation.error.flatten().fieldErrors,
          },
        },
        { status: 400 }
      );
    }

    const { name, email, password } = validation.data;

    // 2. Verifica se o email já existe
    const { data: existingUser } = await supabaseServer
      .from("users")
      .select("id")
      .eq("email", email)
      .single();

    if (existingUser) {
      return NextResponse.json(
        {
          error: {
            code: "EMAIL_ALREADY_EXISTS",
            message: "Este email já está cadastrado",
            field: "email",
          },
        },
        { status: 409 }
      );
    }

    // 3. Hash da senha com bcrypt (Lei 07: custo 12)
    const passwordHash = await bcrypt.hash(password, 12);

    // 4. Cria o usuário no banco
    // Lei 03: Se você tem multi-tenancy, extraia company_id da sessão aqui
    const { data: newUser, error: insertError } = await supabaseServer
      .from("users")
      .insert({
        name,
        email,
        password_hash: passwordHash,
        // company_id: session.user?.company_id, // Descomente se usar multi-tenancy
      })
      .select("id, email, name, company_id, created_at")
      .single();

    if (insertError || !newUser) {
      console.error("Database error:", insertError);
      return NextResponse.json(
        {
          error: {
            code: "DATABASE_ERROR",
            message: "Erro ao criar usuário. Tente novamente.",
          },
        },
        { status: 500 }
      );
    }

    // 5. Cria sessão segura (Lei 05)
    await createSession({
      id: newUser.id,
      email: newUser.email,
      name: newUser.name,
      company_id: newUser.company_id || undefined,
    });

    // 6. Retorna usuário criado (sem password_hash!)
    return NextResponse.json(
      {
        user: {
          id: newUser.id,
          email: newUser.email,
          name: newUser.name,
          company_id: newUser.company_id,
          created_at: newUser.created_at,
        },
        message: "Usuário criado com sucesso",
      },
      { status: 201 }
    );
  } catch (error) {
    // Lei 08: Logs técnicos detalhados, mensagem amigável para o usuário
    console.error("Registration error:", error);
    
    return NextResponse.json(
      {
        error: {
          code: "INTERNAL_SERVER_ERROR",
          message: "Erro interno do servidor. Tente novamente mais tarde.",
        },
      },
      { status: 500 }
    );
  }
}
