#!/usr/bin/env bash

set -e

# Checa se nome está definido
GIT_NAME=$(git config --global user.name || true)
GIT_EMAIL=$(git config --global user.email || true)

if [ -z "$GIT_NAME" ]; then
  GIT_NAME=$(gum input --placeholder "Enter your Git name")
  git config --global user.name "$GIT_NAME"
fi

if [ -z "$GIT_EMAIL" ]; then
  GIT_EMAIL=$(gum input --placeholder "Enter your Git email")
  git config --global user.email "$GIT_EMAIL"
fi

# Configurações padrão
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.rebase true

echo "✅ Git configured for $GIT_NAME <$GIT_EMAIL>"
echo "----------------------------------------"