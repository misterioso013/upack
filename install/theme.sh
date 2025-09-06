#!/usr/bin/env bash

set -e

echo "🎨 Installing minimalista theme components..."

# Create a secure temporary directory
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "📦 Installing WhiteSur GTK Theme..."
(
  cd "$TEMP_DIR"
  git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1
  cd WhiteSur-gtk-theme
  ./install.sh -c dark -s nord -m -l
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
# Use the standard UPack installation directory
UPACK_DIR="$HOME/.local/share/upack"
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
echo "   • Nordzy Icon Theme (Dark)"  
echo "   • Sunity Cursors"
echo "   • SF Pro Display Fonts (available for font selection)"
echo ""
echo "🔧 You can also use GNOME Tweaks to fine-tune the appearance:"
echo "   • GTK Theme: WhiteSur-Dark-nord"
echo "   • Icon Theme: Nordzy-dark"
echo "   • Cursor Theme: Sunity-cursors"
echo ""
echo "💡 Fonts are configured separately via the font selection system."
