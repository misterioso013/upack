#!/bin/bash

# UPack Core - Theme Setup
# Installs and configures WhiteSur theme automatically

set -e

echo "🎨 Installing WhiteSur theme..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create a secure temporary directory
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "📦 Downloading WhiteSur GTK Theme..."
cd "$TEMP_DIR"
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1 -q

cd WhiteSur-gtk-theme
echo "🔧 Installing theme..."
./install.sh -c dark -s nord -m -l &>/dev/null

echo "⚡ Applying theme tweaks..."
# Firefox theme
./tweaks.sh -f monterey &>/dev/null || echo "ℹ️  Firefox theme skipped"

# Flatpak fix
if command -v flatpak &>/dev/null; then
    sudo flatpak override --filesystem=xdg-config/gtk-3.0 2>/dev/null || true
    sudo flatpak override --filesystem=xdg-config/gtk-4.0 2>/dev/null || true
    ./tweaks.sh -F &>/dev/null || echo "ℹ️  Flatpak theme fix skipped"
    echo "✅ Flatpak theme fixes applied"
fi

# GDM theme with custom background
bg_path="$SCRIPT_DIR/../../assets/dark-background.png"
if [ -f "$bg_path" ]; then
    echo "🖼️  Applying custom GDM background..."
    sudo ./tweaks.sh -g -b "$bg_path" &>/dev/null || echo "ℹ️  GDM theme skipped"
fi

echo "✅ WhiteSur theme installed successfully"
