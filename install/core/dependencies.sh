#!/bin/bash

# UPack Core - Dependencies Installation
# Installs essential system dependencies required for setup

set -e

echo "🔧 Installing essential dependencies..."

# Test sudo access (will prompt for password if needed)
echo "🔐 Checking administrative privileges..."
if ! sudo true; then
    echo "❌ This script requires sudo privileges to install system packages"
    echo "Please run the script as a user with sudo access"
    exit 1
fi

# Update package list
echo "📦 Updating package list..."
if ! sudo apt update -y; then
    echo "❌ Failed to update package list"
    exit 1
fi

# Install essential packages
echo "📦 Installing essential packages..."
if ! sudo apt install -y \
    curl \
    wget \
    git \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    unzip \
    zip; then
    echo "❌ Failed to install essential packages"
    exit 1
fi

# Install gum for better CLI experience
echo "📦 Installing gum for interactive CLI..."
GUM_VERSION="0.16.0"
if ! command -v gum &>/dev/null; then
    (
        cd /tmp
        wget -qO gum.deb "https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_amd64.deb"
        sudo apt-get install -y ./gum.deb
        rm -f gum.deb
    )
    echo "✅ gum installed successfully"
else
    echo "✅ gum already installed"
fi

echo "✅ Essential dependencies installed successfully"
