#!/bin/bash

# UPack Core - GNOME Configuration
# Configures GNOME extensions and system settings automatically

set -e

echo "⚡ Configuring GNOME environment..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install GNOME extensions first
echo "🧩 Installing GNOME extensions..."
bash "$SCRIPT_DIR/../gnome-extensions.sh" &>/dev/null || echo "⚠️  Some extensions may have failed"

# Apply GNOME configurations
echo "⚙️  Applying GNOME settings..."
bash "$SCRIPT_DIR/../../config/gnome/apply-config.sh" &>/dev/null || echo "⚠️  Some settings may have failed"

# Configure hotkeys
echo "⌨️  Setting up keyboard shortcuts..."
bash "$SCRIPT_DIR/../../config/gnome/hotkeys.sh" &>/dev/null || echo "⚠️  Some shortcuts may have failed"

# Configure dock
echo "🚢 Configuring dock..."
bash "$SCRIPT_DIR/../../config/gnome/dock-config.sh" &>/dev/null || echo "ℹ️  Dock config skipped"

echo "✅ GNOME configuration completed"
