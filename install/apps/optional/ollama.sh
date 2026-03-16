#!/bin/bash

# Install Ollama - Run large language models locally
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

install_ollama() {
    log_step "Installing Ollama - Run LLMs locally"

    if command -v ollama &>/dev/null; then
        log_info "Ollama is already installed: $(ollama --version 2>/dev/null | head -1)"
        return 0
    fi

    log_info "Downloading and running Ollama installer..."
    log_info "Note: The installer is fetched from https://ollama.com/install.sh (official source)"
    curl -fsSL https://ollama.com/install.sh | sh

    log_success "Ollama installed!"
    log_info "Usage examples:"
    log_info "  ollama run llama3.2       # Run Meta Llama 3.2"
    log_info "  ollama run mistral        # Run Mistral 7B"
    log_info "  ollama run phi4-mini      # Run Microsoft Phi-4 Mini"
    log_info "  ollama list               # List downloaded models"
    log_info "  ollama pull codellama     # Pull a coding assistant model"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_ollama
fi
