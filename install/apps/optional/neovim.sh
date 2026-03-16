#!/bin/bash

# Install Neovim - Hyperextensible Vim-based text editor + LazyVim config
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

install_neovim() {
    log_step "Installing Neovim - Modern text editor"

    if command -v nvim &>/dev/null; then
        log_info "Neovim is already installed: $(nvim --version 2>/dev/null | head -1)"
        return 0
    fi

    log_info "Downloading latest stable Neovim..."
    (
        cd /tmp
        wget -q -O nvim.tar.gz \
            "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
        tar -xf nvim.tar.gz
        sudo install nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
        sudo cp -Rn nvim-linux-x86_64/lib /usr/local/ 2>/dev/null || true
        sudo cp -Rn nvim-linux-x86_64/share /usr/local/ 2>/dev/null || true
        rm -rf nvim-linux-x86_64 nvim.tar.gz
    )

    log_info "Installing Neovim dependencies (luarocks, tree-sitter-cli)..."
    sudo apt install -y luarocks tree-sitter-cli 2>/dev/null || true

    configure_neovim

    log_success "Neovim installed! Run: nvim (alias: n)"
}

configure_neovim() {
    if [ ! -d "$HOME/.config/nvim" ]; then
        log_info "Setting up LazyVim starter configuration..."
        git clone --depth=1 https://github.com/LazyVim/starter "$HOME/.config/nvim"
        rm -rf "$HOME/.config/nvim/.git"

        # Disable animated scrolling for better performance
        mkdir -p "$HOME/.config/nvim/lua/plugins"
        cat > "$HOME/.config/nvim/lua/plugins/snacks-scrolling.lua" << 'EOF'
return {
  "folke/snacks.nvim",
  opts = {
    scroll = { enabled = false },
  },
}
EOF

        # Disable relative line numbers (only if not already set)
        if ! grep -q "relativenumber" "$HOME/.config/nvim/lua/config/options.lua" 2>/dev/null; then
            echo "vim.opt.relativenumber = false" >> "$HOME/.config/nvim/lua/config/options.lua"
        fi

        log_success "LazyVim configuration applied"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_neovim
fi
