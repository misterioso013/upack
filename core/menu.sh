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
bash core/required.sh

echo ""
if gum confirm "✨ Do you want to install optional apps (games, emulators, VPNs, etc.)?"; then
  bash core/optional.sh
fi

echo "✅ All done!"
