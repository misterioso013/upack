#!/bin/bash

# UPack GNOME Hotkeys Menu
# Interactive menu for configuring GNOME productivity hotkeys

source "$(dirname "$0")/../../utils/gum.sh" 2>/dev/null || true

show_hotkeys_menu() {
    echo "🎯 UPack GNOME Hotkeys Configuration"
    echo "Choose which hotkey configurations to apply:"
    echo ""
    
    local options=(
        "all                Apply all productivity hotkeys (recommended)"
        "window-management  Configure window management shortcuts"
        "workspaces         Configure workspace navigation"
        "applications       Configure application switching"
        "custom             Configure custom application shortcuts"
        "system             Configure system shortcuts"
        "reset              Reset all keybindings to GNOME defaults"
        "preview            Show hotkey summary without applying"
    )
    
    local selected=$(printf "%s\n" "${options[@]}" | gum choose --height 12)
    
    if [ -z "$selected" ]; then
        echo "❌ No configuration selected"
        return 0
    fi
    
    local config=$(echo "$selected" | awk '{print $1}')
    
    case "$config" in
        "all")
            apply_all_hotkeys
            ;;
        "window-management")
            apply_window_management_only
            ;;
        "workspaces")
            apply_workspace_navigation_only
            ;;
        "applications")
            apply_application_switching_only
            ;;
        "custom")
            apply_custom_shortcuts_only
            ;;
        "system")
            apply_system_shortcuts_only
            ;;
        "reset")
            reset_hotkeys_to_defaults
            ;;
        "preview")
            show_preview_only
            ;;
    esac
}

apply_all_hotkeys() {
    echo "🚀 Applying all productivity hotkeys..."
    bash "$(dirname "$0")/hotkeys.sh"
}

apply_window_management_only() {
    echo "🖼️  Applying window management shortcuts..."
    source "$(dirname "$0")/hotkeys.sh"
    backup_current_settings
    configure_window_management
    echo "✅ Window management shortcuts configured!"
    show_window_management_summary
}

apply_workspace_navigation_only() {
    echo "🏢 Applying workspace navigation shortcuts..."
    source "$(dirname "$0")/hotkeys.sh"
    backup_current_settings
    configure_workspace_navigation
    echo "✅ Workspace navigation configured!"
    show_workspace_summary
}

apply_application_switching_only() {
    echo "📱 Applying application switching shortcuts..."
    source "$(dirname "$0")/hotkeys.sh"
    backup_current_settings
    configure_application_switching
    echo "✅ Application switching configured!"
    show_application_summary
}

apply_custom_shortcuts_only() {
    echo "🚀 Applying custom application shortcuts..."
    source "$(dirname "$0")/hotkeys.sh"
    backup_current_settings
    configure_custom_shortcuts
    echo "✅ Custom shortcuts configured!"
    show_custom_summary
}

apply_system_shortcuts_only() {
    echo "🔐 Applying system shortcuts..."
    source "$(dirname "$0")/hotkeys.sh"
    backup_current_settings
    configure_system_shortcuts
    echo "✅ System shortcuts configured!"
    show_system_summary
}

reset_hotkeys_to_defaults() {
    echo "⚠️  Resetting all keybindings to GNOME defaults"
    echo ""
    if gum confirm "This will remove all custom keybindings. Continue?"; then
        source "$(dirname "$0")/hotkeys.sh"
        reset_to_defaults
    else
        echo "Reset cancelled"
    fi
}

show_preview_only() {
    source "$(dirname "$0")/hotkeys.sh"
    show_hotkey_summary
}

show_window_management_summary() {
    echo ""
    echo "🖼️  Window Management Shortcuts:"
    echo "  Super+W         → Close window"
    echo "  Super+Up        → Maximize"
    echo "  Super+Down      → Unmaximize"
    echo "  Super+Left      → Snap left"
    echo "  Super+Right     → Snap right"
    echo "  Super+H         → Minimize"
    echo "  Super+D         → Show desktop"
    echo "  Super+Backspace → Resize mode"
    echo "  Shift+F11       → Toggle fullscreen"
    echo ""
}

show_workspace_summary() {
    echo ""
    echo "🏢 Workspace Navigation:"
    echo "  Super+1-6           → Switch to workspace"
    echo "  Super+Shift+1-6     → Move window to workspace"
    echo "  Super+Ctrl+Left/Right → Navigate workspaces"
    echo "  ℹ️  Configured for 6 fixed workspaces"
    echo ""
}

show_application_summary() {
    echo ""
    echo "📱 Application Switching:"
    echo "  Alt+1-9         → Switch to pinned applications"
    echo "  Super+Space     → Application launcher"
    echo "  Super+A         → Show all applications"
    echo ""
}

show_custom_summary() {
    echo ""
    echo "🚀 Custom Application Shortcuts:"
    echo "  Super+T             → Terminal"
    echo "  Super+E             → File Manager"
    echo "  Super+C             → Calculator"
    echo "  Super+Shift+T       → Text Editor/VS Code"
    echo "  Ctrl+Shift+S        → Screenshot"
    echo "  Ctrl+Shift+Esc      → System Monitor"
    echo ""
}

show_system_summary() {
    echo ""
    echo "🔐 System Shortcuts:"
    echo "  Super+L             → Lock screen"
    echo "  Ctrl+Alt+Delete     → Logout"
    echo "  Volume/Media keys   → System controls"
    echo ""
}

# Function to show current keybinding for a command
show_current_binding() {
    local schema="$1"
    local key="$2"
    local current=$(gsettings get "$schema" "$key" 2>/dev/null)
    
    if [ "$current" != "@as []" ] && [ "$current" != "[]" ]; then
        echo "  Current: $current"
    else
        echo "  Current: Not set"
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "🎯 UPack GNOME Productivity Hotkeys"
    echo ""
    
    # Check if running on GNOME
    if [[ "$XDG_CURRENT_DESKTOP" != *"GNOME"* ]] && [[ "$DESKTOP_SESSION" != *"gnome"* ]]; then
        echo "⚠️  Warning: This script is designed for GNOME desktop environment"
        echo "Current desktop: $XDG_CURRENT_DESKTOP"
        echo ""
        if ! gum confirm "Continue anyway?"; then
            exit 0
        fi
    fi
    
    show_hotkeys_menu
fi
