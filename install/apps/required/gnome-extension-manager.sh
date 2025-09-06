#!/bin/bash

# Install GNOME Extensions Manager
# For managing GNOME shell extensions through a GUI

source "$(dirname "$0")/../../utils/gum.sh"

install_gnome_extension_manager() {
    log_step "Installing GNOME Extensions Manager"
    
    # Check if already installed
    if command -v gnome-extensions-app &> /dev/null; then
        log_success "GNOME Extensions Manager is already installed"
        return 0
    fi
    
    # Install via APT (available in Ubuntu 22.04+)
    if sudo apt update && sudo apt install -y gnome-shell-extension-manager; then
        log_success "GNOME Extensions Manager installed via APT"
    else
        # Fallback: install via Flatpak
        log_info "Installing GNOME Extensions Manager via Flatpak"
        if ! command -v flatpak &> /dev/null; then
            log_info "Installing Flatpak first"
            sudo apt install -y flatpak gnome-software-plugin-flatpak
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        fi
        
        if flatpak install -y flathub com.mattjakeman.ExtensionManager; then
            log_success "GNOME Extensions Manager installed via Flatpak"
        else
            log_error "Failed to install GNOME Extensions Manager"
            return 1
        fi
    fi
    
    log_success "GNOME Extensions Manager installation completed"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_gnome_extension_manager
fi
