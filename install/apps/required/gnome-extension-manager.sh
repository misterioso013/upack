#!/bin/bash

# Install GNOME Extensions Manager
# For managing GNOME shell extensions through a GUI

#!/bin/bash

# Install GNOME Extensions Manager
# For managing GNOME shell extensions through a GUI

# Simple log functions (no external dependencies)
log_step() { echo "🔄 $1"; }
log_info() { echo "ℹ️  $1"; }
log_success() { echo "✅ $1"; }
log_error() { echo "❌ $1"; }
log_warning() { echo "⚠️  $1"; }

install_gnome_extension_manager() {
    log_step "Installing GNOME Extensions Manager"
    
    # Check if already installed - look for the actual Extension Manager
    if command -v extension-manager &> /dev/null; then
        log_success "GNOME Extension Manager is already installed"
        return 0
    fi
    
    # Check for Flatpak installation
    if command -v flatpak &> /dev/null; then
        if flatpak list | grep -q "io.github.btelman.ExtensionManager" 2>/dev/null; then
            log_success "GNOME Extension Manager is already installed via Flatpak"
            return 0
        fi
    fi
    
    # Install via APT (available in Ubuntu 22.04+)
    if sudo apt update && sudo apt install -y gnome-shell-extension-manager; then
        log_success "GNOME Extension Manager installed via APT"
    else
        # Fallback: install via Flatpak
        log_info "Installing GNOME Extension Manager via Flatpak"
        if ! command -v flatpak &> /dev/null; then
            log_info "Installing Flatpak first"
            DEBIAN_FRONTEND=noninteractive sudo apt-get install -y flatpak gnome-software-plugin-flatpak
        fi
        
        # Ensure Flathub remote is configured
        if command -v flatpak &> /dev/null; then
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            
            if flatpak install -y flathub com.mattjakeman.ExtensionManager; then
                log_success "GNOME Extension Manager installed via Flatpak"
            else
                log_error "Failed to install GNOME Extension Manager"
                return 1
            fi
        else
            log_error "Flatpak installation failed"
            return 1
        fi
    fi
    
    log_success "GNOME Extensions Manager installation completed"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_gnome_extension_manager
fi
