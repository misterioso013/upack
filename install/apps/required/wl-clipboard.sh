#!/usr/bin/env bash

set -e

echo "🔍 Checking for existing wl-clipboard installation..."

if ! command -v wl-copy &>/dev/null; then
  echo "📦 Installing wl-clipboard..."
  sudo apt-get update -y >/dev/null
  sudo apt-get install -y wl-clipboard
  
  echo "✅ wl-clipboard installed successfully."
else
  echo "✔️ wl-clipboard is already installed. Skipping installation."
fi
