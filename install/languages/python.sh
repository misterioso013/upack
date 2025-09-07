#!/bin/bash

# UPack Language - Python Installation
# Installs Python via system package manager with optional pyenv

set -e

# Import common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../core/common-functions.sh"

# Check if Python is installed
check_python_installed() {
    command_exists python3 && command_exists pip3
}

# Install Python via apt
install_python_system() {
    show_step "Installing Python via system package manager..."
    
    # Update package list
    sudo apt update
    
    # Install Python and pip
    sudo apt install -y python3 python3-pip python3-venv python3-dev
    
    # Install common development packages
    sudo apt install -y build-essential libssl-dev libffi-dev
    
    # Create python alias if it doesn't exist
    if ! command_exists python; then
        echo 'alias python=python3' >> "$HOME/.bashrc"
        echo 'alias pip=pip3' >> "$HOME/.bashrc"
    fi
    
    show_success "Python installed via system package manager"
}

# Install pyenv (optional advanced version manager)
install_pyenv() {
    show_step "Installing pyenv (Python version manager)..."
    
    # Install dependencies
    sudo apt update
    sudo apt install -y make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
        libffi-dev liblzma-dev
    
    # Install pyenv
    curl https://pyenv.run | bash
    
    # Add pyenv to shell configuration
    local shell_configs=("$HOME/.bashrc" "$HOME/.zshrc")
    
    for config in "${shell_configs[@]}"; do
        if [ -f "$config" ]; then
            if ! grep -q "pyenv" "$config"; then
                cat >> "$config" << 'EOF'

# Python - pyenv Configuration  
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF
                show_info "Added pyenv configuration to $(basename "$config")"
            fi
        fi
    done
    
    show_success "pyenv installed successfully"
}

# Show Python information
show_python_info() {
    if command_exists python3; then
        local python_version=$(python3 --version)
        local pip_version=$(pip3 --version | cut -d' ' -f2)
        echo ""
        echo -e "${GREEN}${BOLD}Python Installation Complete!${NC}"
        echo -e "${WHITE}Python version: ${CYAN}$python_version${NC}"
        echo -e "${WHITE}pip version: ${CYAN}$pip_version${NC}"
        echo ""
        echo -e "${YELLOW}Usage examples:${NC}"
        echo -e "${WHITE}  python3 --version${NC}        - Check Python version"
        echo -e "${WHITE}  pip3 install requests${NC}    - Install packages"
        echo -e "${WHITE}  python3 -m venv myenv${NC}    - Create virtual environment"
        echo -e "${WHITE}  source myenv/bin/activate${NC} - Activate virtual environment"
        echo ""
        if command_exists pyenv; then
            echo -e "${CYAN}pyenv commands:${NC}"
            echo -e "${WHITE}  pyenv install 3.11.0${NC}   - Install specific Python version"
            echo -e "${WHITE}  pyenv global 3.11.0${NC}    - Set global Python version"
            echo -e "${WHITE}  pyenv versions${NC}          - List installed versions"
            echo ""
        fi
        echo -e "${CYAN}Restart your terminal or run: ${WHITE}source ~/.bashrc${NC}"
    fi
}

# Main installation function
main() {
    show_banner
    echo -e "${BLUE}${BOLD}Installing Python...${NC}"
    echo ""
    
    # Check if already installed
    if check_python_installed; then
        show_info "Python is already installed"
        show_python_info
        return 0
    fi
    
    # Install Python via system package manager
    install_python_system
    
    # Ask if user wants pyenv for version management
    echo ""
    echo -e "${YELLOW}Do you need multiple Python versions? (pyenv)${NC}"
    echo -e "${WHITE}pyenv allows you to install and switch between multiple Python versions${NC}"
    read -p "Install pyenv? [y/N]: " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_pyenv
    else
        show_info "Skipping pyenv installation"
    fi
    
    # Show final information
    show_python_info
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
