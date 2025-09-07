#!/bin/bash

# UPack Core - Dependencies Installation
# Installs essential system dependencies required for setup

set -e

echo "🔧 Installing essential dependencies..."

# Check if running in a restricted environment
RESTRICTED_ENV=false
if [ -n "$container" ] || [ -f /.dockerenv ] || [ -n "$CODESPACES" ] || [ -n "$GITHUB_CODESPACE_TOKEN" ]; then
    echo "⚠️  Restricted environment detected (container/codespace)"
    RESTRICTED_ENV=true
fi

# Test sudo access
echo "🔐 Checking administrative privileges..."

# Try a simple sudo command first
if sudo echo "Testing sudo access..." 2>/dev/null; then
    echo "✅ Sudo access confirmed"
else
    # Check if it's a "no new privileges" error specifically
    SUDO_ERROR=$(sudo echo "test" 2>&1 || true)
    if [[ "$SUDO_ERROR" == *"no new privileges"* ]]; then
        echo "ℹ️  Running in restricted environment - checking existing packages..."
        RESTRICTED_ENV=true
    else
        echo "❌ This script requires sudo privileges to install system packages"
        echo "Please run the script as a user with sudo access"
        exit 1
    fi
fi

if [ "$RESTRICTED_ENV" = true ]; then
    # Check if essential commands exist
    MISSING_DEPS=()
    
    if ! command -v curl &> /dev/null; then
        MISSING_DEPS+=("curl")
    fi
    
    if ! command -v wget &> /dev/null; then
        MISSING_DEPS+=("wget")
    fi
    
    if ! command -v git &> /dev/null; then
        MISSING_DEPS+=("git")
    fi
    
    if ! command -v unzip &> /dev/null; then
        MISSING_DEPS+=("unzip")
    fi
    
    if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
        echo "✅ All essential dependencies are already available"
        exit 0
    else
        echo "⚠️  Missing dependencies: ${MISSING_DEPS[*]}"
        echo "ℹ️  Please install them manually in your environment"
        echo "✅ Continuing with available tools..."
        exit 0
    fi
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
