#!/bin/bash

# Install fastfetch - A fast and highly customisable system info tool
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

install_fastfetch() {
    log_step "Installing fastfetch - Fast system information tool"

    if command -v fastfetch &>/dev/null; then
        log_info "fastfetch is already installed: $(fastfetch --version 2>/dev/null | head -1)"
        return 0
    fi

    log_info "Adding fastfetch PPA..."
    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    sudo apt update -y
    sudo apt install -y fastfetch

    configure_fastfetch

    log_success "fastfetch installed! Run: fastfetch"
}

configure_fastfetch() {
    if [ ! -f "$HOME/.config/fastfetch/config.jsonc" ]; then
        log_info "Setting up fastfetch configuration..."
        mkdir -p "$HOME/.config/fastfetch"
        cat > "$HOME/.config/fastfetch/config.jsonc" << 'EOF'
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "auto",
        "padding": {
            "right": 2
        }
    },
    "display": {
        "separator": " → "
    },
    "modules": [
        "title",
        "separator",
        "os",
        "host",
        "kernel",
        "uptime",
        "packages",
        "shell",
        "display",
        "de",
        "wm",
        "terminal",
        "cpu",
        "gpu",
        "memory",
        "disk",
        "localip",
        "battery",
        "separator",
        "colors"
    ]
}
EOF
        log_success "fastfetch configured"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_fastfetch
fi
