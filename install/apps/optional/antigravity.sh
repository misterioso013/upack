#!/bin/bash

# Install Antigravity - Auto-updater for antigravity packages

UPACK_DIR="${UPACK_DIR:-$HOME/.local/share/upack}"
if ! source "$UPACK_DIR/utils/gum.sh" 2>/dev/null || ! command -v log_step &>/dev/null; then
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
    log_warning() { echo "⚠️  $1"; }
fi

install_antigravity() {
    log_step "Installing Antigravity"

    if command -v antigravity &>/dev/null; then
        log_info "Antigravity is already installed."
        return 0
    fi

    log_info "Adding Antigravity repository..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
        sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg

    echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
        sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null

    sudo apt update -y
    sudo apt install -y antigravity

    log_success "Antigravity installed successfully."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_antigravity
fi
