#!/usr/bin/env bash

set -e

# Load common functions
source "$(dirname "$0")/core/common.sh"

INSTALL_DIR="$HOME/.local/share/upack"

# Ensure gum is available
ensure_gum

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

# Configure GNOME settings
configure_gnome_settings "$INSTALL_DIR"

# Install theme (optional)
install_theme "$INSTALL_DIR"

# Handle reboot prompt
handle_reboot_prompt
