#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/misterioso013/upack"
INSTALL_DIR="$HOME/.local/share/upack"

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo -e "\n\nUPack - Ubuntu Packager"
echo "----------------------------------------"
echo -e "\nBegin installation (or abort with Ctrl+C)..."
echo "🛠️ Installing dependencies"
sudo apt-get update -y >/dev/null
sudo apt-get install -y git curl >/dev/null

echo "📦 Cloning Upack (stable branch)..."
if [ ! -d ".git" ]; then
  git clone --depth=1 --branch stable "$REPO_URL" . 2>/dev/null || {
    echo "❌ Failed to clone."
    exit 1
  }
else
  git fetch origin stable
  git checkout stable
  git pull
fi

cat assets/banner.txt || true

echo "🚀 Starting Upack..."
bash core/menu.sh

# Set dark mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Set accent color to orange
gsettings set org.gnome.desktop.interface accent-color 'orange'

# Set wallpaper
WALLPAPER_PATH="$INSTALL_DIR/assets/ubuntu-neo-wallpaper.jpg"
if [ -f "$WALLPAPER_PATH" ]; then
    gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_PATH"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_PATH"
    gsettings set org.gnome.desktop.background picture-options 'zoom'
    echo "✅ Wallpaper applied: $WALLPAPER_PATH"
else
    echo "❌ Wallpaper not found: $WALLPAPER_PATH"
fi