#!/usr/bin/env bash

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../core/common-functions.sh"

echo "🔍 Checking for existing Xournal++ installation..."

if ! is_installed xournalpp && ! is_apt_installed xournalpp; then
    echo "📦 Installing Xournal++..."
    
    sudo apt-get update -y &>/dev/null
    sudo apt-get install -y xournalpp
    
    echo "✅ Xournal++ installed successfully."
else
    echo "✔️ Xournal++ is already installed. Skipping installation."
fi
