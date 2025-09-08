#!/bin/bash

# UPack Core - Complete Theme Setup
# Installs and configures WhiteSur theme with all customizations

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPACK_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Import common functions
source "$SCRIPT_DIR/common-functions.sh"

# Create a secure temporary directory
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

install_whitesur_theme() {
    show_step "Installing WhiteSur GTK Theme"
    
    cd "$TEMP_DIR"
    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1 -q
    
    cd WhiteSur-gtk-theme
    echo "🔧 Installing theme components..."
    ./install.sh -c dark -s nord -m -l &>/dev/null
    
    echo "✅ WhiteSur theme installed"
}

install_icon_theme() {
    show_step "Installing Nordzy icon theme"
    
    cd "$TEMP_DIR"
    git clone https://github.com/MolassesLover/Nordzy-icon.git --depth=1 -q
    cd Nordzy-icon
    ./install.sh -t default -c -p &>/dev/null
    
    echo "✅ Nordzy icons installed"
}

install_cursor_theme() {
    show_step "Installing Sunity cursor theme"
    
    cd "$TEMP_DIR"
    git clone https://github.com/alvatip/Sunity-cursors --depth=1 -q
    cd Sunity-cursors
    sudo ./install.sh &>/dev/null
    
    echo "✅ Sunity cursors installed"
}

apply_theme_tweaks() {
    show_step "Applying theme customizations"
    
    cd "$TEMP_DIR/WhiteSur-gtk-theme"
    
    # Firefox theme
    ./tweaks.sh -f monterey &>/dev/null || echo "ℹ️  Firefox theme skipped"
    
    # Dash-to-Dock theme
    ./tweaks.sh -d &>/dev/null || echo "ℹ️  Dash-to-Dock theme skipped"
    
    # Flatpak fixes
    if command -v flatpak &>/dev/null; then
        sudo flatpak override --filesystem=xdg-config/gtk-3.0 2>/dev/null || true
        sudo flatpak override --filesystem=xdg-config/gtk-4.0 2>/dev/null || true
        ./tweaks.sh -F &>/dev/null || echo "ℹ️  Flatpak theme fix skipped"
    fi
    
    # GDM theme with custom background
    local bg_path="$UPACK_ROOT/assets/dark-background.png"
    if [ -f "$bg_path" ]; then
        echo "🖼️  Setting up GDM background..."
        sudo ./tweaks.sh -g -b "$bg_path" &>/dev/null || echo "ℹ️  GDM background setup skipped"
    fi
    
    echo "✅ Theme tweaks applied"
}

configure_gsettings() {
    show_step "Configuring desktop appearance"
    
    # Check if we're in a GNOME session
    if [[ "${XDG_CURRENT_DESKTOP:-}" == *"GNOME"* ]] || [[ -n "${GNOME_DESKTOP_SESSION_ID:-}" ]]; then
        
        # Enable dark mode
        gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Dark-nord' 2>/dev/null || true
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
        
        # Set icon theme
        gsettings set org.gnome.desktop.interface icon-theme 'Nordzy-dark' 2>/dev/null || true
        
        # Set cursor theme
        gsettings set org.gnome.desktop.interface cursor-theme 'Sunity-cursors' 2>/dev/null || true
        gsettings set org.gnome.desktop.interface cursor-size 24 2>/dev/null || true
        
        # Set window manager theme (shell theme)
        gsettings set org.gnome.shell.extensions.user-theme name 'WhiteSur-Dark-nord' 2>/dev/null || true
        
        # Set wallpaper
        local wallpaper_path="$UPACK_ROOT/assets/ubuntu-neo-wallpaper.jpg"
        if [ -f "$wallpaper_path" ]; then
            gsettings set org.gnome.desktop.background picture-uri "file://$wallpaper_path" 2>/dev/null || true
            gsettings set org.gnome.desktop.background picture-uri-dark "file://$wallpaper_path" 2>/dev/null || true
            gsettings set org.gnome.desktop.background picture-options 'zoom' 2>/dev/null || true
            echo "🖼️  Wallpaper set to ubuntu-neo-wallpaper.jpg"
        fi
        
        # Additional appearance tweaks
        gsettings set org.gnome.desktop.interface clock-show-weekday true 2>/dev/null || true
        gsettings set org.gnome.desktop.interface show-battery-percentage true 2>/dev/null || true
        
        echo "✅ Desktop appearance configured"
    else
        echo "ℹ️  Not in GNOME session, appearance settings skipped"
    fi
}

main() {
    echo "🎨 Setting up complete UPack theme..."
    echo ""
    
    install_whitesur_theme
    install_icon_theme  
    install_cursor_theme
    apply_theme_tweaks
    configure_gsettings
    
    echo ""
    show_success "Theme setup completed successfully!"
    echo ""
    echo "📋 What was configured:"
    echo "  • WhiteSur GTK Theme (Dark Nord)"
    echo "  • Nordzy Icon Theme (Dark)"
    echo "  • Sunity Cursor Theme"
    echo "  • Dark mode enabled"
    echo "  • Ubuntu Neo wallpaper set"
    echo "  • GDM background customized"
    echo "  • Firefox theme applied"
    echo ""
}

main "$@"
