#!/bin/bash

# Install Flameshot - Powerful, yet simple-to-use screenshot software
# Inspired by omakub (https://github.com/basecamp/omakub)

UPACK_DIR="${UPACK_DIR:-$HOME/.local/share/upack}"
source "$UPACK_DIR/utils/gum.sh" 2>/dev/null || {
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
    log_warning() { echo "⚠️  $1"; }
} 2>/dev/null || true

if ! command -v log_step &>/dev/null; then
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
    log_warning() { echo "⚠️  $1"; }
fi

install_flameshot() {
    log_step "Installing Flameshot - Advanced screenshot tool"

    if command -v flameshot &>/dev/null; then
        log_info "Flameshot is already installed: $(flameshot --version 2>/dev/null | head -1)"
        return 0
    fi

    sudo apt install -y flameshot

    log_success "Flameshot installed! Run: flameshot gui"
    log_info "Tip: bind Flameshot to Print Screen key via GNOME keyboard settings"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_flameshot
fi
