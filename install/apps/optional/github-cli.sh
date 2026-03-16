#!/bin/bash

# Install GitHub CLI (gh) - GitHub from the command line
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

install_github_cli() {
    log_step "Installing GitHub CLI (gh)"

    if command -v gh &>/dev/null; then
        log_info "GitHub CLI is already installed: $(gh --version 2>/dev/null | head -1)"
        return 0
    fi

    log_info "Adding GitHub CLI repository..."
    if [ ! -f /etc/apt/sources.list.d/github-cli.list ]; then
        if [ -f /usr/share/keyrings/githubcli-archive-keyring.gpg ]; then
            log_info "Removing outdated GitHub CLI keyring for refresh..."
            sudo rm /usr/share/keyrings/githubcli-archive-keyring.gpg
        fi

        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
            | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg status=none
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
https://cli.github.com/packages stable main" \
            | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    fi

    sudo apt update -y
    sudo apt install -y gh

    log_success "GitHub CLI installed! Run: gh auth login"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_github_cli
fi
