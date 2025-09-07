#!/bin/bash

# UPack Apps - Permanent Desktop Applications
# Creates desktop applications that use permanent infrastructure

set -e

UPACK_HOME="$HOME/.local/share/upack"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPACK_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_step() { echo -e "${BLUE}🔄 $1${NC}"; }
log_info() { echo -e "ℹ️  $1"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }

install_upack_manager_app() {
    log_step "Installing UPack Manager desktop app..."
    
    # Create the desktop entry using permanent paths
    cat > "$HOME/.local/share/applications/upack-manager.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=UPack Manager
Comment=Ubuntu Productivity Pack Manager - System Setup and Management
Exec=$HOME/.local/bin/upack status
Icon=$UPACK_HOME/assets/icons/upack.png
Terminal=true
Categories=System;Settings;PackageManager;
Keywords=upack;ubuntu;productivity;manager;setup;install;
StartupNotify=true
NoDisplay=false
StartupWMClass=UPack Manager
EOF

    chmod +x "$HOME/.local/share/applications/upack-manager.desktop"
    log_success "UPack Manager app installed"
}

install_sendany_app() {
    log_step "Installing SendAny PWA with permanent paths..."
    
    # Check if Chrome is available
    if ! command -v google-chrome &>/dev/null; then
        log_info "Google Chrome not found - SendAny will be installed when Chrome is available"
        return 0
    fi
    
    # Create the desktop entry using permanent paths
    cat > "$HOME/.local/share/applications/sendany.desktop" << EOF
[Desktop Entry]
Version=1.0
Name=SendAny
Comment=Share anything with anyone - Quick file sharing service
Exec=google-chrome --app="https://sendany.all.dev.br" --name=SendAny --class=SendAny --new-window
Icon=$UPACK_HOME/assets/icons/sendany.png
Terminal=false
Type=Application
Categories=Network;FileTransfer;Utility;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupNotify=true
NoDisplay=false
StartupWMClass=SendAny
Keywords=sendany;share;file;transfer;cloud;
EOF

    chmod +x "$HOME/.local/share/applications/sendany.desktop"
    log_success "SendAny app installed with permanent icon path"
}

update_dock_favorites() {
    log_step "Adding UPack apps to dock favorites..."
    
    # Get current favorites and clean format
    current_favorites=$(gsettings get org.gnome.shell favorite-apps 2>/dev/null || echo "[]")
    
    # Apps to ensure are in dock
    declare -a new_apps=(
        "upack-manager.desktop"
        "sendany.desktop"
    )
    
    # Check and add each new app
    for app in "${new_apps[@]}"; do
        # Check if app exists
        if [ -f "$HOME/.local/share/applications/$app" ]; then
            # Check if app is already in favorites
            if [[ "$current_favorites" != *"$app"* ]]; then
                # Add to favorites
                if [ "$current_favorites" = "[]" ]; then
                    # First app
                    gsettings set org.gnome.shell favorite-apps "['$app']"
                else
                    # Append to existing list
                    new_favorites=$(echo "$current_favorites" | sed "s/]/,'$app']/")
                    gsettings set org.gnome.shell favorite-apps "$new_favorites"
                fi
                log_info "Added $app to dock"
            else
                log_info "$app already in dock"
            fi
        else
            log_info "$app not found, skipping"
        fi
    done
    
    log_success "Dock updated with UPack apps"
}

main() {
    log_step "Installing UPack desktop applications..."
    echo ""
    
    install_upack_manager_app
    install_sendany_app
    update_dock_favorites
    
    # Update desktop database
    if command -v update-desktop-database &>/dev/null; then
        update-desktop-database "$HOME/.local/share/applications/" 2>/dev/null || true
        log_info "Desktop database updated"
    fi
    
    echo ""
    log_success "UPack desktop applications installed!"
    echo ""
    echo "📱 Installed applications:"
    echo "  • UPack Manager - System management interface"
    echo "  • SendAny - Quick file sharing service"
    echo ""
    echo "🎯 Applications are now available in:"
    echo "  • Applications menu (search for 'UPack' or 'SendAny')"
    echo "  • Dock favorites (pinned automatically)"
    echo "  • Command line: upack status"
    echo ""
}

main "$@"
