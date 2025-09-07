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

echo "✅ Essential dependencies installed successfully"
