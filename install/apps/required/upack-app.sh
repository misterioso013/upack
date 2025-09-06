#!/bin/bash

# Install UPack Desktop Application
# Creates a desktop application similar to Omakub

# Source gum utilities if available
UPACK_DIR="${UPACK_DIR:-$HOME/.local/share/upack}"
source "$UPACK_DIR/utils/gum.sh" 2>/dev/null || true

# Color definitions for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Define log functions
if ! command -v log_step &> /dev/null; then
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
    log_warning() { echo "⚠️  $1"; }
fi

install_upack_app() {
    log_step "Installing UPack Desktop Application"
    
    # Create directories
    create_directories
    
    # Copy UPack binaries
    install_binaries
    
    # Install Alacritty configurations
    install_alacritty_configs
    
    # Create desktop entries
    create_desktop_entries
    
    # Install icon
    install_icon
    
    # Make binaries executable and add to PATH
    setup_path
    
    # Configure GNOME dock with essential apps
    configure_dock
    
    log_success "UPack Desktop Application installed!"
    show_usage_info
}

create_directories() {
    log_info "Creating UPack directories..."
    
    mkdir -p "$HOME/.local/share/upack"/{apps,backups,logs,icons}
    mkdir -p "$HOME/.config/upack"
    mkdir -p "$HOME/.cache/upack"
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share/applications"
    mkdir -p "$HOME/.config/alacritty"
}

install_binaries() {
    log_info "Installing UPack CLI tools..."
    
    # Get the UPack repository directory
    local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local UPACK_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
    
    # Copy UPack binaries to local bin
    if [[ -f "$UPACK_DIR/bin/upack" ]]; then
        cp "$UPACK_DIR/bin/upack" "$HOME/.local/bin/"
        chmod +x "$HOME/.local/bin/upack"
        log_success "upack CLI copied"
    else
        log_error "upack binary not found at $UPACK_DIR/bin/upack"
        return 1
    fi
    
    if [[ -f "$UPACK_DIR/bin/upack-tui" ]]; then
        cp "$UPACK_DIR/bin/upack-tui" "$HOME/.local/bin/"
        chmod +x "$HOME/.local/bin/upack-tui"
        log_success "upack-tui CLI copied"
    else
        log_error "upack-tui binary not found at $UPACK_DIR/bin/upack-tui"
        return 1
    fi
}

install_alacritty_configs() {
    log_info "Installing Alacritty configurations..."
    
    # Get the UPack repository directory
    local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local UPACK_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
    
    # Ensure target directory exists
    if ! mkdir -p "$HOME/.config/alacritty"; then
        log_error "Failed to create Alacritty config directory"
        return 1
    fi
    
    # Copy Alacritty config files
    if [[ -d "$UPACK_DIR/config/alacritty" ]]; then
        if ! cp -r "$UPACK_DIR/config/alacritty"/* "$HOME/.config/alacritty/"; then
            log_error "Failed to copy Alacritty config files from $UPACK_DIR/config/alacritty"
            return 1
        fi
    else
        log_error "Alacritty config directory not found at $UPACK_DIR/config/alacritty"
        return 1
    fi
    
    # Update paths in config files to use absolute paths
    if ! sed -i "s|~/.config/alacritty/|$HOME/.config/alacritty/|g" "$HOME/.config/alacritty/pane.toml"; then
        log_error "Failed to update paths in pane.toml"
        return 1
    fi
    
    if ! sed -i "s|~/.config/alacritty/|$HOME/.config/alacritty/|g" "$HOME/.config/alacritty/btop.toml"; then
        log_error "Failed to update paths in btop.toml"
        return 1
    fi
    
    log_success "Alacritty configurations installed successfully"
}

install_icon() {
    log_info "Installing UPack icon..."
    
    # Use existing UPack icon or create a simple one
    if [ -f "assets/icons/upack.png" ]; then
        cp "assets/icons/upack.png" "$HOME/.local/share/upack/icons/"
    else
        # Create a simple icon using imagemagick if available
        if command -v convert &> /dev/null; then
            convert -size 128x128 xc:'#88c0d0' \
                    -fill '#2e3440' -font DejaVu-Sans-Bold -pointsize 48 \
                    -gravity center -annotate +0+0 'UP' \
                    "$HOME/.local/share/upack/icons/upack.png"
        else
            # Fallback: copy a generic icon
            cp /usr/share/pixmaps/application-default-icon.png "$HOME/.local/share/upack/icons/upack.png" 2>/dev/null || true
        fi
    fi
}

create_desktop_entries() {
    log_info "Creating desktop entries..."
    
    # Main UPack Manager desktop entry
    cat > "$HOME/.local/share/applications/UPack.desktop" << EOF
[Desktop Entry]
Version=1.0
Name=UPack Manager
Comment=UPack System Manager
Exec=alacritty --config-file $HOME/.config/alacritty/pane.toml --class=UPack --title="UPack Manager" -e upack-tui
Terminal=false
Type=Application
Icon=$HOME/.local/share/upack/icons/upack.png
Categories=System;Settings;
StartupNotify=false
Keywords=upack;system;manager;ubuntu;productivity;
EOF

    # System Monitor desktop entry (if btop is available)
    cat > "$HOME/.local/share/applications/UPack-Monitor.desktop" << EOF
[Desktop Entry]
Version=1.0
Name=UPack Monitor
Comment=System Monitor with UPack styling
Exec=alacritty --config-file $HOME/.config/alacritty/btop.toml --class=UPack-Monitor --title="System Monitor" -e btop
Terminal=false
Type=Application
Icon=utilities-system-monitor
Categories=System;Monitor;
StartupNotify=false
Keywords=btop;htop;system;monitor;performance;
EOF

    # UPack Terminal desktop entry
    cat > "$HOME/.local/share/applications/UPack-Terminal.desktop" << EOF
[Desktop Entry]
Version=1.0
Name=UPack Terminal
Comment=Terminal with UPack configuration
Exec=alacritty --config-file $HOME/.config/alacritty/pane.toml --class=UPack-Terminal --title="UPack Terminal"
Terminal=false
Type=Application
Icon=utilities-terminal
Categories=System;TerminalEmulator;
StartupNotify=false
Keywords=terminal;console;shell;
EOF

    # Update desktop database
    if command -v update-desktop-database &> /dev/null; then
        update-desktop-database "$HOME/.local/share/applications"
    fi
}

setup_path() {
    log_info "Setting up PATH..."
    
    # Check if ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        log_info "Adding ~/.local/bin to PATH..."
        
        # Add to .bashrc if it exists
        if [ -f "$HOME/.bashrc" ]; then
            echo "" >> "$HOME/.bashrc"
            echo "# UPack: Add ~/.local/bin to PATH" >> "$HOME/.bashrc"
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        fi
        
        # Add to .zshrc if it exists
        if [ -f "$HOME/.zshrc" ]; then
            echo "" >> "$HOME/.zshrc"
            echo "# UPack: Add ~/.local/bin to PATH" >> "$HOME/.zshrc"
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
        fi
        
        # Add to current session
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    log_success "UPack CLI tools are now available in PATH"
}

configure_dock() {
    log_info "Configuring dock with essential apps..."
    
    # Get the script directory to find relative paths
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local repo_root="$(cd "$script_dir/../../.." && pwd)"
    
    # Run dock configuration script
    bash "$repo_root/config/gnome/dock-config.sh" || {
        log_warning "Could not configure dock automatically"
        log_info "You can configure it later with: bash \"$repo_root/config/gnome/dock-config.sh\""
    }
}

show_usage_info() {
    echo ""
    echo -e "🎉 ${GREEN}UPack Desktop Application installed successfully!${NC}"
    echo ""
    echo -e "${BLUE}${BOLD}How to use:${NC}"
    echo "  📱 ${CYAN}GUI${NC}: Search for 'UPack Manager' in activities or run 'upack gui'"
    echo "  💻 ${CYAN}CLI${NC}: Use 'upack' command in terminal"
    echo "  🖥️  ${CYAN}Monitor${NC}: Use 'upack monitor' or search for 'UPack Monitor'"
    echo ""
    echo -e "${BLUE}${BOLD}Examples:${NC}"
    echo "  ${WHITE}upack install discord vscode${NC}  # Install applications"
    echo "  ${WHITE}upack update${NC}                  # Update system"
    echo "  ${WHITE}upack status${NC}                  # Show system status"
    echo "  ${WHITE}upack gui${NC}                     # Open GUI interface"
    echo ""
    echo -e "${YELLOW}Note: Restart your terminal or run 'source ~/.bashrc' to use CLI commands${NC}"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_upack_app
fi
