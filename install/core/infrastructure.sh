#!/bin/bash

# UPack Core - Infrastructure Setup
# Sets up permanent UPack installation structure

set -e

UPACK_HOME="$HOME/.local/share/upack"
UPACK_BIN="$HOME/.local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPACK_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_step() { echo -e "${BLUE}🔄 $1${NC}"; }
log_info() { echo -e "ℹ️  $1"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

create_permanent_structure() {
    log_step "Creating permanent UPack infrastructure..."
    
    # Create main directories
    mkdir -p "$UPACK_HOME"/{assets/{icons,fonts},config,bin,logs}
    mkdir -p "$UPACK_BIN"
    mkdir -p "$HOME/.local/share/applications"
    
    log_info "Created directory structure at $UPACK_HOME"
}

install_assets_permanently() {
    log_step "Installing assets to permanent location..."
    
    # Copy icons to permanent location
    if [ -d "$UPACK_ROOT/assets/icons" ]; then
        cp -r "$UPACK_ROOT/assets/icons"/* "$UPACK_HOME/assets/icons/" 2>/dev/null || true
        log_info "Icons installed to $UPACK_HOME/assets/icons/"
    fi
    
    # Copy fonts to permanent location
    if [ -d "$UPACK_ROOT/assets/fonts" ]; then
        cp -r "$UPACK_ROOT/assets/fonts"/* "$UPACK_HOME/assets/fonts/" 2>/dev/null || true
        log_info "Fonts copied to $UPACK_HOME/assets/fonts/"
    fi
    
    # Copy wallpapers and other assets
    if [ -d "$UPACK_ROOT/assets" ]; then
        find "$UPACK_ROOT/assets" -maxdepth 1 -type f -exec cp {} "$UPACK_HOME/assets/" \;
        log_info "Asset files copied to permanent location"
    fi
}

install_scripts_permanently() {
    log_step "Installing UPack scripts to permanent location..."
    
    # Copy core utilities
    cp -r "$UPACK_ROOT/config" "$UPACK_HOME/" 2>/dev/null || true
    cp -r "$UPACK_ROOT/utils" "$UPACK_HOME/" 2>/dev/null || true
    cp -r "$UPACK_ROOT/install" "$UPACK_HOME/" 2>/dev/null || true
    
    # Copy executables to bin (only if different)
    if [ -f "$UPACK_ROOT/bin/upack" ]; then
        # Remove existing symlink/file if different
        if [ -L "$UPACK_BIN/upack" ] || [ ! -f "$UPACK_BIN/upack" ]; then
            rm -f "$UPACK_BIN/upack" 2>/dev/null || true
        fi
        cp "$UPACK_ROOT/bin/upack" "$UPACK_BIN/"
        chmod +x "$UPACK_BIN/upack"
        log_info "UPack CLI installed to $UPACK_BIN/upack"
    fi
    
    if [ -f "$UPACK_ROOT/bin/upack-tui" ]; then
        if [ -L "$UPACK_BIN/upack-tui" ] || [ ! -f "$UPACK_BIN/upack-tui" ]; then
            rm -f "$UPACK_BIN/upack-tui" 2>/dev/null || true
        fi
        cp "$UPACK_ROOT/bin/upack-tui" "$UPACK_BIN/"
        chmod +x "$UPACK_BIN/upack-tui"
        log_info "UPack TUI installed to $UPACK_BIN/upack-tui"
    fi
    
    log_success "Scripts installed to permanent location"
}

create_environment_config() {
    log_step "Creating environment configuration..."
    
    # Create environment file
    cat > "$UPACK_HOME/environment" << 'EOF'
# UPack Environment Configuration
# This file is sourced by UPack scripts

export UPACK_ROOT="$HOME/.local/share/upack"
export UPACK_BIN="$HOME/.local/bin"
export UPACK_ASSETS="$UPACK_ROOT/assets"
export UPACK_CONFIG="$UPACK_ROOT/config"
export UPACK_LOGS="$UPACK_ROOT/logs"

# Add UPack bin to PATH if not already there
if [[ ":$PATH:" != *":$UPACK_BIN:"* ]]; then
    export PATH="$UPACK_BIN:$PATH"
fi
EOF
    
    log_info "Environment configuration created at $UPACK_HOME/environment"
}

fix_existing_desktop_entries() {
    log_step "Fixing existing desktop entries with permanent paths..."
    
    # Fix SendAny desktop entry
    local SENDANY_DESKTOP="$HOME/.local/share/applications/sendany.desktop"
    if [ -f "$SENDANY_DESKTOP" ]; then
        sed -i "s|Icon=.*|Icon=$UPACK_HOME/assets/icons/sendany.png|" "$SENDANY_DESKTOP"
        log_info "Fixed SendAny icon path"
    fi
    
    # Fix UPack Manager desktop entry
    local UPACK_DESKTOP="$HOME/.local/share/applications/upack-manager.desktop"
    if [ -f "$UPACK_DESKTOP" ]; then
        sed -i "s|Icon=.*|Icon=$UPACK_HOME/assets/icons/upack.png|" "$UPACK_DESKTOP"
        sed -i "s|Exec=.*|Exec=$UPACK_BIN/upack status|" "$UPACK_DESKTOP"
        log_info "Fixed UPack Manager paths"
    fi
    
    # Update desktop database
    if command -v update-desktop-database &>/dev/null; then
        update-desktop-database "$HOME/.local/share/applications/" 2>/dev/null || true
    fi
}

create_uninstaller() {
    log_step "Creating uninstaller script..."
    
    cat > "$UPACK_BIN/upack-uninstall" << 'EOF'
#!/bin/bash

# UPack Uninstaller
# Removes all UPack components from the system

echo "🗑️  UPack Uninstaller"
echo "This will remove all UPack components from your system."
echo ""
read -p "Are you sure you want to continue? (y/N): " confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

echo "Removing UPack components..."

# Remove desktop entries
rm -f "$HOME/.local/share/applications/upack-manager.desktop"
rm -f "$HOME/.local/share/applications/sendany.desktop"

# Remove binaries
rm -f "$HOME/.local/bin/upack"*

# Remove data directory
rm -rf "$HOME/.local/share/upack"

# Remove from dock favorites (if present)
current_favorites=$(gsettings get org.gnome.shell favorite-apps 2>/dev/null || echo "[]")
new_favorites=$(echo "$current_favorites" | sed "s/'sendany.desktop'[, ]*//g" | sed "s/'upack-manager.desktop'[, ]*//g" | sed 's/\[, */[/g' | sed 's/, *\]/]/g')
gsettings set org.gnome.shell favorite-apps "$new_favorites" 2>/dev/null || true

echo "✅ UPack has been completely removed from your system."
echo "Thank you for using UPack!"
EOF

    chmod +x "$UPACK_BIN/upack-uninstall"
    log_info "Uninstaller created at $UPACK_BIN/upack-uninstall"
}

main() {
    echo "🚀 UPack Infrastructure Setup"
    echo "Setting up permanent installation structure..."
    echo ""
    
    create_permanent_structure
    install_assets_permanently
    install_scripts_permanently
    create_environment_config
    fix_existing_desktop_entries
    create_uninstaller
    
    echo ""
    log_success "UPack infrastructure setup completed!"
    echo ""
    echo "📋 What was installed:"
    echo "  • Permanent data directory: $UPACK_HOME"
    echo "  • Scripts and binaries: $UPACK_BIN"
    echo "  • Assets and icons: $UPACK_HOME/assets"
    echo "  • Configuration files: $UPACK_HOME/config"
    echo "  • Uninstaller: $UPACK_BIN/upack-uninstall"
    echo ""
    echo "🎯 Benefits:"
    echo "  • UPack works even if original folder is deleted"
    echo "  • All apps have proper icon paths"
    echo "  • Global access to upack command"
    echo "  • Clean uninstall capability"
    echo ""
}

main "$@"
