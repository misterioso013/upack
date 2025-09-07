#!/bin/bash

# UPack Core - Dependencies Installation
# Installs essential system dependencies required for setup

set -e

echo "🔧 Installing essential dependencies..."

# Update package list
sudo apt update -y

# Install essential packages
sudo apt install -y \
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
    zip

echo "✅ Essential dependencies installed successfully"
