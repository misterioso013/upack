#!/bin/bash
# UPack Boot Script - Ultra-Simple Ubuntu Setup
# Downloads and runs UPack automatically from any location

set -e  # Exit on any error

echo "🚀 UPack Bootstrap - Preparing Ubuntu..."

# Check if UPack is already installed
if command -v upack &> /dev/null; then
    echo "✅ UPack is already installed!"
    echo "Run 'upack status' to see your system status."
    exit 0
fi

# Install essential dependencies
echo "📦 Installing essential dependencies..."
sudo apt-get update -qq
sudo apt-get install -y curl wget git

# Create temporary directory for download
TEMP_DIR="/tmp/upack-bootstrap-$$"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "⬇️ Downloading UPack..."
git clone https://github.com/misterioso013/upack.git
cd upack

echo "🎯 Starting UPack setup..."
./setup.sh

# Cleanup
cd "$HOME"
rm -rf "$TEMP_DIR"

echo ""
echo "🎉 UPack installation completed!"
echo "You can now use 'upack' command from anywhere."