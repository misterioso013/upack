#!/bin/bash

# UPack Core - Fonts Installation
# Installs SF Pro Display and other essential fonts

set -e

echo "🔤 Installing fonts..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install fonts using the existing utility
echo "📦 Installing SF Pro Display fonts..."
bash "$SCRIPT_DIR/../../utils/fonts.sh" &>/dev/null || echo "⚠️  Font installation may have issues"

# Refresh font cache
echo "🔄 Refreshing font cache..."
fc-cache -f -v &>/dev/null || echo "⚠️  Font cache refresh may have issues"

echo "✅ Fonts installation completed"
