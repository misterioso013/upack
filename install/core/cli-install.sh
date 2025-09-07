#!/bin/bash

# UPack Core - CLI Installation
# Installs and configures UPack CLI for post-setup management

set -e

echo "🎯 Installing UPack CLI..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPACK_ROOT="$(dirname $(dirname "$SCRIPT_DIR"))"

# Create symlink to make upack available globally
echo "🛣️  Configuring PATH..."

# Create local bin directory if it doesn't exist
mkdir -p "$HOME/.local/bin"

# Create symlink to upack CLI
if [ ! -L "$HOME/.local/bin/upack" ]; then
    ln -sf "$UPACK_ROOT/bin/upack" "$HOME/.local/bin/upack"
    echo "✅ UPack CLI symlink created"
else
    echo "ℹ️  UPack CLI symlink already exists"
fi

# Add ~/.local/bin to PATH if not already present
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    # Add to .bashrc
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
        echo '' >> "$HOME/.bashrc"
        echo '# UPack CLI PATH' >> "$HOME/.bashrc"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        echo "✅ Added ~/.local/bin to PATH in .bashrc"
    fi
    
    # Add to .zshrc if it exists
    if [ -f "$HOME/.zshrc" ] && ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc"; then
        echo '' >> "$HOME/.zshrc"
        echo '# UPack CLI PATH' >> "$HOME/.zshrc"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
        echo "✅ Added ~/.local/bin to PATH in .zshrc"
    fi
else
    echo "ℹ️  ~/.local/bin already in PATH"
fi

# Test CLI availability
if command -v upack >/dev/null 2>&1 || [ -x "$HOME/.local/bin/upack" ]; then
    echo "✅ UPack CLI installation completed"
    echo "ℹ️  Run 'source ~/.bashrc' or restart terminal to use CLI"
    echo "ℹ️  Available commands: upack --help"
else
    echo "⚠️  UPack CLI installation completed but may require terminal restart"
fi
