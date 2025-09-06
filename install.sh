#!/bin/bash

# UPack One-Line Installation Script
# Downloads and installs UPack from GitHub

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# Variables
REPO_URL="https://github.com/misterioso013/upack"
TEMP_DIR="/tmp/upack-install-$$"
INSTALL_DIR="$HOME/.local/share/upack"

# Functions
show_banner() {
    clear
    echo -e "${BLUE}${BOLD}"
    echo "██╗   ██╗██████╗  █████╗  ██████╗██╗  ██╗"
    echo "██║   ██║██╔══██╗██╔══██╗██╔════╝██║ ██╔╝"
    echo "██║   ██║██████╔╝███████║██║     █████╔╝ "
    echo "██║   ██║██╔═══╝ ██╔══██║██║     ██╔═██╗ "
    echo "╚██████╔╝██║     ██║  ██║╚██████╗██║  ██╗"
    echo " ╚═════╝ ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝"
    echo -e "${NC}"
    echo -e "${CYAN}${BOLD}Ubuntu Productivity Package${NC}"
    echo -e "${WHITE}One command to rule them all${NC}"
    echo ""
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_step() {
    echo -e "${CYAN}🔄 $1${NC}"
}

# Check if running on Ubuntu
check_ubuntu() {
    if [ ! -f /etc/lsb-release ] || ! grep -q "Ubuntu" /etc/lsb-release; then
        log_error "This script is designed for Ubuntu. Detected OS may not be supported."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Check dependencies
check_dependencies() {
    log_step "Checking dependencies"
    
    local missing_deps=()
    
    # Check for git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    # Check for curl
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi
    
    # Install missing dependencies
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_info "Installing missing dependencies: ${missing_deps[*]}"
        sudo apt update
        sudo apt install -y "${missing_deps[@]}"
    fi
    
    log_success "Dependencies checked"
}

# Download UPack
download_upack() {
    log_step "Downloading UPack from GitHub"
    
    # Clean up any existing temp directory
    rm -rf "$TEMP_DIR"
    mkdir -p "$TEMP_DIR"
    
    # Clone the repository
    git clone "$REPO_URL" "$TEMP_DIR" || {
        log_error "Failed to download UPack repository"
        exit 1
    }
    
    log_success "UPack downloaded to $TEMP_DIR"
}

# Install UPack
install_upack() {
    log_step "Installing UPack"
    
    # Create installation directory
    mkdir -p "$INSTALL_DIR"
    
    # Copy files to installation directory
    cp -r "$TEMP_DIR"/* "$INSTALL_DIR/"
    
    # Make scripts executable
    chmod +x "$INSTALL_DIR"/setup.sh
    chmod +x "$INSTALL_DIR"/dev.sh
    chmod +x "$INSTALL_DIR"/bin/*
    chmod +x "$INSTALL_DIR"/install/apps/*/*.sh
    chmod +x "$INSTALL_DIR"/config/*/*.sh
    
    log_success "UPack installed to $INSTALL_DIR"
}

# Run setup
run_setup() {
    log_step "Running UPack setup"
    
    cd "$INSTALL_DIR"
    ./setup.sh
}

# Cleanup
cleanup() {
    log_step "Cleaning up temporary files"
    rm -rf "$TEMP_DIR"
    log_success "Cleanup completed"
}

# Main installation process
main() {
    show_banner
    
    log_info "Starting UPack installation..."
    echo ""
    
    # Confirm installation
    echo -e "${YELLOW}This will install UPack on your system.${NC}"
    echo "UPack will:"
    echo "  • Install essential applications"
    echo "  • Configure your desktop environment" 
    echo "  • Set up development tools"
    echo "  • Apply beautiful themes and settings"
    echo ""
    
    read -p "Continue with installation? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        log_info "Installation cancelled by user"
        exit 0
    fi
    
    # Installation steps
    check_ubuntu
    check_dependencies
    download_upack
    install_upack
    run_setup
    cleanup
    
    echo ""
    log_success "UPack installation completed!"
    echo ""
    echo -e "${CYAN}${BOLD}What's next?${NC}"
    echo "  • Restart your terminal or run: source ~/.bashrc"
    echo "  • Use 'upack' command for system management"
    echo "  • Use 'upack-tui' for interactive interface"
    echo "  • Check 'upack --help' for available commands"
    echo ""
    echo -e "${GREEN}Welcome to UPack! 🚀${NC}"
}

# Error handling
trap 'log_error "Installation failed! Check the error above."; cleanup; exit 1' ERR

# Run main function
main "$@"
