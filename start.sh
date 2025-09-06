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

# Configure GNOME settings if available
if command -v gsettings &>/dev/null && [[ "${XDG_CURRENT_DESKTOP:-}" == *"GNOME"* || -n "${GNOME_DESKTOP_SESSION_ID:-}" ]]; then
  echo "🎨 Configuring GNOME settings..."
  
  # Set dark mode
  if gsettings writable org.gnome.desktop.interface color-scheme &>/dev/null; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || true
  fi
  
  # Set accent color to orange
  if gsettings writable org.gnome.desktop.interface accent-color &>/dev/null; then
    gsettings set org.gnome.desktop.interface accent-color 'orange' || true
  fi
  
  # Set wallpaper
  WALLPAPER_PATH="$INSTALL_DIR/assets/ubuntu-neo-wallpaper.jpg"
  if [ -f "$WALLPAPER_PATH" ]; then
    if gsettings writable org.gnome.desktop.background picture-uri &>/dev/null; then
      gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_PATH" || true
    fi
    if gsettings writable org.gnome.desktop.background picture-uri-dark &>/dev/null; then
      gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_PATH" || true
    fi
    if gsettings writable org.gnome.desktop.background picture-options &>/dev/null; then
      gsettings set org.gnome.desktop.background picture-options 'zoom' || true
    fi
    echo "✅ Wallpaper applied: $WALLPAPER_PATH"
  else
    echo "❌ Wallpaper not found: $WALLPAPER_PATH"
  fi
else
  echo "ℹ️ GNOME not detected or gsettings not available, skipping desktop customization"
fi