#!/bin/bash

# Install lazygit - A simple terminal UI for git commands
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

install_lazygit() {
    log_step "Installing lazygit - Terminal UI for git"

    if command -v lazygit &>/dev/null; then
        log_info "lazygit is already installed: $(lazygit --version 2>/dev/null | head -1)"
        return 0
    fi

    log_info "Fetching latest lazygit release..."
    local version
    version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | grep -Po '"tag_name": "v\K[^"]*') || {
        log_error "Failed to fetch lazygit version"
        return 1
    }

    log_info "Downloading lazygit v${version}..."
    (
        cd /tmp
        curl -sLo lazygit.tar.gz \
            "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_x86_64.tar.gz"
        tar -xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm -f lazygit.tar.gz lazygit
    )

    mkdir -p "$HOME/.config/lazygit"
    touch "$HOME/.config/lazygit/config.yml"

    log_success "lazygit v${version} installed! Run: lazygit (alias: lzg)"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_lazygit
fi
