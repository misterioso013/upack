#!/bin/bash

# UPack Core - CLI Installation
# Installs UPack CLI and TUI tools

set -e

echo "🎯 Installing UPack CLI..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"

# Create local bin directory if it doesn't exist
mkdir -p "$BIN_DIR"

# Copy CLI tools
echo "📦 Installing CLI tools..."
cp "$SCRIPT_DIR/../../bin/upack" "$BIN_DIR/" 2>/dev/null || echo "⚠️  upack CLI copy failed"
cp "$SCRIPT_DIR/../../bin/upack-tui" "$BIN_DIR/" 2>/dev/null || echo "⚠️  upack-tui copy failed"

# Make them executable
chmod +x "$BIN_DIR/upack" 2>/dev/null || echo "⚠️  upack permissions failed"
chmod +x "$BIN_DIR/upack-tui" 2>/dev/null || echo "⚠️  upack-tui permissions failed"

# Add to PATH if not already there
echo "🛣️  Configuring PATH..."
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo "✅ Added $BIN_DIR to PATH in ~/.bashrc"
fi

# Install UPack app (desktop launcher)
echo "🚀 Installing UPack Manager app..."
bash "$SCRIPT_DIR/../apps/required/upack-app.sh" &>/dev/null || echo "⚠️  UPack app installation may have issues"

echo "✅ UPack CLI installation completed"
echo "ℹ️  Run 'source ~/.bashrc' or restart terminal to use CLI"
