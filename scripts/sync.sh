#!/bin/bash
# Sync script seguindo a Lei 12 (Disciplina de Commits)

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔄 Iniciando sincronização...${NC}"

# Verificar se há mudanças
if [[ -z $(git status -s) ]]; then
    echo -e "${GREEN}✅ Nenhuma mudança para commitar${NC}"
    exit 0
fi

# Mostrar status
echo -e "${YELLOW}📊 Status atual:${NC}"
git status -s

# Perguntar tipo de commit
echo -e "\n${YELLOW}Selecione o tipo de commit:${NC}"
echo "1) feat     - Nova funcionalidade"
echo "2) fix      - Correção de bug"
echo "3) docs     - Apenas documentação"
echo "4) style    - Formatação"
echo "5) refactor - Refatoração"
echo "6) test     - Testes"
echo "7) chore    - Manutenção/deps"

read -p "Tipo [1-7]: " commit_type_num

case $commit_type_num in
    1) commit_type="feat";;
    2) commit_type="fix";;
    3) commit_type="docs";;
    4) commit_type="style";;
    5) commit_type="refactor";;
    6) commit_type="test";;
    7) commit_type="chore";;
    *) echo -e "${RED}❌ Tipo inválido${NC}"; exit 1;;
esac

# Perguntar scope
read -p "Scope (opcional, ex: auth, api): " scope

# Perguntar descrição
read -p "Descrição (max 72 chars): " description

# Validar tamanho
if [[ ${#description} -gt 72 ]]; then
    echo -e "${RED}❌ Descrição muito longa (max 72 caracteres)${NC}"
    exit 1
fi

# Construir mensagem
if [[ -n "$scope" ]]; then
    commit_msg="${commit_type}(${scope}): ${description}"
else
    commit_msg="${commit_type}: ${description}"
fi

# Confirmar
echo -e "\n${YELLOW}📝 Mensagem de commit:${NC}"
echo "$commit_msg"
read -p "Confirmar? [Y/n]: " confirm

if [[ "$confirm" != "Y" && "$confirm" != "y" && "$confirm" != "" ]]; then
    echo -e "${RED}❌ Cancelado${NC}"
    exit 1
fi

# Executar commit e push
git add .
git commit -m "$commit_msg"
git push

echo -e "${GREEN}✅ Sincronização completa!${NC}"
