#!/usr/bin/env bash

set -e

echo "🔍 Checking for existing VLC installation..."

if ! command -v vlc &>/dev/null; then
  echo "📦 Installing VLC Media Player..."
  sudo apt-get update -y >/dev/null
  sudo apt-get install -y vlc
  
  echo "✅ VLC Media Player installed successfully."
else
  echo "✔️ VLC Media Player is already installed. Skipping installation."
fi
