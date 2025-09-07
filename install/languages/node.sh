#!/bin/bash

# UPack Language - Node.js Installation
# Installs Node.js via NVM (Node Version Manager)

set -e

# Import common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../core/common-functions.sh"

# Configuration
NODE_LTS_VERSION="--lts"
NVM_VERSION="v0.39.0"

# Check if NVM is installed
check_nvm_installed() {
    [ -s "$HOME/.nvm/nvm.sh" ] && [ -s "$HOME/.nvm/bash_completion" ]
}

# Check if Node.js is installed
check_node_installed() {
    command_exists node && command_exists npm
}

# Install NVM
install_nvm() {
    show_step "Installing NVM (Node Version Manager)..."
    
    # Download and install NVM
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
    
    # Source NVM for current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    
    show_success "NVM installed successfully"
}

# Install Node.js via NVM
install_node() {
    show_step "Installing Node.js LTS via NVM..."
    
    # Ensure NVM is available
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Install and use Node.js LTS
    nvm install $NODE_LTS_VERSION
    nvm use $NODE_LTS_VERSION
    nvm alias default node
    
    show_success "Node.js LTS installed successfully"
}

# Configure Node.js environment
configure_node() {
    show_step "Configuring Node.js environment..."
    
    # Add NVM configuration to shell profiles
    local shell_configs=("$HOME/.bashrc" "$HOME/.zshrc")
    
    for config in "${shell_configs[@]}"; do
        if [ -f "$config" ]; then
            # Check if NVM configuration already exists
            if ! grep -q "NVM_DIR" "$config"; then
                cat >> "$config" << 'EOF'

# Node.js - NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
                show_info "Added NVM configuration to $(basename "$config")"
            fi
        fi
    done
    
    show_success "Node.js environment configured"
}

# Show Node.js information
show_node_info() {
    # Source NVM for current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    if command_exists node; then
        local node_version=$(node --version)
        local npm_version=$(npm --version)
        echo ""
        echo -e "${GREEN}${BOLD}Node.js Installation Complete!${NC}"
        echo -e "${WHITE}Node.js version: ${CYAN}$node_version${NC}"
        echo -e "${WHITE}npm version: ${CYAN}$npm_version${NC}"
        echo ""
        echo -e "${YELLOW}Usage examples:${NC}"
        echo -e "${WHITE}  node --version${NC}     - Check Node.js version"
        echo -e "${WHITE}  npm install -g yarn${NC}  - Install Yarn globally"
        echo -e "${WHITE}  nvm install 18${NC}      - Install specific Node.js version"
        echo -e "${WHITE}  nvm use 18${NC}          - Switch to Node.js version 18"
        echo ""
        echo -e "${CYAN}Restart your terminal or run: ${WHITE}source ~/.bashrc${NC}"
    fi
}

# Main installation function
main() {
    show_banner
    echo -e "${BLUE}${BOLD}Installing Node.js via NVM...${NC}"
    echo ""
    
    # Check if already installed
    if check_node_installed && check_nvm_installed; then
        show_info "Node.js and NVM are already installed"
        show_node_info
        return 0
    fi
    
    # Install NVM if not present
    if ! check_nvm_installed; then
        install_nvm
    else
        show_info "NVM already installed"
    fi
    
    # Install Node.js if not present
    if ! check_node_installed; then
        install_node
        configure_node
    else
        show_info "Node.js already installed"
    fi
    
    # Show final information
    show_node_info
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
