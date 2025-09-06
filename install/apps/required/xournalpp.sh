#!/usr/bin/env bash

set -e

echo "🔍 Checking for existing Xournal++ installation..."

if ! command -v xournalpp &>/dev/null; then
  echo "📦 Installing Xournal++..."
  sudo apt-get update -y >/dev/null
  sudo apt-get install -y xournalpp
  
  echo "✅ Xournal++ installed successfully."
else
  echo "✔️ Xournal++ is already installed. Skipping installation."
fi
