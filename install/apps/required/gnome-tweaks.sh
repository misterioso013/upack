#!/usr/bin/env bash

set -e

echo "🔍 Checking for existing GNOME Tweaks installation..."

if ! command -v gnome-tweaks &>/dev/null; then
  echo "📦 Installing GNOME Tweaks..."
  sudo apt-get update -y >/dev/null
  sudo apt-get install -y gnome-tweaks
  
  echo "✅ GNOME Tweaks installed successfully."
else
  echo "✔️ GNOME Tweaks is already installed. Skipping installation."
fi
