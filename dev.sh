#!/usr/bin/env bash

set -e

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPACK_DIR="$HOME/.local/share/upack"

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
    echo -e "${CYAN}${BOLD}Development Mode${NC}"
    echo -e "${WHITE}Testing and debugging UPack components${NC}"
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

check_dependencies() {
    log_step "Checking dependencies..."
    
    # Check if we're in the UPack directory
    if [ ! -f "$SCRIPT_DIR/setup.sh" ]; then
        log_error "Not in UPack directory. Run this script from the UPack root."
        exit 1
    fi
    
    # Check for required utilities
    local missing_deps=()
    
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_warning "Missing dependencies: ${missing_deps[*]}"
        log_info "Installing missing dependencies..."
        sudo apt update && sudo apt install -y "${missing_deps[@]}"
    fi
    
    log_success "Dependencies OK"
}

copy_to_install_dir() {
    log_step "Copying UPack files to $UPACK_DIR..."
    
    # Create directory if it doesn't exist
    mkdir -p "$UPACK_DIR"
    
    # Copy all files to install directory
    if ! rsync -av --exclude='.git' "$SCRIPT_DIR/" "$UPACK_DIR/"; then
        log_error "Failed to copy files to install directory (rsync exit code: $?)"
        exit 1
    fi
    
    # Make scripts executable
    find "$UPACK_DIR" -name "*.sh" -exec chmod +x {} \;
    chmod +x "$UPACK_DIR/bin/"*
    
    log_success "Files copied to install directory"
}

test_components() {
    log_step "Testing UPack components..."
    
    cd "$UPACK_DIR"
    
    # Test gum utility
    if ! source "utils/gum.sh" 2>/dev/null; then
        log_error "Failed to source utils/gum.sh"
        exit 1
    fi
    
    # Test if UPack CLI is working
    export PATH="$HOME/.local/bin:$PATH"
    if command -v upack &> /dev/null; then
        log_info "Testing UPack CLI..."
        upack --version || log_warning "UPack CLI version check failed"
    else
        log_warning "UPack CLI not found in PATH"
    fi
    
    # Test Alacritty configs
    log_info "Testing Alacritty configurations..."
    if command -v alacritty &> /dev/null; then
        alacritty --config-file "$HOME/.config/alacritty/shared.toml" --print-events --exit-after 1 2>/dev/null || {
            log_error "Alacritty shared.toml configuration error"
            log_info "Checking Alacritty config files..."
            
            for config in "$HOME/.config/alacritty/"*.toml; do
                if [ -f "$config" ]; then
                    echo "Testing: $(basename "$config")"
                    if ! alacritty --config-file "$config" --print-events --exit-after 1 2>/dev/null; then
                        log_error "Config error in: $(basename "$config")"
                    fi
                fi
            done
        }
    else
        log_warning "Alacritty not installed"
    fi
    
    log_success "Component testing completed"
}

run_dev_menu() {
    while true; do
        echo ""
        echo -e "${BLUE}${BOLD}Development Menu:${NC}"
        echo ""
        echo "1. 🔧 Install/Update UPack in development mode"
        echo "2. 🧪 Test individual components"
        echo "3. 📊 Run system diagnostics"
        echo "4. 🚀 Run setup script"
        echo "5. 🔍 Check configuration files"
        echo "6. 📁 Open install directory"
        echo "7. 🔄 Reload UPack CLI"
        echo "8. ❌ Exit"
        echo ""
        read -p "Choose an option (1-8): " choice
        
        case $choice in
            1)
                copy_to_install_dir
                cd "$UPACK_DIR"
                ./install/apps/required/upack-app.sh
                ;;
            2)
                test_components
                ;;
            3)
                export PATH="$HOME/.local/bin:$PATH"
                if command -v upack &> /dev/null; then
                    upack doctor
                else
                    log_error "UPack CLI not available"
                fi
                ;;
            4)
                copy_to_install_dir
                cd "$UPACK_DIR"
                ./setup.sh
                ;;
            5)
                log_info "Checking configuration files..."
                find "$HOME/.config/alacritty" -name "*.toml" 2>/dev/null | while read -r config; do
                    echo "📁 $(basename "$config")"
                    if alacritty --config-file "$config" --print-events --exit-after 1 2>/dev/null; then
                        echo "  ✅ Valid"
                    else
                        echo "  ❌ Invalid"
                    fi
                done
                ;;
            6)
                log_info "Opening install directory: $UPACK_DIR"
                if command -v code &> /dev/null; then
                    code "$UPACK_DIR"
                elif command -v nautilus &> /dev/null; then
                    nautilus "$UPACK_DIR" &
                else
                    ls -la "$UPACK_DIR"
                fi
                ;;
            7)
                copy_to_install_dir
                cd "$UPACK_DIR"
                ./install/apps/required/upack-app.sh
                export PATH="$HOME/.local/bin:$PATH"
                source ~/.bashrc 2>/dev/null || true
                log_success "UPack CLI reloaded"
                ;;
            8)
                log_info "Exiting development mode"
                exit 0
                ;;
            *)
                log_error "Invalid option"
                ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

main() {
    show_banner
    check_dependencies
    run_dev_menu
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
ensure_gum

# Confirm reinstall if folder exists
if [[ -d "$INSTALL_DIR" && -n "$(ls -A "$INSTALL_DIR")" ]]; then
  echo ""
  if ! gum confirm "⚠️ The directory $INSTALL_DIR already exists. Do you want to overwrite it?"; then
    echo "❌ Aborted by user."
    exit 1
  fi
  echo "🧹 Cleaning $INSTALL_DIR..." 
  rm -rf "$INSTALL_DIR"
fi

echo "📁 Copying local files to $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
rsync -a --exclude='.git' ./ "$INSTALL_DIR"
cat "$INSTALL_DIR/assets/banner.txt" || true
echo "🚀 Starting Upack (DEV)"
bash "$INSTALL_DIR/core/menu.sh"

# Configure GNOME settings
configure_gnome_settings "$INSTALL_DIR"

# Install theme (optional)
install_theme "$INSTALL_DIR"

# Install GNOME extensions (optional)
install_gnome_extensions "$INSTALL_DIR"

# Handle reboot prompt
handle_reboot_prompt
