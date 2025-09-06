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

# Load common functions using absolute path
source "$INSTALL_DIR/core/common.sh"

# Run main menu from install directory
bash "$INSTALL_DIR/core/menu.sh"

# Configure GNOME settings
configure_gnome_settings "$INSTALL_DIR"

# Install theme (optional)
install_theme "$INSTALL_DIR"

# Install GNOME extensions (optional)
install_gnome_extensions "$INSTALL_DIR"

# Handle reboot prompt
handle_reboot_prompt