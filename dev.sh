#!/usr/bin/env bash

set -e

INSTALL_DIR="$HOME/.local/share/upack"

# Ensure gum is available
if ! command -v gum &>/dev/null; then
  echo "📥 Gum not found. Installing..."
  bash utils/gum.sh
fi

# Confirm reinstall if folder exists
if [[ -d "$INSTALL_DIR" && -n "$(ls -A "$INSTALL_DIR")" ]]; then
  echo ""
  if ! gum confirm "⚠️ The directory $INSTALL_DIR already exists. Do you want to overwrite it?"; then
    echo "❌ Aborted by user."
    exit 1
  fi
  echo "🧹 Cleaning $INSTALL_DIR..." 
  rm -rf "$INSTALL_DIR"
fi

echo "📁 Copying local files to $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
rsync -a --exclude='.git' ./ "$INSTALL_DIR"
cat "$INSTALL_DIR/assets/banner.txt" || true
echo "🚀 Starting Upack (DEV)"
bash "$INSTALL_DIR/core/menu.sh"

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
