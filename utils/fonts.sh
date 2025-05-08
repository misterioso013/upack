#!/usr/bin/env bash

set -e

FONT_DIR="$HOME/.local/share/fonts"
VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
ALACRITTY_FONT_DIR="$HOME/.config/alacritty"
ALACRITTY_FONT_FILE="$ALACRITTY_FONT_DIR/font.toml"

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

  echo "🎨 Applying font in system and tools..."

  # Set monospace font in GNOME
  gsettings set org.gnome.desktop.interface monospace-font-name "$font_name 10" 2>/dev/null || true

  # Patch VSCode settings
  if [ -f "$VSCODE_SETTINGS" ]; then
    sed -i "s/\"editor.fontFamily\": \".*\"/\"editor.fontFamily\": \"$font_name\"/g" "$VSCODE_SETTINGS" || \
    echo "\"editor.fontFamily\": \"$font_name\"" >> "$VSCODE_SETTINGS"
  fi

  # Alacritty
  mkdir -p "$ALACRITTY_FONT_DIR"
  cat <<EOF > "$ALACRITTY_FONT_FILE"
[font]
normal = { family = "$font_name", style = "Regular" }
size = 10.0
EOF
}

# Interactive font selection
FONT_CHOICE=$(gum choose --header "Choose your font" --height 10 \
  "CaskaydiaMono Nerd Font" \
  "FiraMono Nerd Font" \
  "JetBrainsMono Nerd Font" \
  "MesloLGS Nerd Font")

case $FONT_CHOICE in
  "CaskaydiaMono Nerd Font")
    set_font "$FONT_CHOICE" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaMono.zip" "ttf"
    ;;
  "FiraMono Nerd Font")
    set_font "$FONT_CHOICE" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraMono.zip" "otf"
    ;;
  "JetBrainsMono Nerd Font")
    set_font "$FONT_CHOICE" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip" "ttf"
    ;;
  "MesloLGS Nerd Font")
    set_font "$FONT_CHOICE" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.zip" "ttf"
    ;;
esac