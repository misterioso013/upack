#!/bin/bash

# Docker Desktop installation script for Ubuntu
# Based on: https://docs.docker.com/desktop/setup/install/linux/ubuntu/

echo "🐳 Installing Docker Desktop..."

# Check if Docker Desktop is already installed
if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
    echo "✔️ Docker Desktop is already installed. Checking version..."
    docker --version
    docker-compose --version
    echo "✅ Docker Desktop installation verified."
    return 0 2>/dev/null || exit 0
fi

# Update package index
echo "📦 Updating package index..."
sudo apt-get update

# Install prerequisites
echo "🔧 Installing prerequisites..."
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
echo "🔑 Adding Docker's official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "📋 Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again
echo "📦 Updating package index with Docker repository..."
sudo apt-get update

# Install Docker Engine, CLI, containerd, and Docker Compose
echo "🐳 Installing Docker Engine and Docker Compose..."
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Download and install Docker Desktop
echo "🖥️ Installing Docker Desktop..."
ARCH=$(dpkg --print-architecture)
if [[ "$ARCH" == "amd64" ]]; then
    DOCKER_DESKTOP_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb"
elif [[ "$ARCH" == "arm64" ]]; then
    DOCKER_DESKTOP_URL="https://desktop.docker.com/linux/main/arm64/docker-desktop-arm64.deb"
else
    echo "❌ Unsupported architecture: $ARCH"
    echo "   Docker Desktop supports amd64 and arm64 only"
    return 1 2>/dev/null || exit 1
fi

# Download Docker Desktop
echo "⬇️ Downloading Docker Desktop for $ARCH..."
cd /tmp
if wget -O docker-desktop.deb "$DOCKER_DESKTOP_URL"; then
    echo "✅ Docker Desktop downloaded successfully"
else
    echo "❌ Failed to download Docker Desktop"
    return 1 2>/dev/null || exit 1
fi

# Install Docker Desktop
echo "📦 Installing Docker Desktop package..."
if sudo apt install -y ./docker-desktop.deb; then
    echo "✅ Docker Desktop installed successfully"
else
    echo "❌ Failed to install Docker Desktop"
    return 1 2>/dev/null || exit 1
fi

# Clean up
rm -f docker-desktop.deb

# Add current user to docker group
echo "👤 Adding current user to docker group..."
sudo usermod -aG docker $USER

# Enable and start Docker service
echo "🚀 Enabling and starting Docker service..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl start docker.service
sudo systemctl start containerd.service

echo ""
echo "✅ Docker Desktop installation completed!"
echo ""
echo "📋 What was installed:"
echo "   • Docker Engine"
echo "   • Docker CLI"
echo "   • Docker Compose"
echo "   • Docker Desktop GUI"
echo "   • Containerd runtime"
echo ""
echo "🔄 Important: You need to log out and log back in (or restart)"
echo "   for the group changes to take effect."
echo ""
echo "🚀 After relogging, you can:"
echo "   • Start Docker Desktop from Applications menu"
echo "   • Use 'docker run hello-world' to test"
echo "   • Use 'docker-compose' for multi-container apps"
echo ""

# Test Docker installation (might fail if user needs to relog)
echo "🧪 Testing Docker installation..."
if docker --version &> /dev/null; then
    echo "✅ Docker CLI is working"
    docker --version
else
    echo "⚠️ Docker CLI test failed (you may need to relog)"
fi

if docker-compose --version &> /dev/null; then
    echo "✅ Docker Compose is working"
    docker-compose --version
else
    echo "⚠️ Docker Compose test failed (you may need to relog)"
fi

echo "✅ Docker installation script completed."