#!/bin/bash

# Script para enviar projeto ao GitHub

# Mensagem de commit (pode passar como argumento)
COMMIT_MSG=$1

# Se não passar argumento, pede a mensagem
if [ -z "$COMMIT_MSG" ]; then
  read -p "Digite a mensagem do commit: " COMMIT_MSG
fi

# Se ainda estiver vazio, usa uma mensagem padrão
if [ -z "$COMMIT_MSG" ]; then
  COMMIT_MSG="Atualização do projeto"
fi

# Verifica se há alterações
if git diff-index --quiet HEAD --; then
  echo "Nenhuma alteração para commitar."
  exit 0
fi

echo "Adicionando todos os arquivos..."
git add -A

echo "Criando commit..."
git commit -m "$COMMIT_MSG"

BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Enviando para o GitHub (branch $BRANCH)..."
git push origin "$BRANCH"

echo "Projeto enviado com sucesso!"
git status

