#!/usr/bin/env bash

set -e

FONT_DIR="$HOME/.local/share/fonts"
VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
ALACRITTY_FONT_DIR="$HOME/.config/alacritty"
ALACRITTY_FONT_FILE="$ALACRITTY_FONT_DIR/font.toml"
UPACK_DIR="${UPACK_DIR:-$HOME/.local/share/upack}"
export UPACK_DIR

# Install SF Pro Display fonts from UPack assets
install_sf_pro_fonts() {
  local fonts_source="$UPACK_DIR/assets/fonts"
  
  if [ -d "$fonts_source" ]; then
    echo "📦 Installing SF Pro Display fonts..."
    mkdir -p "$FONT_DIR"
    cp "$fonts_source"/*.otf "$FONT_DIR"/ 2>/dev/null || true
    cp "$fonts_source"/*.ttf "$FONT_DIR"/ 2>/dev/null || true
    fc-cache -fv "$FONT_DIR" >/dev/null 2>&1
    echo "✅ SF Pro Display fonts installed"
  else
    echo "⚠️ SF Pro Display fonts not found in: $fonts_source"
  fi
}

set_font() {
  local font_name="$1"
  local url="$2"
  local file_type="$3"
  local file_id="${font_name// /_}"

  if ! fc-list | grep -qi "$font_name"; then
    echo "📦 Downloading $font_name..."
    mkdir -p "$FONT_DIR"
    cd /tmp
    wget -q "$url" -O "$file_id.zip"
    unzip -qq -o "$file_id.zip" -d "$file_id"
    cp "$file_id"/*."$file_type" "$FONT_DIR"
    rm -rf "$file_id.zip" "$file_id"
    fc-cache -f
    cd -
    echo "✅ $font_name installed"
  else
    echo "✅ $font_name already present"
  fi
}

apply_font_settings() {
  local font_name="$1"
  local is_monospace="$2"
  
  echo "🎨 Applying font in system and tools..."

  # Apply to GNOME settings based on font type
  if command -v gsettings &>/dev/null && [[ "${XDG_CURRENT_DESKTOP:-}" == *"GNOME"* || -n "${GNOME_DESKTOP_SESSION_ID:-}" ]]; then
    if [[ "$is_monospace" == "true" ]]; then
      # Set monospace font for terminal and code
      if [[ "$(gsettings writable org.gnome.desktop.interface monospace-font-name 2>/dev/null)" == "true" ]]; then
        gsettings set org.gnome.desktop.interface monospace-font-name "$font_name 10" || true
        echo "✅ Monospace font set: $font_name"
      fi
    else
      # Set interface fonts
      if [[ "$(gsettings writable org.gnome.desktop.interface font-name 2>/dev/null)" == "true" ]]; then
        gsettings set org.gnome.desktop.interface font-name "$font_name 11" || true
      fi
      if [[ "$(gsettings writable org.gnome.desktop.interface document-font-name 2>/dev/null)" == "true" ]]; then
        gsettings set org.gnome.desktop.interface document-font-name "$font_name 11" || true
      fi
      echo "✅ Interface fonts set: $font_name"
    fi
  fi

  # Apply to VS Code (only for monospace fonts)
  if [[ "$is_monospace" == "true" ]] && [ -f "$VSCODE_SETTINGS" ]; then
    if grep -q "editor.fontFamily" "$VSCODE_SETTINGS"; then
      sed -i "s/\"editor.fontFamily\": \".*\"/\"editor.fontFamily\": \"$font_name\"/g" "$VSCODE_SETTINGS"
    else
      # Add font family to existing settings
      sed -i '1s/^{/{\'$'\n  "editor.fontFamily": "'"$font_name"'",/' "$VSCODE_SETTINGS"
    fi
    echo "✅ VS Code font updated: $font_name"
  fi

  # Apply to Alacritty (only for monospace fonts)
  if [[ "$is_monospace" == "true" ]]; then
    mkdir -p "$ALACRITTY_FONT_DIR"
    cat <<EOF > "$ALACRITTY_FONT_FILE"
[font]
normal = { family = "$font_name", style = "Regular" }
size = 10.0
EOF
    echo "✅ Alacritty font updated: $font_name"
  fi
}

# Install SF Pro Display fonts first
install_sf_pro_fonts

# Interactive font selection
if command -v gum &>/dev/null; then
  echo ""
  FONT_CHOICE=$(gum choose --header "Choose your monospace font for coding" --height 10 \
    "CaskaydiaMono Nerd Font" \
    "FiraMono Nerd Font" \
    "JetBrainsMono Nerd Font" \
    "MesloLGS Nerd Font" \
    "Skip monospace font selection")

  case $FONT_CHOICE in
    "CaskaydiaMono Nerd Font")
      set_font "$FONT_CHOICE" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaMono.zip" "ttf"
      apply_font_settings "$FONT_CHOICE" "true"
      ;;
    "FiraMono Nerd Font")
      set_font "$FONT_CHOICE" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraMono.zip" "otf"
      apply_font_settings "$FONT_CHOICE" "true"
      ;;
    "JetBrainsMono Nerd Font")
      set_font "$FONT_CHOICE" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip" "ttf"
      apply_font_settings "$FONT_CHOICE" "true"
      ;;
    "MesloLGS Nerd Font")
      set_font "$FONT_CHOICE" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.zip" "ttf"
      apply_font_settings "$FONT_CHOICE" "true"
      ;;
    "Skip monospace font selection")
      echo "⏭️ Skipping monospace font selection"
      ;;
  esac

  # Apply SF Pro Display as interface font
  if fc-list | grep -qi "SF Pro Display"; then
    apply_font_settings "SF Pro Display" "false"
  fi
else
  echo "⚠️ gum not available, using default CaskaydiaMono Nerd Font"
  set_font "CaskaydiaMono Nerd Font" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaMono.zip" "ttf"
  apply_font_settings "CaskaydiaMono Nerd Font" "true"
  
  # Apply SF Pro Display as interface font
  if fc-list | grep -qi "SF Pro Display"; then
    apply_font_settings "SF Pro Display" "false"
  fi
fi