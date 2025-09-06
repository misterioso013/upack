#!/usr/bin/env bash

set -e

# Ensure gum is available
if ! command -v gum &>/dev/null; then
  bash utils/gum.sh
fi

if ! command -v flatpak &>/dev/null; then
  bash utils/flatpak.sh
fi
if ! command -v mise &>/dev/null; then
  bash utils/mise.sh
fi

echo "Configuring Git..."
bash utils/git.sh

echo "🚧 Installing required tools..."
bash "$UPACK_DIR/core/required.sh"

echo ""
if gum confirm "✨ Do you want to install optional apps (games, emulators, VPNs, etc.)?"; then
  bash "$UPACK_DIR/core/optional.sh"
fi

echo ""
if gum confirm "🎨 Do you want to configure elegant terminal settings?"; then
  bash "$UPACK_DIR/config/terminal/terminal-menu.sh"
fi

echo ""
if gum confirm "⌨️  Do you want to configure GNOME productivity hotkeys?"; then
  bash "$UPACK_DIR/config/gnome/hotkeys-menu.sh"
fi

echo "✅ All done!"
