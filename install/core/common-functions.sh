#!/bin/bash

# UPack Core - Common Functions
# Shared functions for all installation scripts

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Show banner
show_banner() {
    echo -e "${BLUE}${BOLD}"
    cat << 'EOF'
██╗   ██╗██████╗  █████╗  ██████╗██╗  ██╗
██║   ██║██╔══██╗██╔══██╗██╔════╝██║ ██╔╝
██║   ██║██████╔╝███████║██║     █████╔╝ 
██║   ██║██╔═══╝ ██╔══██║██║     ██╔═██╗ 
╚██████╔╝██║     ██║  ██║╚██████╗██║  ██╗
 ╚═════╝ ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
EOF
    echo -e "${NC}"
    echo -e "${CYAN}${BOLD}Ubuntu Productivity Pack - Automatic Setup${NC}"
    echo -e "${WHITE}Transforming your Ubuntu into a productive system...${NC}"
    echo ""
}

# Show step with timestamp
show_step() {
    echo -e "${BLUE}${BOLD}[$(date +'%H:%M:%S')] $1${NC}"
}

# Show success message
show_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Show error message
show_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Show info message
show_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if app is installed
is_installed() {
    command -v "$1" &>/dev/null
}

# Check if package is installed via apt
is_apt_installed() {
    dpkg -l "$1" &>/dev/null 2>&1
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        show_error "This script should not be run as root"
        show_info "Please run as a regular user. You'll be prompted for sudo when needed."
        exit 1
    fi
}

# Check if Ubuntu
check_ubuntu() {
    if ! grep -q "Ubuntu" /etc/os-release; then
        show_error "This script is designed for Ubuntu systems"
        exit 1
    fi
}

# Check internet connection
check_internet() {
    if ! ping -c 1 google.com >/dev/null 2>&1; then
        show_error "No internet connection detected"
        show_info "Please check your network connection and try again"
        exit 1
    fi
}

# Execute with error handling
execute_step() {
    local script_path="$1"
    local step_name="$2"
    
    if [[ -f "$script_path" ]]; then
        if bash "$script_path"; then
            show_success "$step_name completed"
            return 0
        else
            show_error "$step_name failed"
            return 1
        fi
    else
        show_error "Script not found: $script_path"
        return 1
    fi
}

# Simple log functions (backward compatibility)
log_step() { echo "🔄 $1"; }
log_info() { echo "ℹ️  $1"; }
log_success() { echo "✅ $1"; }
log_error() { echo "❌ $1"; }
log_warning() { echo "⚠️  $1"; }
