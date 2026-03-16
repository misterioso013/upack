#!/bin/bash

# Install LocalSend - Open source cross-platform file sharing over local network
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

install_localsend() {
    log_step "Installing LocalSend - Cross-platform local file sharing"

    if command -v localsend &>/dev/null || dpkg -l localsend &>/dev/null 2>&1; then
        log_info "LocalSend is already installed"
        return 0
    fi

    log_info "Fetching latest LocalSend release..."
    local version
    version=$(curl -s "https://api.github.com/repos/localsend/localsend/releases/latest" \
        | grep -Po '"tag_name": "v\K[^"]*') || {
        log_error "Failed to fetch LocalSend version"
        return 1
    }

    log_info "Downloading LocalSend v${version}..."
    (
        cd /tmp
        wget -q -O localsend.deb \
            "https://github.com/localsend/localsend/releases/latest/download/LocalSend-${version}-linux-x86-64.deb"
        sudo apt install -y ./localsend.deb
        rm -f localsend.deb
    )

    log_success "LocalSend v${version} installed! Find it in your Applications menu."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_localsend
fi
