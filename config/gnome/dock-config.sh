#!/bin/bash

# Configure GNOME Dock with Essential UPack Apps
# Sets up favorite applications in dock

UPACK_DIR="${UPACK_DIR:-$HOME/.local/share/upack}"
source "$UPACK_DIR/utils/gum.sh" 2>/dev/null || {
    # Fallback log functions if gum.sh not available
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
    log_warning() { echo "⚠️  $1"; }
}

configure_dock_favorites() {
    log_step "Configuring GNOME Dock with essential apps"
    
    # Essential UPack applications for dock
    local ESSENTIAL_APPS=(
        "org.gnome.Nautilus.desktop"              # Files
        "google-chrome.desktop"                   # Chrome  
        "code.desktop"                           # VS Code
        "UPack.desktop"                          # UPack Manager
        "sendany.desktop"                        # SendAny
        "org.gnome.Terminal.desktop"             # Terminal
    )
    
    # Build favorites array
    local favorites_list=""
    for app in "${ESSENTIAL_APPS[@]}"; do
        if [ -f "/usr/share/applications/$app" ] || [ -f "$HOME/.local/share/applications/$app" ]; then
            if [ -n "$favorites_list" ]; then
                favorites_list="$favorites_list, '$app'"
            else
                favorites_list="'$app'"
            fi
            log_info "Added $app to dock favorites"
        else
            log_warning "$app not found, skipping"
        fi
    done
    
    # Apply dock configuration
    if [ -n "$favorites_list" ]; then
        log_info "Setting dock favorites..."
        gsettings set org.gnome.shell favorite-apps "[$favorites_list]"
        
        # Configure dock appearance
        configure_dock_appearance
        
        log_success "Dock configured with essential UPack apps"
        show_dock_info
    else
        log_error "No applications found to add to dock"
    fi
}

configure_dock_appearance() {
    log_info "Configuring dock appearance..."
    
    # Helper function to safely set gsettings key
    safe_gsettings_set() {
        local schema="$1"
        local key="$2"
        local value="$3"
        
        if gsettings list-keys "$schema" 2>/dev/null | grep -qx "$key"; then
            gsettings set "$schema" "$key" "$value"
        else
            log_info "Skipping missing key: $schema.$key"
        fi
    }
    
    # Ubuntu Dock settings (if available)
    if gsettings list-schemas | grep -q "org.gnome.shell.extensions.dash-to-dock"; then
        local schema="org.gnome.shell.extensions.dash-to-dock"
        # Dash-to-Dock settings with key checking
        safe_gsettings_set "$schema" "dock-position" "BOTTOM"
        safe_gsettings_set "$schema" "extend-height" "false"
        safe_gsettings_set "$schema" "dock-fixed" "false"
        safe_gsettings_set "$schema" "intellihide" "true"
        safe_gsettings_set "$schema" "intellihide-mode" "'FOCUS_APPLICATION_WINDOWS'"
        safe_gsettings_set "$schema" "show-apps-at-top" "true"
        safe_gsettings_set "$schema" "show-trash" "false"
        safe_gsettings_set "$schema" "show-mounts" "false"
        
        log_success "Dash-to-Dock appearance configured"
    elif gsettings list-schemas | grep -q "org.gnome.shell.extensions.ubuntu-dock"; then
        local schema="org.gnome.shell.extensions.ubuntu-dock"
        # Ubuntu Dock settings with key checking
        safe_gsettings_set "$schema" "dock-position" "BOTTOM"
        safe_gsettings_set "$schema" "extend-height" "false"
        safe_gsettings_set "$schema" "intellihide" "true"
        safe_gsettings_set "$schema" "intellihide-mode" "'FOCUS_APPLICATION_WINDOWS'"
        safe_gsettings_set "$schema" "show-trash" "false"
        
        log_success "Ubuntu Dock appearance configured"
    else
        log_warning "No dock extension found, using default GNOME settings"
    fi
}

show_dock_info() {
    echo ""
    log_info "Dock Configuration Summary:"
    echo "  📱 Apps in dock (left to right):"
    echo "     1. 📁 Files (Nautilus)"
    echo "     2. 🌐 Google Chrome"  
    echo "     3. 💻 VS Code"
    echo "     4. 🚀 UPack Manager"
    echo "     5. 📤 SendAny"
    echo "     6. 💻 Terminal"
    echo ""
    echo "  ⌨️  Quick access with Alt+1, Alt+2, Alt+3, etc."
    echo "  🎨 Dock configured for productivity workflow"
    echo ""
}

check_required_apps() {
    log_info "Checking if required apps are installed..."
    
    local missing_apps=()
    
    # Check for desktop files
    if [ ! -f "/usr/share/applications/google-chrome.desktop" ] && [ ! -f "$HOME/.local/share/applications/google-chrome.desktop" ]; then
        missing_apps+=("google-chrome")
    fi
    
    if [ ! -f "/usr/share/applications/code.desktop" ] && [ ! -f "$HOME/.local/share/applications/code.desktop" ]; then
        missing_apps+=("code")
    fi
    
    if [ ! -f "/usr/share/applications/UPack.desktop" ] && [ ! -f "/usr/local/share/applications/UPack.desktop" ] && [ ! -f "$HOME/.local/share/applications/UPack.desktop" ]; then
        missing_apps+=("upack-manager")
    fi
    
    if [ ! -f "/usr/share/applications/sendany.desktop" ] && [ ! -f "$HOME/.local/share/applications/sendany.desktop" ]; then
        missing_apps+=("sendany")
    fi
    
    if [ ${#missing_apps[@]} -gt 0 ]; then
        log_warning "Some required apps are missing: ${missing_apps[*]}"
        log_info "Install them first with: upack install ${missing_apps[*]}"
        return 1
    fi
    
    log_success "All required apps are installed"
    return 0
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if check_required_apps; then
        configure_dock_favorites
    else
        log_error "Cannot configure dock without required applications"
        exit 1
    fi
fi
