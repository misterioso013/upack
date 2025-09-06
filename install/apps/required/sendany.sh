#!/usr/bin/env bash

set -e

echo "🔍 Checking for existing SendAny installation..."

# Check if SendAny desktop entry already exists
if [ -f ~/.local/share/applications/SendAny.desktop ]; then
  echo "✔️ SendAny is already installed. Skipping installation."
  return 0 2>/dev/null || true
fi

# Check if Chrome is available (required for PWA)
if ! command -v google-chrome &>/dev/null; then
  echo "⚠️ Google Chrome is required for SendAny PWA but not found."
  echo "   SendAny installation will be skipped."
  return 0 2>/dev/null || true
fi

echo "📦 Installing SendAny PWA..."

# Create applications directory if it doesn't exist
mkdir -p ~/.local/share/applications

# Get the script directory to find the icon
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPACK_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
ICON_PATH="$HOME/.local/share/upack/assets/icons/sendany.png"

# Create the desktop entry
cat <<EOF >~/.local/share/applications/SendAny.desktop
[Desktop Entry]
Version=1.0
Name=SendAny
Comment=Share anything with anyone
Exec=google-chrome --app="https://sendany.all.dev.br" --name=SendAny --class=SendAny
Terminal=false
Type=Application
Icon=$ICON_PATH
Categories=Network;Utility;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupNotify=true
NoDisplay=false
EOF

# Make the desktop entry executable
chmod +x ~/.local/share/applications/SendAny.desktop

# Update desktop database to make the app appear in menus
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
fi

echo "✅ SendAny PWA installed successfully."
echo "   You can now find SendAny in your applications menu."
