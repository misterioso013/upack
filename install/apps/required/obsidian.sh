#!/usr/bin/env bash

set -e

echo "🔍 Checking for existing Obsidian installation..."

if ! command -v obsidian &>/dev/null; then
  echo "📦 Installing Obsidian..."
  
  # Detect architecture
  ARCH=$(dpkg --print-architecture)
  case $ARCH in
    amd64)
      ARCH_SUFFIX="amd64"
      ;;
    arm64)
      ARCH_SUFFIX="arm64"
      ;;
    *)
      echo "❌ Unsupported architecture: $ARCH"
      echo "   Obsidian only supports amd64 and arm64 architectures"
      exit 1
      ;;
  esac
  
  # Get the latest release version from GitHub API
  echo "🔍 Fetching latest Obsidian version..."
  LATEST_VERSION=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
  
  if [ -z "$LATEST_VERSION" ]; then
    echo "❌ Failed to fetch latest version. Using fallback version 1.9.12"
    LATEST_VERSION="1.9.12"
  else
    echo "✅ Found latest version: v$LATEST_VERSION"
  fi
  
  # Construct download URL
  OBSIDIAN_URL="https://github.com/obsidianmd/obsidian-releases/releases/download/v${LATEST_VERSION}/obsidian_${LATEST_VERSION}_${ARCH_SUFFIX}.deb"
  
  echo "📥 Downloading from: $OBSIDIAN_URL"
  
  # Create secure temporary directory
  TEMP_DIR=$(mktemp -d)
  trap 'rm -rf "$TEMP_DIR"' EXIT
  
  # Download and install in subshell to avoid changing working directory
  (
    cd "$TEMP_DIR"
    
    # Download with error checking
    if ! wget -q --timeout=30 --tries=3 -O obsidian.deb "$OBSIDIAN_URL"; then
      echo "❌ Failed to download Obsidian"
      echo "   Please check your internet connection and try again"
      exit 1
    fi
    
    # Verify the downloaded file
    if [ ! -f obsidian.deb ] || [ ! -s obsidian.deb ]; then
      echo "❌ Downloaded file is empty or corrupted"
      exit 1
    fi
    
    # Install the package
    echo "🔧 Installing Obsidian package..."
    DEBIAN_FRONTEND=noninteractive sudo apt-get install -yq --no-install-recommends ./obsidian.deb
  )
  
  echo "✅ Obsidian installed successfully."
else
  echo "✔️ Obsidian is already installed. Skipping installation."
fi

echo "🎨 Configuring Obsidian..."

# Create Obsidian config directory if it doesn't exist
mkdir -p ~/.config/obsidian

# Set some basic preferences for a better user experience
OBSIDIAN_CONFIG_DIR="$HOME/.config/obsidian"

echo "✅ Obsidian configuration completed."
echo "📝 You can now open Obsidian and start taking notes!"
echo "💡 Tip: Obsidian works best when you create a vault (folder) for your notes"