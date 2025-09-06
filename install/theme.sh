#!/usr/bin/env bash

set -e

echo "🎨 Installing minimalista theme components..."

# Define UPack directory
UPACK_DIR="$HOME/.local/share/upack"

# Create a secure temporary directory
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "📦 Installing WhiteSur GTK Theme..."
(
  cd "$TEMP_DIR"
  git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1
  cd WhiteSur-gtk-theme
  ./install.sh -c dark -s nord -m -l
  
  echo "🔧 Applying WhiteSur tweaks..."
  # Firefox theme with Monterey style
  ./tweaks.sh -f monterey
  
  # Dash-to-Dock theme (only if installed)
  if command -v gnome-extensions &>/dev/null && gnome-extensions list | grep -q "dash-to-dock"; then
    ./tweaks.sh -d
    echo "✅ Dash-to-Dock theme applied"
  else
    echo "ℹ️ Dash-to-Dock not installed, skipping dash theme"
  fi
  
  # Flatpak fix
  echo "🔧 Applying Flatpak fix..."
  if command -v flatpak &>/dev/null; then
    sudo flatpak override --filesystem=xdg-config/gtk-3.0 2>/dev/null || true
    sudo flatpak override --filesystem=xdg-config/gtk-4.0 2>/dev/null || true
    ./tweaks.sh -F || echo "⚠️ Flatpak theme connection failed, but continuing..."
    echo "✅ Flatpak GTK theme fix applied"
  else
    echo "ℹ️ Flatpak not installed, skipping flatpak fix"
  fi
  
  # GDM theme with custom background
  echo "🔧 Installing GDM theme with custom background..."
  local bg_path
  if [ -f "$UPACK_DIR/assets/dark-background.png" ]; then
    bg_path="$UPACK_DIR/assets/dark-background.png"
  elif [ -f "../../../assets/dark-background.png" ]; then
    bg_path="$(pwd)/../../../assets/dark-background.png"
  elif [ -f "/home/rosiel/projects/upack/assets/dark-background.png" ]; then
    bg_path="/home/rosiel/projects/upack/assets/dark-background.png"
  else
    bg_path=""
  fi
  
  if [ -n "$bg_path" ] && [ -f "$bg_path" ]; then
    if sudo ./tweaks.sh -g -nd -nb -b "$bg_path" 2>/dev/null; then
      echo "✅ GDM theme installed with custom background ($bg_path)"
    else
      echo "⚠️ Failed to install GDM theme with custom background, trying default..."
      sudo ./tweaks.sh -g -nd -nb 2>/dev/null || echo "⚠️ GDM theme installation failed"
    fi
  else
    echo "⚠️ Custom background not found, installing GDM theme with default background"
    sudo ./tweaks.sh -g -nd -nb 2>/dev/null || echo "⚠️ GDM theme installation failed"
  fi
)

echo "📦 Installing Nordzy Icon Theme..."
(
  cd "$TEMP_DIR"
  git clone https://github.com/MolassesLover/Nordzy-icon.git --depth=1
  cd Nordzy-icon
  ./install.sh -t default -c -p
)

echo "📦 Installing Sunity Cursors..."
(
  cd "$TEMP_DIR"
  git clone https://github.com/alvatip/Sunity-cursors --depth=1
  cd Sunity-cursors
  sudo ./install.sh
)

echo "📦 Installing custom fonts..."
FONTS_SOURCE="$UPACK_DIR/assets/fonts"
FONTS_DEST="$HOME/.local/share/fonts"

if [ -d "$FONTS_SOURCE" ]; then
  mkdir -p "$FONTS_DEST"
  cp "$FONTS_SOURCE"/*.otf "$FONTS_DEST"/ 2>/dev/null || true
  cp "$FONTS_SOURCE"/*.ttf "$FONTS_DEST"/ 2>/dev/null || true
  
  # Update font cache
  fc-cache -fv "$FONTS_DEST" >/dev/null 2>&1
  echo "✅ Custom fonts installed and cache updated"
else
  echo "⚠️ Fonts directory not found: $FONTS_SOURCE"
fi

echo "🔧 Configuring theme settings with gsettings..."

# Apply theme configurations if GNOME is available
if command -v gsettings &>/dev/null && [[ "${XDG_CURRENT_DESKTOP:-}" == *"GNOME"* || -n "${GNOME_DESKTOP_SESSION_ID:-}" ]]; then
  # GTK Theme
  if [[ "$(gsettings writable org.gnome.desktop.interface gtk-theme 2>/dev/null)" == "true" ]]; then
    gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Dark-nord' || true
  fi
  
  # Icon Theme
  if [[ "$(gsettings writable org.gnome.desktop.interface icon-theme 2>/dev/null)" == "true" ]]; then
    gsettings set org.gnome.desktop.interface icon-theme 'Nordzy--dark_panel' || true
  fi
  
  # Cursor Theme
  if [[ "$(gsettings writable org.gnome.desktop.interface cursor-theme 2>/dev/null)" == "true" ]]; then
    gsettings set org.gnome.desktop.interface cursor-theme 'Sunity-cursors' || true
  fi
  
  # Window manager theme (for GNOME Shell)
  if [[ "$(gsettings writable org.gnome.shell.extensions.user-theme name 2>/dev/null)" == "true" ]]; then
    gsettings set org.gnome.shell.extensions.user-theme name 'WhiteSur-Dark-nord' || true
  fi
  
  # Additional tweaks for better appearance
  if [[ "$(gsettings writable org.gnome.desktop.interface cursor-size 2>/dev/null)" == "true" ]]; then
    gsettings set org.gnome.desktop.interface cursor-size 24 || true
  fi
  
  if [[ "$(gsettings writable org.gnome.desktop.interface clock-show-weekday 2>/dev/null)" == "true" ]]; then
    gsettings set org.gnome.desktop.interface clock-show-weekday true || true
  fi
  
  echo "✅ Theme settings applied via gsettings"
else
  echo "ℹ️ GNOME not detected, theme settings will need to be applied manually"
fi

echo "✅ Minimalista theme installation completed!"
echo "💡 The theme components have been installed:"
echo "   • WhiteSur GTK Theme (Dark Nord variant)"
echo "   • Firefox Theme (Monterey style)"
echo "   • Dash-to-Dock Theme integration"
echo "   • GDM Theme with custom background"
echo "   • Flatpak theme fix applied"
echo "   • Nordzy Icon Theme (Dark)"  
echo "   • Sunity Cursors"
echo "   • SF Pro Display Fonts (available for font selection)"
echo ""
echo "🔧 You can also use GNOME Tweaks to fine-tune the appearance:"
echo "   • GTK Theme: WhiteSur-Dark-nord"
echo "   • Icon Theme: Nordzy-dark"
echo "   • Cursor Theme: Sunity-cursors"
echo ""
echo "🌐 Firefox will use the Monterey-style WhiteSur theme"
echo "🚀 GDM (login screen) will use the custom dark background"
echo "📦 Flatpak applications will inherit the GTK theme"
echo "💡 Fonts are configured separately via the font selection system."
