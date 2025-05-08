#!/usr/bin/env bash

set -e

echo "🔍 Checking existing VSCode installations..."

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

CONFIG_DIR="$HOME/.config/Code/User"
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
