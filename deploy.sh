#!/bin/bash

# Script para enviar projeto ao GitHub

# Mensagem de commit (pode passar como argumento)
COMMIT_MSG=${1:-"Atualização do projeto"}

echo "🔄 Adicionando arquivos..."
git add .

echo "📝 Criando commit..."
git commit -m "$COMMIT_MSG"

echo "📤 Enviando para o GitHub..."
git push origin main

echo "✅ Projeto enviado com sucesso!"
