#!/bin/bash

# UPack Core - Fonts Installation
# Installs SF Pro Display and other essential fonts

set -e

echo "🔤 Installing fonts..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FONT_DIR="$HOME/.local/share/fonts"
UPACK_DIR="$(dirname $(dirname "$SCRIPT_DIR"))"

# Install SF Pro Display fonts directly (non-interactive)
echo "📦 Installing SF Pro Display fonts..."
fonts_source="$UPACK_DIR/assets/fonts"

if [ -d "$fonts_source" ]; then
    mkdir -p "$FONT_DIR"
    cp "$fonts_source"/*.otf "$FONT_DIR"/ 2>/dev/null || true
    cp "$fonts_source"/*.ttf "$FONT_DIR"/ 2>/dev/null || true
    echo "✅ SF Pro Display fonts copied"
else
    echo "⚠️ SF Pro Display fonts not found in: $fonts_source"
fi

# Refresh font cache
echo "🔄 Refreshing font cache..."
if command -v fc-cache &>/dev/null; then
    fc-cache -fv "$FONT_DIR" &>/dev/null && echo "✅ Font cache refreshed" || echo "⚠️ Font cache refresh issues"
else
    echo "⚠️ fc-cache not available"
fi

echo "✅ Fonts installation completed"
