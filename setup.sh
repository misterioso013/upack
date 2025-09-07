#!/bin/bash

# UPack Setup Script - Automatic Installation
# Automated Ubuntu productivity setup
# Usage: ./setup.sh

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Import common functions  
source "$SCRIPT_DIR/install/core/common-functions.sh"

# Configuration
SETUP_VERSION="2.0.0"
ESTIMATED_TIME="10-15 minutes"

# Show welcome message
show_welcome() {
    show_banner
    echo -e "${YELLOW}⏱️  Estimated time: $ESTIMATED_TIME${NC}"
    echo -e "${YELLOW}☕ Perfect time for a coffee break!${NC}"
    echo ""
    echo -e "${GREEN}${BOLD}🚀 Starting automatic UPack setup...${NC}"
    echo ""
    echo -e "${CYAN}🔐 This setup requires administrative privileges to install system packages${NC}"
    echo -e "${WHITE}You will be prompted for your password when needed${NC}"
    echo ""
}

# Pre-setup checks
run_pre_checks() {
    show_step "Running system checks..."
    
    check_root
    check_ubuntu
    check_internet
    
    show_success "System checks passed"
}

# Execute installation steps
run_installation_steps() {
    local steps=(
        "dependencies.sh:Installing essential dependencies"
        "essential-apps.sh:Installing essential applications" 
        "theme-install.sh:Setting up WhiteSur theme"
        "gnome-config.sh:Configuring GNOME environment"
        "terminal-config.sh:Configuring terminal"
        "fonts-install.sh:Installing fonts"
        "cli-install.sh:Installing UPack CLI"
        "infrastructure.sh:Setting up permanent infrastructure"
        "apps-install.sh:Installing desktop applications"
    )
    
    local step_number=1
    local total_steps=${#steps[@]}
    
    for step in "${steps[@]}"; do
        local script_name="${step%%:*}"
        local step_description="${step##*:}"
        
        show_step "($step_number/$total_steps) $step_description..."
        
        if execute_step "$SCRIPT_DIR/install/core/$script_name" "$step_description"; then
            echo ""  # Add spacing between steps
        else
            show_error "Setup failed at step: $step_description"
            show_post_failure_help
            exit 1
        fi
        
        ((step_number++))
    done
}

# Show completion message
show_completion() {
    echo ""
    echo -e "${GREEN}${BOLD}🎉 UPack setup completed successfully!${NC}"
    echo ""
    echo -e "${BLUE}${BOLD}📋 Next steps:${NC}"
    echo -e "  ${WHITE}1. 🔄 Restart your system: ${CYAN}sudo reboot${NC}"
    echo -e "  ${WHITE}2. 🔧 Install development tools: ${CYAN}upack install node python${NC}"
    echo -e "  ${WHITE}3. 🎮 Install optional apps: ${CYAN}upack install discord obs-studio${NC}"
    echo -e "  ${WHITE}4. 📊 Check system status: ${CYAN}upack status${NC}"
    echo ""
    echo -e "${CYAN}${BOLD}🚀 UPack CLI Commands:${NC}"
    echo -e "  ${WHITE}upack install <app>${NC}  - Install applications or languages"
    echo -e "  ${WHITE}upack status${NC}          - Show system status"
    echo -e "  ${WHITE}upack update${NC}          - Update all apps"
    echo -e "  ${WHITE}upack --help${NC}          - Show full help"
    echo ""
}

# Ask about system restart
ask_restart() {
    echo -e "${YELLOW}⚡ System restart recommended to apply all changes${NC}"
    read -p "Restart now? [y/N]: " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        show_info "Restarting system..."
        sudo reboot
    else
        echo -e "${YELLOW}📝 Remember to restart later: ${CYAN}sudo reboot${NC}"
    fi
    
    echo -e "${GREEN}${BOLD}🎯 UPack is ready to use!${NC}"
}

# Show help when setup fails
show_post_failure_help() {
    echo ""
    echo -e "${YELLOW}💡 Setup failed. Common solutions:${NC}"
    echo -e "${WHITE}  • Check your internet connection${NC}"
    echo -e "${WHITE}  • Ensure you have sudo privileges${NC}"
    echo -e "${WHITE}  • Close other package managers (Software Center, etc.)${NC}"
    echo -e "${WHITE}  • Run: ${CYAN}sudo apt update && sudo apt upgrade${NC}"
    echo ""
    echo -e "${CYAN}For help, visit: https://github.com/misterioso013/upack${NC}"
}

# Error handling
handle_error() {
    local exit_code=$?
    echo ""
    show_error "Setup interrupted (exit code: $exit_code)"
    show_post_failure_help
    exit $exit_code
}

# Set up error handling
trap handle_error ERR INT TERM

# Main installation function
main() {
    # Clear screen and show welcome
    clear
    show_welcome
    
    # Run pre-installation checks
    run_pre_checks
    echo ""
    
    # Record start time
    local start_time=$(date +%s)
    
    # Execute all installation steps
    run_installation_steps
    
    # Calculate elapsed time
    local end_time=$(date +%s)
    local elapsed=$((end_time - start_time))
    local minutes=$((elapsed / 60))
    local seconds=$((elapsed % 60))
    
    # Show completion
    show_completion
    echo -e "${GREEN}⏱️  Setup completed in ${minutes}m ${seconds}s${NC}"
    echo ""
    
    # Ask about restart
    ask_restart
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
