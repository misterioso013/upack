#!/bin/bash

# UPack Core - Terminal Setup
# Configures terminal with colors, prompt and basic settings

set -e

echo "💻 Configuring terminal..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Apply terminal configurations
echo "🎨 Setting up terminal colors and prompt..."
bash "$SCRIPT_DIR/../../config/terminal/bash-config.sh" &>/dev/null || echo "⚠️  Terminal config may have issues"

# Copy terminal configuration files
echo "📁 Installing terminal configuration files..."
if [ -d "$SCRIPT_DIR/../../config/alacritty" ]; then
    mkdir -p "$HOME/.config/alacritty"
    cp -r "$SCRIPT_DIR/../../config/alacritty/"* "$HOME/.config/alacritty/" 2>/dev/null || echo "ℹ️  Alacritty config skipped"
fi

echo "✅ Terminal configuration completed"
