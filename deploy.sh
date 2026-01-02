#!/bin/bash

gnome-terminal -- bash -c '
  COMMIT_MSG=$1
  if [ -z "$COMMIT_MSG" ]; then
    read -p "Digite a mensagem do commit: " COMMIT_MSG
  fi
  if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Atualização do projeto"
  fi

  if git diff-index --quiet HEAD --; then
    echo "Nenhuma alteração para commitar."
    read -p "Pressione Enter para fechar..."
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
  read -p "Pressione Enter para fechar..."
' "$@"

