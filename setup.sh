#!/bin/bash

# UPack - Ubuntu Setup Automático
# Transforma Ubuntu recém-formatado em sistema produtivo
# Usage: ./setup.sh

set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

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
    echo -e "${CYAN}${BOLD}Ubuntu Productivity Pack - Automatic Setup${NC}"
    echo -e "${WHITE}Transforming your Ubuntu into a productive system...${NC}"
    echo ""
    echo -e "${YELLOW}⏱️  Estimated time: 10-15 minutes${NC}"
    echo -e "${YELLOW}☕ Perfect time for a coffee break!${NC}"
    echo ""
}

show_step() {
    echo -e "${BLUE}${BOLD}[$(date +'%H:%M:%S')] $1${NC}"
}

show_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

show_error() {
    echo -e "${RED}❌ $1${NC}"
}

main() {
    show_banner
    
    echo -e "${WHITE}🚀 Starting automatic UPack setup...${NC}"
    echo ""
    
    # Check environment
    if [ -n "$container" ] || [ -f /.dockerenv ]; then
        echo -e "${YELLOW}⚠️  Container environment detected${NC}"
        echo -e "${YELLOW}Some features may be limited${NC}"
        echo ""
    fi
    
    # Inform about sudo requirement
    echo -e "${CYAN}🔐 This setup requires administrative privileges to install system packages${NC}"
    echo -e "${WHITE}You will be prompted for your password when needed${NC}"
    echo ""
    
    # Get script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Step 1: Dependencies
    show_step "Installing essential dependencies..."
    if bash "$SCRIPT_DIR/install/core/dependencies.sh"; then
        show_success "Dependencies installed"
    else
        show_error "Dependencies installation failed"
        echo ""
        echo -e "${YELLOW}💡 This usually happens due to:${NC}"
        echo -e "${WHITE}  • Incorrect password or insufficient privileges${NC}"
        echo -e "${WHITE}  • Network connectivity issues${NC}"
        echo -e "${WHITE}  • Container/restricted environment${NC}"
        echo -e "${WHITE}  • Package manager locked by another process${NC}"
        echo ""
        echo -e "${CYAN}Please fix the issue and run ./setup.sh again${NC}"
        exit 1
    fi
    
    # Step 2: Essential Apps
    show_step "Installing essential applications..."
    if bash "$SCRIPT_DIR/install/core/essential-apps.sh"; then
        show_success "Essential applications installed"
    else
        show_error "Applications installation failed"
        exit 1
    fi
    
    # Step 3: Theme
    show_step "Setting up WhiteSur theme..."
    if bash "$SCRIPT_DIR/install/core/theme-setup.sh"; then
        show_success "Theme configured"
    else
        show_error "Theme setup failed"
        exit 1
    fi
    
    # Step 4: GNOME
    show_step "Configuring GNOME environment..."
    if bash "$SCRIPT_DIR/install/core/gnome-config.sh"; then
        show_success "GNOME configured"
    else
        show_error "GNOME configuration failed"
        exit 1
    fi
    
    # Step 5: Terminal
    show_step "Configuring terminal..."
    if bash "$SCRIPT_DIR/install/core/terminal-setup.sh"; then
        show_success "Terminal configured"
    else
        show_error "Terminal setup failed"
        exit 1
    fi
    
    # Step 6: Fonts
    show_step "Installing fonts..."
    if bash "$SCRIPT_DIR/install/core/fonts-install.sh"; then
        show_success "Fonts installed"
    else
        show_error "Fonts installation failed"
        exit 1
    fi
    
    # Step 7: UPack CLI
    show_step "Installing UPack CLI..."
    if bash "$SCRIPT_DIR/install/core/upack-cli.sh"; then
        show_success "UPack CLI installed"
    else
        show_error "UPack CLI installation failed"
        exit 1
    fi
    
    # Success message
    echo ""
    echo -e "${GREEN}${BOLD}🎉 UPack setup completed successfully!${NC}"
    echo ""
    echo -e "${CYAN}${BOLD}📋 Next steps:${NC}"
    echo -e "${WHITE}  1. 🔄 Restart your system: ${YELLOW}sudo reboot${NC}"
    echo -e "${WHITE}  2. 🔧 Install development tools: ${YELLOW}upack install node python${NC}"
    echo -e "${WHITE}  3. 🎮 Install optional apps: ${YELLOW}upack install discord obs-studio${NC}"
    echo -e "${WHITE}  4. 📊 Check system status: ${YELLOW}upack status${NC}"
    echo ""
    echo -e "${BLUE}${BOLD}🚀 UPack CLI Commands:${NC}"
    echo -e "${WHITE}  ${YELLOW}upack install <app>${NC}  - Install applications or languages"
    echo -e "${WHITE}  ${YELLOW}upack status${NC}          - Show system status"
    echo -e "${WHITE}  ${YELLOW}upack update${NC}          - Update all apps"
    echo -e "${WHITE}  ${YELLOW}upack --help${NC}          - Show full help"
    echo ""
    
    # Ask about reboot
    echo -e "${CYAN}${BOLD}⚡ System restart recommended to apply all changes${NC}"
    read -p "$(echo -e "${WHITE}Restart now? [y/N]: ${NC}")" restart
    
    if [[ $restart =~ ^[YySs]$ ]]; then
        echo -e "${YELLOW}🔄 Rebooting system in 3 seconds...${NC}"
        sleep 3
        sudo reboot
    else
        echo -e "${YELLOW}📝 Remember to restart later: ${WHITE}sudo reboot${NC}"
        echo -e "${GREEN}🎯 UPack is ready to use!${NC}"
    fi
}

# Error handling
trap 'show_error "Setup interrupted"; exit 1' INT TERM

# Run main function
main "$@"
    echo "2. ⚡ Minimal Installation"
    echo "   - Only essential apps and configurations"
    echo "   - Faster installation"
    echo ""
    echo "3. 🎨 Desktop Environment Only"
    echo "   - GNOME extensions and theme"
    echo "   - No additional applications"
    echo ""
    echo "4. 💻 Developer Setup"
    echo "   - Development tools and terminal setup"
    echo "   - VS Code, Git, and productivity tools"
    echo ""
    echo "5. 🔧 Custom Installation"
    echo "   - Choose individual components"
    echo ""
    echo "6. ❌ Exit"
    echo ""
}

install_dependencies() {
    echo -e "${BLUE}Installing dependencies...${NC}"
    
    # Update package list
    sudo apt update
    
    # Install essential dependencies
    sudo apt install -y curl wget git build-essential software-properties-common
    
    # Install gum for better UI with proper GPG verification
    if ! command -v gum &> /dev/null; then
        # Ensure gnupg is available for GPG operations
        sudo apt install -y gnupg
        
        # Download and install Charm's GPG key
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/charm-archive-keyring.gpg
        sudo chmod 644 /usr/share/keyrings/charm-archive-keyring.gpg
        
        # Add repository with proper suite/component and GPG verification
        echo "deb [signed-by=/usr/share/keyrings/charm-archive-keyring.gpg] https://repo.charm.sh/apt/ stable main" | sudo tee /etc/apt/sources.list.d/charm.list
        sudo apt update && sudo apt install -y gum
    fi
}

full_installation() {
    echo -e "${GREEN}${BOLD}Starting Full Installation...${NC}"
    
    # Required apps
    bash "$SCRIPT_DIR/core/required.sh"
    
    # Optional apps
    bash "$SCRIPT_DIR/core/optional.sh"
    
    # Desktop environment
    bash "$SCRIPT_DIR/config/gnome/apply-config.sh"
    
    # Terminal setup
    bash "$SCRIPT_DIR/config/terminal/bash-config.sh"
    
    # UPack app
    bash "$SCRIPT_DIR/install/apps/required/upack-app.sh"
    
    echo -e "${GREEN}${BOLD}Full installation completed!${NC}"
}

minimal_installation() {
    echo -e "${GREEN}${BOLD}Starting Minimal Installation...${NC}"
    
    # Essential apps only
    bash "$SCRIPT_DIR/install/apps/required/chrome.sh"
    bash "$SCRIPT_DIR/install/apps/required/vscode.sh"
    bash "$SCRIPT_DIR/install/apps/required/gnome-tweaks.sh"
    
    # Basic GNOME config
    bash "$SCRIPT_DIR/config/gnome/hotkeys.sh"
    
    # UPack app
    bash "$SCRIPT_DIR/install/apps/required/upack-app.sh"
    
    echo -e "${GREEN}${BOLD}Minimal installation completed!${NC}"
}

desktop_only_installation() {
    echo -e "${GREEN}${BOLD}Starting Desktop Environment Setup...${NC}"
    
    # Theme installation
    bash "$SCRIPT_DIR/install/theme.sh"
    
    # GNOME extensions
    bash "$SCRIPT_DIR/install/gnome-extensions.sh"
    
    # GNOME configuration
    bash "$SCRIPT_DIR/config/gnome/apply-config.sh"
    
    echo -e "${GREEN}${BOLD}Desktop environment setup completed!${NC}"
}

developer_installation() {
    echo -e "${GREEN}${BOLD}Starting Developer Setup...${NC}"
    
    # Development tools
    bash "$SCRIPT_DIR/install/apps/required/vscode.sh"
    bash "$SCRIPT_DIR/install/apps/required/chrome.sh"
    bash "$SCRIPT_DIR/config/github/ssh-config.sh"
    
    # Terminal setup
    bash "$SCRIPT_DIR/config/terminal/bash-config.sh"
    bash "$SCRIPT_DIR/install/apps/optional/terminal-config.sh"
    
    # System monitor
    bash "$SCRIPT_DIR/install/apps/optional/btop.sh"
    
    # UPack app
    bash "$SCRIPT_DIR/install/apps/required/upack-app.sh"
    
    echo -e "${GREEN}${BOLD}Developer setup completed!${NC}"
}

custom_installation() {
    echo -e "${GREEN}${BOLD}Custom Installation${NC}"
    echo ""
    
    # Use gum for interactive selection if available
    if command -v gum &> /dev/null; then
        COMPONENTS=$(gum choose --no-limit \
            "🌟 WhiteSur Theme" \
            "🧩 GNOME Extensions" \
            "⌨️  GNOME Hotkeys" \
            "💻 Terminal Configuration" \
            "🌐 Google Chrome" \
            "📝 VS Code" \
            "🎵 Discord" \
            "📺 OBS Studio" \
            "🎮 TLauncher" \
            "📊 System Monitor (btop)" \
            "🔧 UPack Manager")
    else
        echo "Select components to install (enter numbers separated by spaces):"
        echo "1. WhiteSur Theme"
        echo "2. GNOME Extensions"  
        echo "3. GNOME Hotkeys"
        echo "4. Terminal Configuration"
        echo "5. Google Chrome"
        echo "6. VS Code"
        echo "7. Discord"
        echo "8. OBS Studio"
        echo "9. TLauncher"
        echo "10. System Monitor (btop)"
        echo "11. UPack Manager"
        
        read -p "Enter selection: " SELECTION
        
        # Convert numbers to component names (newline-separated)
        COMPONENTS=""
        for num in $SELECTION; do
            case $num in
                1) COMPONENTS+="🌟 WhiteSur Theme"$'\n' ;;
                2) COMPONENTS+="🧩 GNOME Extensions"$'\n' ;;
                3) COMPONENTS+="⌨️  GNOME Hotkeys"$'\n' ;;
                4) COMPONENTS+="💻 Terminal Configuration"$'\n' ;;
                5) COMPONENTS+="🌐 Google Chrome"$'\n' ;;
                6) COMPONENTS+="📝 VS Code"$'\n' ;;
                7) COMPONENTS+="🎵 Discord"$'\n' ;;
                8) COMPONENTS+="📺 OBS Studio"$'\n' ;;
                9) COMPONENTS+="🎮 TLauncher"$'\n' ;;
                10) COMPONENTS+="📊 System Monitor (btop)"$'\n' ;;
                11) COMPONENTS+="🔧 UPack Manager"$'\n' ;;
            esac
        done
    fi
    
    # Install selected components (properly handle multi-word components)
    while IFS= read -r component; do
        [[ -z "$component" ]] && continue
        case "$component" in
            *"WhiteSur Theme"*) bash "$SCRIPT_DIR/install/theme.sh" ;;
            *"GNOME Extensions"*) bash "$SCRIPT_DIR/install/gnome-extensions.sh" ;;
            *"GNOME Hotkeys"*) bash "$SCRIPT_DIR/config/gnome/hotkeys.sh" ;;
            *"Terminal Configuration"*) bash "$SCRIPT_DIR/config/terminal/bash-config.sh" ;;
            *"Google Chrome"*) bash "$SCRIPT_DIR/install/apps/required/chrome.sh" ;;
            *"VS Code"*) bash "$SCRIPT_DIR/install/apps/required/vscode.sh" ;;
            *"Discord"*) bash "$SCRIPT_DIR/install/apps/optional/discord.sh" ;;
            *"OBS Studio"*) bash "$SCRIPT_DIR/install/apps/optional/obs-studio.sh" ;;
            *"TLauncher"*) bash "$SCRIPT_DIR/install/apps/optional/tlauncher.sh" ;;
            *"System Monitor"*) bash "$SCRIPT_DIR/install/apps/optional/btop.sh" ;;
            *"UPack Manager"*) bash "$SCRIPT_DIR/install/apps/required/upack-app.sh" ;;
        esac
    done <<< "$COMPONENTS"
    
    echo -e "${GREEN}${BOLD}Custom installation completed!${NC}"
}

show_completion() {
    echo ""
    echo -e "${GREEN}${BOLD}🎉 UPack installation completed successfully!${NC}"
    echo ""
    echo -e "${BLUE}${BOLD}Next steps:${NC}"
    echo "1. 🔄 Restart your system to apply all changes"
    echo "2. 🚀 Search for 'UPack Manager' in activities"
    echo "3. ⌨️  Learn the new hotkeys with Super+/ or 'upack hotkeys'"
    echo "4. 🎨 Customize your desktop with GNOME Tweaks"
    echo ""
    echo -e "${CYAN}${BOLD}UPack CLI Commands:${NC}"
    echo "  ${WHITE}upack status${NC}     - Show system status"
    echo "  ${WHITE}upack update${NC}     - Update all apps"
    echo "  ${WHITE}upack monitor${NC}    - Open system monitor"
    echo "  ${WHITE}upack gui${NC}        - Open UPack Manager"
    echo ""
    
    read -p "Press Enter to continue..."
}

main() {
    show_banner
    
    # Install dependencies first
    install_dependencies
    
    while true; do
        show_menu
        
        if command -v gum &> /dev/null; then
            choice=$(gum choose "Full Installation" "Minimal Installation" "Desktop Environment Only" "Developer Setup" "Custom Installation" "Exit")
            case "$choice" in
                "Full Installation") full_installation && show_completion && break ;;
                "Minimal Installation") minimal_installation && show_completion && break ;;
                "Desktop Environment Only") desktop_only_installation && show_completion && break ;;
                "Developer Setup") developer_installation && show_completion && break ;;
                "Custom Installation") custom_installation && show_completion && break ;;
                "Exit") echo "Goodbye!"; exit 0 ;;
            esac
        else
            read -p "Enter your choice (1-6): " choice
            case $choice in
                1) full_installation && show_completion && break ;;
                2) minimal_installation && show_completion && break ;;
                3) desktop_only_installation && show_completion && break ;;
                4) developer_installation && show_completion && break ;;
                5) custom_installation && show_completion && break ;;
                6) echo "Goodbye!"; exit 0 ;;
                *) echo -e "${RED}Invalid choice. Please try again.${NC}"; sleep 2 ;;
            esac
        fi
        
        clear
        show_banner
    done
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
