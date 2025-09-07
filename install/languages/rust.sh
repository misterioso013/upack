#!/bin/bash

# UPack Language - Rust Installation
# Installs Rust via rustup (official installer)

set -e

# Import common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../core/common-functions.sh"

# Check if Rust is installed
check_rust_installed() {
    command_exists rustc && command_exists cargo && command_exists rustup
}

# Install Rust via rustup
install_rust() {
    show_step "Installing Rust via rustup..."
    
    # Download and install rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    
    # Source Rust environment for current session
    source "$HOME/.cargo/env"
    
    show_success "Rust installed successfully"
}

# Configure Rust environment
configure_rust() {
    show_step "Configuring Rust environment..."
    
    # Add Rust configuration to shell profiles
    local shell_configs=("$HOME/.bashrc" "$HOME/.zshrc")
    
    for config in "${shell_configs[@]}"; do
        if [ -f "$config" ]; then
            # Check if Rust configuration already exists
            if ! grep -q "cargo/env" "$config"; then
                cat >> "$config" << 'EOF'

# Rust Configuration
. "$HOME/.cargo/env"
EOF
                show_info "Added Rust configuration to $(basename "$config")"
            fi
        fi
    done
    
    show_success "Rust environment configured"
}

# Install common Rust tools
install_rust_tools() {
    show_step "Installing common Rust tools..."
    
    # Source Rust environment
    source "$HOME/.cargo/env"
    
    # Install common tools
    cargo install cargo-edit      # cargo add, cargo rm commands
    cargo install cargo-watch     # Watch for file changes
    cargo install cargo-expand    # Show macro expansions
    
    show_success "Common Rust tools installed"
}

# Show Rust information
show_rust_info() {
    # Source Rust environment
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    fi
    
    if command_exists rustc; then
        local rust_version=$(rustc --version)
        local cargo_version=$(cargo --version)
        echo ""
        echo -e "${GREEN}${BOLD}Rust Installation Complete!${NC}"
        echo -e "${WHITE}Rust version: ${CYAN}$rust_version${NC}"
        echo -e "${WHITE}Cargo version: ${CYAN}$cargo_version${NC}"
        echo ""
        echo -e "${YELLOW}Usage examples:${NC}"
        echo -e "${WHITE}  cargo new my_project${NC}     - Create new Rust project"
        echo -e "${WHITE}  cargo build${NC}             - Build project"
        echo -e "${WHITE}  cargo run${NC}               - Build and run project"
        echo -e "${WHITE}  cargo test${NC}              - Run tests"
        echo -e "${WHITE}  rustup update${NC}           - Update Rust"
        echo ""
        echo -e "${CYAN}Rust tools installed:${NC}"
        echo -e "${WHITE}  cargo-edit${NC}              - Add/remove dependencies easily"
        echo -e "${WHITE}  cargo-watch${NC}             - Watch for file changes"
        echo -e "${WHITE}  cargo-expand${NC}            - Show macro expansions"
        echo ""
        echo -e "${CYAN}Restart your terminal or run: ${WHITE}source ~/.bashrc${NC}"
    fi
}

# Main installation function
main() {
    show_banner
    echo -e "${BLUE}${BOLD}Installing Rust via rustup...${NC}"
    echo ""
    
    # Check if already installed
    if check_rust_installed; then
        show_info "Rust is already installed"
        show_rust_info
        return 0
    fi
    
    # Install Rust
    install_rust
    configure_rust
    
    # Ask if user wants common tools
    echo ""
    read -p "Install common Rust tools (cargo-edit, cargo-watch, etc.)? [Y/n]: " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        install_rust_tools
    else
        show_info "Skipping common tools installation"
    fi
    
    # Show final information
    show_rust_info
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
