#!/usr/bin/env bash

set -e

GIT_EMAIL=$(git config --global user.email || true)

if [ -z "$GIT_EMAIL" ]; then
  GIT_EMAIL=$(gum input --placeholder "Enter your GitHub email" --prompt "📧 Email:")
  git config --global user.email "$GIT_EMAIL"
else
  echo "📧 Current Git email: $GIT_EMAIL"
  gum confirm "Do you want to use this email for SSH key?" || {
    GIT_EMAIL=$(gum input --placeholder "Enter a new email for SSH key" --prompt "📧 Email:")
  }
fi

KEY_PATH="$HOME/.ssh/id_rsa"

# Generate SSH key if not present
if [ ! -f "$KEY_PATH" ]; then
  echo "🔐 Generating SSH key..."
  ssh-keygen -t rsa -b 4096 -C "$GIT_EMAIL" -f "$KEY_PATH" -N ""
  echo "✅ SSH key generated at: $KEY_PATH"
else
  echo "🔁 SSH key already exists at: $KEY_PATH"
fi

# Display public key
echo ""
echo "🔑 Public SSH key:"
gum style --foreground 212 --border normal "$(cat "$KEY_PATH.pub")"

# Open GitHub to add the SSH key
gum confirm "📋 Have you copied the public key?" || {
  echo "❌ Please copy the SSH key before proceeding."
  exit 1
}

echo "🌐 Opening GitHub SSH key settings page..."
xdg-open "https://github.com/settings/ssh/new"

echo ""
echo "📍 Manual path: Settings > SSH and GPG keys > New SSH key"

# Optional test connection
gum confirm "✅ Do you want to test the SSH connection to GitHub?" && {
  echo "🔌 Testing connection..."
  ssh -T git@github.com || {
    echo "⚠️ Failed to connect via SSH. Make sure your key is added."
    exit 1
  }
  echo "🎉 SSH connection to GitHub was successful!"
}
echo "----------------------------------------"