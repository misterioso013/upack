#!/usr/bin/env bash

set -e

echo "🔍 Checking existing VSCode installations..."

# Check if VSCode is already configured (settings.json exists)
CONFIG_DIR="$HOME/.config/Code/User"
if [ -f "$CONFIG_DIR/settings.json" ] && command -v code &>/dev/null; then
  echo "✔️ VSCode is already installed and configured. Skipping configuration to preserve extensions."
  echo "   If you need to reconfigure, delete ~/.config/Code/User/settings.json and run again."
  exit 0
fi

# Remove Flatpak version if it exists
if flatpak list | grep -q "com.visualstudio.code"; then
  echo "⚠️ Removing Flatpak version of VSCode..."
  flatpak uninstall -y com.visualstudio.code
fi

# Check if VSCode (.deb) is already installed
if ! command -v code &>/dev/null; then
  echo "📦 Installing Visual Studio Code (.deb)..."
  wget -qO vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
  sudo apt install -y ./vscode.deb
  rm vscode.deb
else
  echo "✔️ VSCode already installed (via .deb). Skipping install."
fi

echo "🧠 Configuring VSCode..."

mkdir -p "$CONFIG_DIR"
cp config/vscode/*.json "$CONFIG_DIR"

if [ -f config/vscode/default-extensions.txt ]; then
  echo "Installing VSCode extensions..."
  while read -r extension; do
    gum spin --spinner dot --title "Installing $extension..." -- bash -c \
      "code --install-extension \"$extension\" --force"
  done < config/vscode/default-extensions.txt

  echo "✅ Extensions installed."
fi

echo "✅ VSCode configured and ready. Use 'code .' to launch."
