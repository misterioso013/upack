#!/bin/bash

# UPack Core - GNOME Configuration
# Configures GNOME extensions and system settings automatically

set -e

echo "⚡ Configuring GNOME environment..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install GNOME extensions first
echo "🧩 Installing GNOME extensions..."
if ! timeout 120 bash "$SCRIPT_DIR/../gnome-extensions.sh" &>/dev/null; then
    echo "⚠️  Extension installation timed out or failed"
fi

# Wait for GNOME Shell to reload
echo "⏳ Waiting for GNOME Shell to reload..."
sleep 5

# Apply GNOME configurations with timeout and non-interactive mode
echo "⚙️  Applying GNOME settings..."
export UPACK_SKIP_HOTKEYS=1
if ! timeout 60 bash "$SCRIPT_DIR/../../config/gnome/apply-config.sh" "$SCRIPT_DIR/../.." &>/dev/null; then
    echo "⚠️  GNOME settings application timed out"
fi

# Configure hotkeys separately
echo "⌨️  Setting up keyboard shortcuts..."
if ! timeout 30 bash "$SCRIPT_DIR/../../config/gnome/hotkeys.sh" &>/dev/null; then
    echo "⚠️  Hotkeys setup timed out"
fi

# Configure dock
echo "🚢 Configuring dock..."
if ! timeout 30 bash "$SCRIPT_DIR/../../config/gnome/dock-config.sh" &>/dev/null; then
    echo "ℹ️  Dock configuration timed out"
fi

echo "✅ GNOME configuration completed"
