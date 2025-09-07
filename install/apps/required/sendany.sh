#!/usr/bin/env bash

set -e

echo "🔍 Checking for existing SendAny installation..."

# Check if SendAny desktop entry already exists
if [ -f ~/.local/share/applications/sendany.desktop ]; then
  echo "✔️ SendAny is already installed. Skipping installation."
  return 0 2>/dev/null || true
fi

# Check if Chrome is available (required for PWA)
if ! command -v google-chrome &>/dev/null; then
  echo "⚠️ Google Chrome is required for SendAny PWA but not found."
  echo "   SendAny installation will be skipped."
  return 0 2>/dev/null || true
fi

echo "📦 Checking SendAny PWA requirements..."

# Just verify Chrome is available for later installation
if ! command -v google-chrome &>/dev/null; then
    echo "⚠️  Google Chrome is required for SendAny PWA but not found."
    echo "   SendAny will be properly installed after Chrome is available."
    exit 0
fi

echo "✅ SendAny PWA requirements met."
echo "   Desktop application will be installed by the infrastructure setup."
