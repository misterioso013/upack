#!/usr/bin/env bash

set -e

ZOXIDE_BIN="$HOME/.local/bin/zoxide"
BASHRC="$HOME/.bashrc"
ZOXIDE_PATH='export PATH="$HOME/.local/bin:$PATH"'
ZOXIDE_INIT='eval "$(zoxide init bash)"'

# Instalar zoxide se não estiver presente
if ! command -v zoxide &>/dev/null; then
  echo "📦 Instaling zoxide..."
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
else
  echo "✅ zoxide already present"
fi

# Adicionar $HOME/.local/bin ao PATH se ainda não estiver
if ! grep -Fxq "$ZOXIDE_PATH" "$BASHRC"; then
  echo "➕ add .local/bin to PATH in .bashrc"
  echo "" >> "$BASHRC"
  echo "# zoxide PATH" >> "$BASHRC"
  echo "$ZOXIDE_PATH" >> "$BASHRC"
fi

# Adicionar inicialização do zoxide no .bashrc
if ! grep -Fxq "$ZOXIDE_INIT" "$BASHRC"; then
  echo "➕ Activating zoxide in .bashrc"
  echo "" >> "$BASHRC"
  echo "# zoxide init" >> "$BASHRC"
  echo "$ZOXIDE_INIT" >> "$BASHRC"
fi

echo "✅ zoxide already installed and configured."
