#!/bin/bash

# Configure mise with popular language versions
# This script sets up commonly used versions of languages via mise

UPACK_DIR="${UPACK_DIR:-$HOME/.local/share/upack}"
source "$UPACK_DIR/utils/gum.sh" 2>/dev/null || {
    # Fallback log functions if gum.sh not available
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
    log_warning() { echo "⚠️  $1"; }
} 2>/dev/null || true

# Define log functions if not already available
if ! command -v log_step &> /dev/null; then
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
    log_warning() { echo "⚠️  $1"; }
fi

# Check if mise is installed
check_mise() {
    if ! command -v mise &> /dev/null; then
        log_error "mise is not installed. Please install mise first by running the dev-languages.sh script"
        return 1
    fi
    
    # Activate mise
    eval "$(mise activate bash)"
    return 0
}

# Configure mise with popular language versions
setup_mise_languages() {
    log_step "Setting up popular language versions with mise"
    
    # Note: Node.js is handled by NVM in the main dev-languages script
    log_info "Skipping Node.js (managed by NVM)"
    
    # Python - Install popular versions
    if command -v gum &>/dev/null; then
        if gum confirm "Install Python versions (3.11, 3.12)?"; then
            mise install python@3.12
            mise install python@3.11
            mise use -g python@3.12
            log_success "Python versions installed and 3.12 set as global"
        fi
    else
        echo "Install Python versions? (y/N)"
        read -r answer
        if [[ $answer =~ ^[Yy]$ ]]; then
            mise install python@3.12
            mise install python@3.11
            mise use -g python@3.12
            log_success "Python versions installed and 3.12 set as global"
        fi
    fi
    
    # Java - Install LTS versions
    if command -v gum &>/dev/null; then
        if gum confirm "Install Java versions (11, 17, 21)?"; then
            mise install java@17
            mise install java@11
            mise install java@21
            mise use -g java@17
            log_success "Java versions installed and 17 set as global"
        fi
    else
        echo "Install Java versions? (y/N)"
        read -r answer
        if [[ $answer =~ ^[Yy]$ ]]; then
            mise install java@17
            mise install java@11
            mise install java@21
            mise use -g java@17
            log_success "Java versions installed and 17 set as global"
        fi
    fi
    
    # Go - Install recent versions
    if command -v gum &>/dev/null; then
        if gum confirm "Install Go versions (latest)?"; then
            mise install go@latest
            mise use -g go@latest
            log_success "Go latest version installed and set as global"
        fi
    else
        echo "Install Go latest version? (y/N)"
        read -r answer
        if [[ $answer =~ ^[Yy]$ ]]; then
            mise install go@latest
            mise use -g go@latest
            log_success "Go latest version installed and set as global"
        fi
    fi
    
    # PHP - Install stable versions
    if command -v gum &>/dev/null; then
        if gum confirm "Install PHP versions (8.2, 8.3)?"; then
            mise install php@8.3
            mise install php@8.2
            mise use -g php@8.3
            log_success "PHP versions installed and 8.3 set as global"
        fi
    else
        echo "Install PHP versions? (y/N)"
        read -r answer
        if [[ $answer =~ ^[Yy]$ ]]; then
            mise install php@8.3
            mise install php@8.2
            mise use -g php@8.3
            log_success "PHP versions installed and 8.3 set as global"
        fi
    fi
    
    # Ruby - Install stable versions
    if command -v gum &>/dev/null; then
        if gum confirm "Install Ruby versions (3.2, 3.3)?"; then
            mise install ruby@3.3
            mise install ruby@3.2
            mise use -g ruby@3.3
            log_success "Ruby versions installed and 3.3 set as global"
        fi
    else
        echo "Install Ruby versions? (y/N)"
        read -r answer
        if [[ $answer =~ ^[Yy]$ ]]; then
            mise install ruby@3.3
            mise install ruby@3.2
            mise use -g ruby@3.3
            log_success "Ruby versions installed and 3.3 set as global"
        fi
    fi
    
    # Rust - Install stable
    if command -v gum &>/dev/null; then
        if gum confirm "Install Rust stable version?"; then
            mise install rust@stable
            mise use -g rust@stable
            log_success "Rust stable version installed and set as global"
        fi
    else
        echo "Install Rust stable version? (y/N)"
        read -r answer
        if [[ $answer =~ ^[Yy]$ ]]; then
            mise install rust@stable
            mise use -g rust@stable
            log_success "Rust stable version installed and set as global"
        fi
    fi
    
    # Deno - Install latest
    if command -v gum &>/dev/null; then
        if gum confirm "Install Deno latest version?"; then
            mise install deno@latest
            mise use -g deno@latest
            log_success "Deno latest version installed and set as global"
        fi
    else
        echo "Install Deno latest version? (y/N)"
        read -r answer
        if [[ $answer =~ ^[Yy]$ ]]; then
            mise install deno@latest
            mise use -g deno@latest
            log_success "Deno latest version installed and set as global"
        fi
    fi
}

# Create a .mise.toml file with common configurations
create_mise_config() {
    log_step "Creating default mise configuration"
    
    local config_file="$HOME/.config/mise/config.toml"
    mkdir -p "$(dirname "$config_file")"
    
    cat > "$config_file" << 'EOF'
# mise configuration file
# Global settings for all projects

[settings]
experimental = true
legacy_version_file = true

[tools]
# Global tool versions (Node.js managed by NVM)
python = "3.12"
java = "17"
go = "latest"

[env]
# Global environment variables
PYTHONPATH = "."

[aliases]
# Command aliases (Node.js handled by NVM)
py = "python"
EOF
    
    log_success "mise configuration created at $config_file"
}

# Show mise status and installed tools
show_mise_status() {
    log_step "Showing mise status"
    
    echo ""
    echo "📊 mise Status:"
    mise list
    
    echo ""
    echo "🌍 Global tools:"
    mise ls --global
    
    echo ""
    echo "⚙️  mise Configuration:"
    mise settings
}

# Main function
setup_mise() {
    log_step "Setting up mise with popular language versions"
    
    # Check if mise is installed
    if ! check_mise; then
        return 1
    fi
    
    log_info "This script will set up common language versions using mise"
    echo ""
    
    # Setup languages
    setup_mise_languages
    
    # Create configuration
    create_mise_config
    
    # Show status
    show_mise_status
    
    echo ""
    log_success "mise setup completed!"
    echo ""
    echo "📝 Next steps:"
    echo "   • Create project-specific .mise.toml files with: mise init"
    echo "   • Switch to a different version: mise use <tool>@<version>"
    echo "   • List available versions: mise ls-remote <tool>"
    echo "   • Update tools: mise upgrade"
    echo "   • Check status: mise list"
    echo ""
}

# Run the setup
setup_mise
