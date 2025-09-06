#!/bin/bash

source "$(dirname "$0")/../utils/gum.sh"

# Define log functions if not already available
if ! command -v log_step &> /dev/null; then
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
fi

install_gnome_extensions() {
    log_step "Installing GNOME Extensions Manager and CLI tools"
    
    # Install GNOME Extensions Manager and CLI tools
    sudo apt update
    sudo apt install -y gnome-shell-extension-manager pipx
    
    # Install gnome-extensions-cli via pipx
    pipx install gnome-extensions-cli --system-site-packages
    
    # Add pipx bin to PATH if not already there
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    log_step "Disabling default Ubuntu extensions"
    
    # Turn off default Ubuntu extensions
    gnome-extensions disable tiling-assistant@ubuntu.com 2>/dev/null || true
    gnome-extensions disable ubuntu-appindicators@ubuntu.com 2>/dev/null || true
    gnome-extensions disable ubuntu-dock@ubuntu.com 2>/dev/null || true
    gnome-extensions disable ding@rastersoft.com 2>/dev/null || true
    
    log_step "Installing GNOME extensions"
    
    # Check if gext is available, if not use fallback
    if command -v gext &> /dev/null; then
        EXT_CMD="gext install"
    else
        log_info "Using gnome-extensions-cli as fallback"
        EXT_CMD="~/.local/bin/gext install"
    fi
    
    # List of extensions to install (matching gnome.md)
    local extensions=(
        "tactile@lundal.io"
        "just-perfection-desktop@just-perfection"
        "blur-my-shell@aunetx"
        "space-bar@luchrioh"
        "undecorate@sun.wxg@gmail.com"
        "tophat@fflewddur.github.io"
        "AlphabeticalAppGrid@stuarthayhurst"
        "appindicatorsupport@rgcjonas.gmail.com"
    )
    
    # Pause to ask user to accept confirmations
    if command -v gum &> /dev/null; then
        gum confirm "To install GNOME extensions, you'll need to accept some confirmations. Ready?" || return 1
    else
        echo "To install GNOME extensions, you'll need to accept some confirmations."
        read -p "Press Enter to continue or Ctrl+C to cancel..."
    fi
    
    # Install extensions
    for extension in "${extensions[@]}"; do
        log_info "Installing extension: $extension"
        if ! eval $EXT_CMD "$extension"; then
            log_error "Failed to install $extension, continuing..."
        fi
    done
    
    log_step "Compiling gsettings schemas"
    compile_extension_schemas
    
    log_step "Configuring GNOME extensions"
    configure_extensions
    
    log_step "Applying Nord theme configuration"
    apply_nord_config
    
    log_success "GNOME extensions installed and configured!"
    log_info "You may need to log out and log back in for all changes to take effect"
}

compile_extension_schemas() {
    # Copy extension schemas to system directory
    local extensions_dir="$HOME/.local/share/gnome-shell/extensions"
    local schemas_dir="/usr/share/glib-2.0/schemas"
    
    # Extensions that have schemas to compile
    local schema_extensions=(
        "tactile@lundal.io"
        "just-perfection-desktop@just-perfection"
        "blur-my-shell@aunetx"
        "space-bar@luchrioh"
        "tophat@fflewddur.github.io"
        "AlphabeticalAppGrid@stuarthayhurst"
    )
    
    for ext in "${schema_extensions[@]}"; do
        if [ -d "$extensions_dir/$ext/schemas" ]; then
            log_info "Copying schemas for $ext"
            sudo cp "$extensions_dir/$ext/schemas/"*.gschema.xml "$schemas_dir/" 2>/dev/null || true
        fi
    done
    
    # Compile schemas
    sudo glib-compile-schemas "$schemas_dir/"
}

configure_extensions() {
    # Wait a moment for extensions to be available
    sleep 2
    
    # Configure Tactile (window tiling)
    if gnome-extensions list | grep -q "tactile@lundal.io"; then
        log_info "Configuring Tactile"
        gsettings set org.gnome.shell.extensions.tactile col-0 1
        gsettings set org.gnome.shell.extensions.tactile col-1 2
        gsettings set org.gnome.shell.extensions.tactile col-2 1
        gsettings set org.gnome.shell.extensions.tactile col-3 0
        gsettings set org.gnome.shell.extensions.tactile row-0 1
        gsettings set org.gnome.shell.extensions.tactile row-1 1
        gsettings set org.gnome.shell.extensions.tactile gap-size 32
    fi
    
    # Configure Just Perfection
    if gnome-extensions list | grep -q "just-perfection-desktop@just-perfection"; then
        log_info "Configuring Just Perfection"
        gsettings set org.gnome.shell.extensions.just-perfection animation 2
        gsettings set org.gnome.shell.extensions.just-perfection dash-app-running true
        gsettings set org.gnome.shell.extensions.just-perfection workspace true
        gsettings set org.gnome.shell.extensions.just-perfection workspace-popup false
    fi
    
    # Configure Blur My Shell
    if gnome-extensions list | grep -q "blur-my-shell@aunetx"; then
        log_info "Configuring Blur My Shell"
        gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder blur false
        gsettings set org.gnome.shell.extensions.blur-my-shell.lockscreen blur false
        gsettings set org.gnome.shell.extensions.blur-my-shell.screenshot blur false
        gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur false
        gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur false
        gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true
        gsettings set org.gnome.shell.extensions.blur-my-shell.overview pipeline 'pipeline_default'
        gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
        gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.6
        gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30
        gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur true
        gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock style-dash-to-dock 0
    fi
    
    # Configure Space Bar (workspace indicator)
    if gnome-extensions list | grep -q "space-bar@luchrioh"; then
        log_info "Configuring Space Bar"
        gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false
        gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false
        gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true
        gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []"
    fi
    
    # Configure TopHat (system monitor)
    if gnome-extensions list | grep -q "tophat@fflewddur.github.io"; then
        log_info "Configuring TopHat"
        gsettings set org.gnome.shell.extensions.tophat show-icons false
        gsettings set org.gnome.shell.extensions.tophat show-cpu true
        gsettings set org.gnome.shell.extensions.tophat show-disk false
        gsettings set org.gnome.shell.extensions.tophat show-mem true
        gsettings set org.gnome.shell.extensions.tophat show-fs false
        gsettings set org.gnome.shell.extensions.tophat network-usage-unit bits
    fi
    
    # Configure Alphabetical App Grid
    if gnome-extensions list | grep -q "AlphabeticalAppGrid@stuarthayhurst"; then
        log_info "Configuring Alphabetical App Grid"
        gsettings set org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end'
    fi
    
    # Enable all installed extensions
    log_info "Enabling installed extensions"
    for ext in "${extensions[@]}"; do
        if gnome-extensions list | grep -q "$ext"; then
            gnome-extensions enable "$ext" || true
        fi
    done
}

apply_nord_config() {
    local install_dir="$(dirname "$(dirname "$0")")"
    
    # Apply configurations from the conf file
    if [ -f "$install_dir/config/gnome/apply-config.sh" ]; then
        bash "$install_dir/config/gnome/apply-config.sh" "$install_dir"
    else
        log_info "No additional configuration file found, using basic settings"
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_gnome_extensions
fi
