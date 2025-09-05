#!/usr/bin/env bash

set -e

DISCORD_DEB_URL="https://discord.com/api/download?platform=linux&format=deb"

echo "🔍 Checking for existing Discord installation..."

if ! command -v discord &>/dev/null; then
  echo "📦 Installing Discord..."
  cd /tmp
  wget -qO discord.deb "$DISCORD_DEB_URL"
  sudo apt install -y ./discord.deb
  rm discord.deb
  echo "✅ Discord installed successfully."
else
  echo "✔️ Discord is already installed. Skipping installation."
fi
