#!/bin/bash

# Install lazydocker - A terminal UI for Docker
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

install_lazydocker() {
    log_step "Installing lazydocker - Terminal UI for Docker"

    if command -v lazydocker &>/dev/null; then
        log_info "lazydocker is already installed: $(lazydocker --version 2>/dev/null | head -1)"
        return 0
    fi

    log_info "Fetching latest lazydocker release..."
    local version
    version=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" \
        | grep -Po '"tag_name": "v\K[^"]*') || {
        log_error "Failed to fetch lazydocker version"
        return 1
    }

    log_info "Downloading lazydocker v${version}..."
    (
        cd /tmp
        curl -sLo lazydocker.tar.gz \
            "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${version}_Linux_x86_64.tar.gz"
        tar -xf lazydocker.tar.gz lazydocker
        sudo install lazydocker /usr/local/bin
        rm -f lazydocker.tar.gz lazydocker
    )

    log_success "lazydocker v${version} installed! Run: lazydocker (alias: lzd)"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_lazydocker
fi
