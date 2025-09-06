#!/bin/bash

# UPack GNOME Hotkeys Configuration
# Configures productivity-focused keyboard shortcuts for GNOME desktop

UPACK_DIR="${UPACK_DIR:-$HOME/.local/share/upack}"
source "$UPACK_DIR/utils/gum.sh" 2>/dev/null || {
    # Fallback log functions if gum.sh not available
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
    log_warning() { echo "⚠️  $1"; }
} 2>/dev/null || true

# Define log functions if not already available
if ! command -v log_step &> /dev/null; then
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
    log_warning() { echo "⚠️  $1"; }
fi

configure_gnome_hotkeys() {
    log_step "Configuring GNOME productivity hotkeys"
    
    # Backup current keybindings
    backup_current_settings
    
    # Window management hotkeys
    configure_window_management
    
    # Workspace navigation
    configure_workspace_navigation
    
    # Application switching
    configure_application_switching
    
    # Custom application shortcuts
    configure_custom_shortcuts
    
    # System shortcuts
    configure_system_shortcuts
    
    log_success "GNOME hotkeys configured for maximum productivity!"
    show_hotkey_summary
}

backup_current_settings() {
    log_info "Creating backup of current GNOME settings..."
    
    local backup_dir="$HOME/.config/upack-backups/gnome-settings-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup key settings
    dconf dump /org/gnome/desktop/wm/keybindings/ > "$backup_dir/wm-keybindings.conf"
    dconf dump /org/gnome/shell/keybindings/ > "$backup_dir/shell-keybindings.conf"
    dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$backup_dir/media-keys.conf"
    
    log_success "Settings backed up to: $backup_dir"
}

configure_window_management() {
    log_info "Configuring window management shortcuts..."
    
    # Close window with Super+W (more convenient than Alt+F4)
    gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"
    
    # Maximize with Super+Up (like Windows)
    gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"
    
    # Unmaximize with Super+Down
    gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Super>Down']"
    
    # Snap left/right (check if keys exist first)
    if gsettings list-keys org.gnome.desktop.wm.keybindings | grep -q "tile-left"; then
        gsettings set org.gnome.desktop.wm.keybindings tile-left "['<Super>Left']"
        gsettings set org.gnome.desktop.wm.keybindings tile-right "['<Super>Right']"
    else
        # Fallback for older GNOME versions
        if gsettings list-keys org.gnome.desktop.wm.keybindings | grep -q "move-to-side-e"; then
            gsettings set org.gnome.desktop.wm.keybindings move-to-side-w "['<Super>Left']"
            gsettings set org.gnome.desktop.wm.keybindings move-to-side-e "['<Super>Right']"
        fi
    fi
    
    # Resize undecorated windows
    gsettings set org.gnome.desktop.wm.keybindings begin-resize "['<Super>BackSpace']"
    
    # Toggle fullscreen
    gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Shift>F11']"
    
    # Minimize window
    gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>h']"
    
    # Always on top toggle
    gsettings set org.gnome.desktop.wm.keybindings toggle-on-all-workspaces "['<Super><Shift>t']"
    
    log_success "Window management shortcuts configured"
}

configure_workspace_navigation() {
    log_info "Configuring workspace navigation..."
    
    # Use 6 fixed workspaces instead of dynamic mode for predictability
    gsettings set org.gnome.mutter dynamic-workspaces false
    gsettings set org.gnome.desktop.wm.preferences num-workspaces 6
    
    # Super + Numbers for workspace switching
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
    
    # Move window to workspace with Super+Shift+Numbers
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']"
    
    # Workspace navigation with Super+Ctrl+Arrow
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super><Ctrl>Left']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super><Ctrl>Right']"
    
    log_success "Workspace navigation configured (6 fixed workspaces)"
}

configure_application_switching() {
    log_info "Configuring application switching shortcuts..."
    
    # Alt + Numbers for pinned applications (dock/favorites)
    gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Alt>1']"
    gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Alt>2']"
    gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Alt>3']"
    gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Alt>4']"
    gsettings set org.gnome.shell.keybindings switch-to-application-5 "['<Alt>5']"
    gsettings set org.gnome.shell.keybindings switch-to-application-6 "['<Alt>6']"
    gsettings set org.gnome.shell.keybindings switch-to-application-7 "['<Alt>7']"
    gsettings set org.gnome.shell.keybindings switch-to-application-8 "['<Alt>8']"
    gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Alt>9']"
    
    # Application launcher with Super+Space
    gsettings set org.gnome.desktop.wm.keybindings switch-input-source "@as []"
    gsettings set org.gnome.shell.keybindings show-run-command "['<Super>space']"
    
    # Show applications overview
    gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super>a']"
    
    log_success "Application switching configured (Alt+Numbers for pinned apps)"
}

configure_custom_shortcuts() {
    log_info "Configuring custom application shortcuts..."
    
    # Reserve slots for custom keybindings
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
        "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', \
          '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', \
          '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', \
          '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/', \
          '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/', \
          '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/']"
    
    # Terminal: Super+T (or fallback to Ctrl+Alt+T)
    setup_custom_keybinding "custom0" "Terminal" "gnome-terminal" "<Super>t"
    
    # File Manager: Super+E (like Windows Explorer)
    setup_custom_keybinding "custom1" "File Manager" "nautilus" "<Super>e"
    
    # Screenshot: Ctrl+Shift+S (like modern apps)
    if command -v flameshot &> /dev/null; then
        setup_custom_keybinding "custom2" "Screenshot (Flameshot)" "sh -c -- \"flameshot gui\"" "<Ctrl><Shift>s"
    elif command -v gnome-screenshot &> /dev/null; then
        setup_custom_keybinding "custom2" "Screenshot" "gnome-screenshot -i" "<Ctrl><Shift>s"
    fi
    
    # Text Editor: Super+Shift+T
    if command -v code &> /dev/null; then
        setup_custom_keybinding "custom3" "VS Code" "code" "<Super><Shift>t"
    elif command -v gedit &> /dev/null; then
        setup_custom_keybinding "custom3" "Text Editor" "gedit" "<Super><Shift>t"
    fi
    
    # Calculator: Super+C
    setup_custom_keybinding "custom4" "Calculator" "gnome-calculator" "<Super>c"
    
    # System Monitor: Ctrl+Shift+Esc (like Windows Task Manager)
    if command -v htop &> /dev/null; then
        setup_custom_keybinding "custom5" "System Monitor" "gnome-terminal -- htop" "<Ctrl><Shift>Escape"
    else
        setup_custom_keybinding "custom5" "System Monitor" "gnome-system-monitor" "<Ctrl><Shift>Escape"
    fi
    
    log_success "Custom application shortcuts configured"
}

setup_custom_keybinding() {
    local slot="$1"
    local name="$2"
    local command="$3"
    local binding="$4"
    
    local base_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$slot/"
    
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$base_path" name "$name"
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$base_path" command "$command"
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$base_path" binding "$binding"
    
    log_info "  $binding → $name"
}

configure_system_shortcuts() {
    log_info "Configuring system shortcuts..."
    
    # Lock screen: Super+L (like Windows)
    gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']"
    
    # Logout: Ctrl+Alt+Delete
    gsettings set org.gnome.settings-daemon.plugins.media-keys logout "['<Ctrl><Alt>Delete']"
    
    # Show desktop: Super+D (like Windows)
    gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
    
    # Media controls for keyboards without dedicated keys
    gsettings set org.gnome.settings-daemon.plugins.media-keys next "['<Shift>AudioPlay']"
    
    # Volume controls
    gsettings set org.gnome.settings-daemon.plugins.media-keys volume-up "['AudioRaiseVolume']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys volume-down "['AudioLowerVolume']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute "['AudioMute']"
    
    # Brightness (if supported)
    gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-up "['MonBrightnessUp']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-down "['MonBrightnessDown']"
    
    log_success "System shortcuts configured"
}

show_hotkey_summary() {
    echo ""
    echo "🎯 UPack Productivity Hotkeys Summary"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📱 Applications (Alt + Number):"
    echo "  Alt+1-9         → Switch to pinned applications"
    echo "  Super+Space     → Application launcher"
    echo "  Super+A         → Show all applications"
    echo ""
    echo "🖼️  Windows (Super + Key):"
    echo "  Super+W         → Close window"
    echo "  Super+Up        → Maximize"
    echo "  Super+Down      → Unmaximize"
    echo "  Super+Left      → Snap left"
    echo "  Super+Right     → Snap right"
    echo "  Super+H         → Minimize"
    echo "  Super+D         → Show desktop"
    echo "  Super+Backspace → Resize mode"
    echo ""
    echo "🏢 Workspaces (Super + Number):"
    echo "  Super+1-6           → Switch to workspace"
    echo "  Super+Shift+1-6     → Move window to workspace"
    echo "  Super+Ctrl+Left/Right → Navigate workspaces"
    echo ""
    echo "🚀 Quick Launch:"
    echo "  Super+T             → Terminal"
    echo "  Super+E             → File Manager"
    echo "  Super+C             → Calculator"
    echo "  Super+Shift+T       → Text Editor/VS Code"
    echo "  Ctrl+Shift+S        → Screenshot"
    echo "  Ctrl+Shift+Esc      → System Monitor"
    echo ""
    echo "🔐 System:"
    echo "  Super+L             → Lock screen"
    echo "  Ctrl+Alt+Delete     → Logout"
    echo "  Shift+F11           → Fullscreen"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "💡 Tips:"
    echo "  • Pin your favorite apps to the dock for Alt+Number access"
    echo "  • Use 6 fixed workspaces for consistent navigation"
    echo "  • Super key acts like Windows key for familiar shortcuts"
    echo "  • Backup created in ~/.config/upack-backups/"
    echo ""
}

# Function to reset to defaults if needed
reset_to_defaults() {
    log_warning "Resetting GNOME keybindings to defaults..."
    
    # Reset schemas
    gsettings reset-recursively org.gnome.desktop.wm.keybindings
    gsettings reset-recursively org.gnome.shell.keybindings
    gsettings reset-recursively org.gnome.settings-daemon.plugins.media-keys
    
    # Reset workspace settings
    gsettings reset org.gnome.mutter dynamic-workspaces
    gsettings reset org.gnome.desktop.wm.preferences num-workspaces
    
    log_success "GNOME keybindings reset to defaults"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "🎯 UPack GNOME Productivity Hotkeys"
    echo "Configure keyboard shortcuts for maximum productivity"
    echo ""
    
    # Check if running on GNOME
    if [[ "$XDG_CURRENT_DESKTOP" != *"GNOME"* ]] && [[ "$DESKTOP_SESSION" != *"gnome"* ]]; then
        log_warning "This script is designed for GNOME desktop environment"
        echo "Current desktop: $XDG_CURRENT_DESKTOP"
        echo ""
        if ! gum confirm "Continue anyway?"; then
            exit 0
        fi
    fi
    
    # Show summary first
    show_hotkey_summary
    
    if gum confirm "🎯 Configure these productivity hotkeys?"; then
        configure_gnome_hotkeys
        echo ""
        echo "🎉 Hotkeys configured! Changes take effect immediately."
        echo "💾 Settings backup saved to ~/.config/upack-backups/"
        echo ""
        if gum confirm "📋 Would you like to see the summary again?"; then
            show_hotkey_summary
        fi
    else
        echo "⏭️  Hotkey configuration skipped"
    fi
fi
