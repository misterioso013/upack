#!/usr/bin/env bash

set -e

echo "🔍 Checking for existing Google Chrome installation..."

if ! command -v google-chrome &>/dev/null; then
  echo "📦 Installing Google Chrome..."
  cd /tmp
  wget -q "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  sudo apt install -y ./google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb
  cd -

  echo "🧭 Setting Google Chrome as the default browser..."
  xdg-settings set default-web-browser google-chrome.desktop || echo "⚠️ Could not set default browser (xdg-settings failed)"
  
  echo "✅ Google Chrome installed successfully."
else
  echo "✔️ Google Chrome is already installed. Skipping installation."
fi
