#!/usr/bin/env bash

set -e

INSTALL_DIR="$HOME/.local/share/upack"

# Ensure gum is available
if ! command -v gum &>/dev/null; then
  echo "📥 Gum not found. Installing..."
  bash utils/gum.sh
fi

# Confirm reinstall if folder exists
if [[ -d "$INSTALL_DIR" && -n "$(ls -A "$INSTALL_DIR")" ]]; then
  echo ""
  if ! gum confirm "⚠️ The directory $INSTALL_DIR already exists. Do you want to overwrite it?"; then
    echo "❌ Aborted by user."
    exit 1
  fi
  echo "🧹 Cleaning $INSTALL_DIR..." 
  rm -rf "$INSTALL_DIR"
fi

echo "📁 Copying local files to $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
rsync -a --exclude='.git' ./ "$INSTALL_DIR"
cat "$INSTALL_DIR/assets/banner.txt" || true
echo "🚀 Starting Upack (DEV)"
bash "$INSTALL_DIR/core/menu.sh"
