#!/bin/bash

# UPack Core - Essential Apps Installation
# Installs all essential applications automatically

set -e

echo "📱 Installing essential applications..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common functions
source "$SCRIPT_DIR/common-functions.sh"

# Set UPACK_DIR for compatibility with existing scripts
export UPACK_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# List of essential apps to install
ESSENTIAL_APPS=(
    "chrome"
    "vscode"
    "vlc"
    "gnome-tweaks"
    "gnome-extension-manager"
    "obsidian"
    "xournalpp"
    "wl-clipboard"
    "zoxide"
    "sendany"
)

# Install each essential app
for app in "${ESSENTIAL_APPS[@]}"; do
    if [ -f "$SCRIPT_DIR/../apps/required/${app}.sh" ]; then
        echo "📦 Installing $app..."
        bash "$SCRIPT_DIR/../apps/required/${app}.sh"
    else
        echo "⚠️  Script for $app not found, skipping..."
    fi
done

echo "✅ Essential applications installed successfully"
