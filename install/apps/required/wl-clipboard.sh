#!/usr/bin/env bash

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../core/common-functions.sh"

echo "🔍 Checking for existing wl-clipboard installation..."

if ! is_installed wl-copy && ! is_apt_installed wl-clipboard; then
    echo "📦 Installing wl-clipboard..."
    
    sudo apt-get update -y &>/dev/null
    sudo apt-get install -y wl-clipboard
    
    echo "✅ wl-clipboard installed successfully."
else
    echo "✔️ wl-clipboard is already installed. Skipping installation."
fi
