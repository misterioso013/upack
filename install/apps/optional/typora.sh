#!/usr/bin/env bash

set -e

echo "🔍 Checking for existing Typora installation..."

if ! command -v typora &>/dev/null; then
  echo "📦 Installing Typora..."
  
  # Detect architecture
  ARCH=$(dpkg --print-architecture)
  case $ARCH in
    amd64)
      TYPORA_URL="https://downloads.typora.io/linux/typora_1.10.8_amd64.deb"
      ;;
    arm64)
      TYPORA_URL="https://downloads.typora.io/linux/typora_1.10.8_arm64.deb"
      ;;
    *)
      echo "❌ Unsupported architecture: $ARCH"
      echo "   Typora only supports amd64 and arm64 architectures"
      exit 1
      ;;
  esac
  
  # Create secure temporary directory
  TEMP_DIR=$(mktemp -d)
  trap 'rm -rf "$TEMP_DIR"' EXIT
  
  # Download and install in subshell to avoid changing working directory
  (
    cd "$TEMP_DIR"
    wget -q -O typora.deb "$TYPORA_URL"
    DEBIAN_FRONTEND=noninteractive sudo apt-get install -yq --no-install-recommends ./typora.deb
  )
  
  echo "✅ Typora installed successfully."
else
  echo "✔️ Typora is already installed. Skipping installation."
fi

echo "🎨 Configuring Typora themes..."
# Create themes directory
mkdir -p ~/.config/Typora/themes

# Get the script directory to find config files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPACK_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Ensure themes directory exists
mkdir -p ~/.config/Typora/themes/

# Copy theme files
if [ -f "$UPACK_DIR/config/typora/typora.css" ]; then
  cp "$UPACK_DIR/config/typora/typora.css" ~/.config/Typora/themes/
  echo "✅ Typora light theme configured"
else
  echo "⚠️ Typora light theme file not found"
fi

if [ -f "$UPACK_DIR/config/typora/typora_night.css" ]; then
  cp "$UPACK_DIR/config/typora/typora_night.css" ~/.config/Typora/themes/
  echo "✅ Typora dark theme configured"
else
  echo "⚠️ Typora dark theme file not found"
fi

# Copy night directory with all assets (CSS partials and cursor images)
if [ -d "$UPACK_DIR/config/typora/night" ]; then
  cp -r "$UPACK_DIR/config/typora/night" ~/.config/Typora/themes/
  echo "✅ Typora night theme assets configured"
else
  echo "⚠️ Typora night theme assets directory not found"
fi

echo "✅ Typora configuration completed."
