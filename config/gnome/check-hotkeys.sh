#!/bin/bash

# UPack GNOME Hotkeys Checker
# Shows currently configured keyboard shortcuts

source "$(dirname "$0")/../../utils/gum.sh" 2>/dev/null || true

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

show_current_hotkeys() {
    echo "🔍 Current GNOME Keyboard Shortcuts"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    show_window_management_keys
    show_workspace_keys
    show_application_keys
    show_custom_keys
    show_system_keys
}

show_window_management_keys() {
    echo -e "${BLUE}🖼️  Window Management:${NC}"
    check_keybinding "org.gnome.desktop.wm.keybindings" "close" "Close Window"
    check_keybinding "org.gnome.desktop.wm.keybindings" "maximize" "Maximize"
    check_keybinding "org.gnome.desktop.wm.keybindings" "unmaximize" "Unmaximize"
    check_keybinding "org.gnome.desktop.wm.keybindings" "minimize" "Minimize"
    check_keybinding "org.gnome.desktop.wm.keybindings" "show-desktop" "Show Desktop"
    check_keybinding "org.gnome.desktop.wm.keybindings" "toggle-fullscreen" "Toggle Fullscreen"
    check_keybinding "org.gnome.desktop.wm.keybindings" "begin-resize" "Resize Mode"
    
    # Check tile keys (might not exist in all GNOME versions)
    if gsettings list-keys org.gnome.desktop.wm.keybindings | grep -q "tile-left"; then
        check_keybinding "org.gnome.desktop.wm.keybindings" "tile-left" "Snap Left"
        check_keybinding "org.gnome.desktop.wm.keybindings" "tile-right" "Snap Right"
    fi
    echo ""
}

show_workspace_keys() {
    echo -e "${YELLOW}🏢 Workspace Navigation:${NC}"
    check_setting "org.gnome.mutter" "dynamic-workspaces" "Dynamic Workspaces"
    check_setting "org.gnome.desktop.wm.preferences" "num-workspaces" "Number of Workspaces"
    
    for i in {1..6}; do
        check_keybinding "org.gnome.desktop.wm.keybindings" "switch-to-workspace-$i" "Switch to Workspace $i"
        check_keybinding "org.gnome.desktop.wm.keybindings" "move-to-workspace-$i" "Move to Workspace $i"
    done
    
    check_keybinding "org.gnome.desktop.wm.keybindings" "switch-to-workspace-left" "Previous Workspace"
    check_keybinding "org.gnome.desktop.wm.keybindings" "switch-to-workspace-right" "Next Workspace"
    echo ""
}

show_application_keys() {
    echo -e "${GREEN}📱 Application Switching:${NC}"
    for i in {1..9}; do
        check_keybinding "org.gnome.shell.keybindings" "switch-to-application-$i" "Switch to App $i"
    done
    
    check_keybinding "org.gnome.desktop.wm.keybindings" "switch-input-source" "Input Source (should be disabled)"
    check_keybinding "org.gnome.shell.keybindings" "toggle-application-view" "Show Applications"
    echo ""
}

show_custom_keys() {
    echo -e "${BLUE}🚀 Custom Shortcuts:${NC}"
    
    # Get custom keybindings list
    local custom_bindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings 2>/dev/null)
    
    if [ "$custom_bindings" != "@as []" ] && [ "$custom_bindings" != "[]" ]; then
        # Parse the array and show each custom binding
        echo "$custom_bindings" | sed 's/\[//g' | sed 's/\]//g' | sed "s/'//g" | tr ',' '\n' | while read -r path; do
            if [ -n "$path" ]; then
                path=$(echo "$path" | xargs) # trim whitespace
                local name=$(gsettings get "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path" name 2>/dev/null | sed "s/'//g")
                local command=$(gsettings get "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path" command 2>/dev/null | sed "s/'//g")
                local binding=$(gsettings get "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path" binding 2>/dev/null | sed "s/'//g")
                
                if [ -n "$name" ] && [ -n "$binding" ]; then
                    echo "  $name: $binding → $command"
                fi
            fi
        done
    else
        echo "  No custom shortcuts configured"
    fi
    echo ""
}

show_system_keys() {
    echo -e "${RED}🔐 System Shortcuts:${NC}"
    check_keybinding "org.gnome.settings-daemon.plugins.media-keys" "screensaver" "Lock Screen"
    check_keybinding "org.gnome.settings-daemon.plugins.media-keys" "logout" "Logout"
    check_keybinding "org.gnome.settings-daemon.plugins.media-keys" "volume-up" "Volume Up"
    check_keybinding "org.gnome.settings-daemon.plugins.media-keys" "volume-down" "Volume Down"
    check_keybinding "org.gnome.settings-daemon.plugins.media-keys" "volume-mute" "Volume Mute"
    echo ""
}

check_keybinding() {
    local schema="$1"
    local key="$2"
    local description="$3"
    
    local value=$(gsettings get "$schema" "$key" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        if [ "$value" != "@as []" ] && [ "$value" != "[]" ]; then
            value=$(echo "$value" | sed "s/\['//g" | sed "s/'\]//g" | sed "s/', '/ + /g")
            echo "  $description: $value"
        else
            echo "  $description: Not set"
        fi
    else
        echo "  $description: Key not available"
    fi
}

check_setting() {
    local schema="$1"
    local key="$2"
    local description="$3"
    
    local value=$(gsettings get "$schema" "$key" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo "  $description: $value"
    else
        echo "  $description: Not available"
    fi
}

# Function to export current settings to a file
export_current_settings() {
    local export_file="$HOME/upack-current-hotkeys-$(date +%Y%m%d_%H%M%S).txt"
    
    echo "📤 Exporting current hotkey settings to: $export_file"
    
    {
        echo "# UPack GNOME Hotkeys Export - $(date)"
        echo "# Generated by UPack hotkeys checker"
        echo ""
        
        echo "## Window Management"
        gsettings list-recursively org.gnome.desktop.wm.keybindings | grep -E "(close|maximize|minimize|tile|snap|resize|fullscreen|desktop)" | sort
        echo ""
        
        echo "## Workspace Navigation"
        gsettings list-recursively org.gnome.desktop.wm.keybindings | grep -E "workspace" | sort
        gsettings get org.gnome.mutter dynamic-workspaces | sed 's/^/org.gnome.mutter dynamic-workspaces /'
        gsettings get org.gnome.desktop.wm.preferences num-workspaces | sed 's/^/org.gnome.desktop.wm.preferences num-workspaces /'
        echo ""
        
        echo "## Application Switching"
        gsettings list-recursively org.gnome.shell.keybindings | grep -E "application" | sort
        echo ""
        
        echo "## System Keys"
        gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys | grep -E "(screensaver|logout|volume|brightness)" | sort
        echo ""
        
        echo "## Custom Shortcuts"
        gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | sed 's/^/org.gnome.settings-daemon.plugins.media-keys custom-keybindings /'
        
        # Export each custom binding
        local custom_bindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings 2>/dev/null)
        if [ "$custom_bindings" != "@as []" ] && [ "$custom_bindings" != "[]" ]; then
            echo "$custom_bindings" | sed 's/\[//g' | sed 's/\]//g' | sed "s/'//g" | tr ',' '\n' | while read -r path; do
                if [ -n "$path" ]; then
                    path=$(echo "$path" | xargs)
                    gsettings list-recursively "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path" 2>/dev/null
                fi
            done
        fi
        
    } > "$export_file"
    
    echo "✅ Settings exported successfully!"
    echo "📄 File: $export_file"
}

# Function to compare with UPack defaults
compare_with_defaults() {
    echo "⚖️  Comparing current settings with UPack defaults..."
    echo ""
    
    # Define UPack default shortcuts
    declare -A upack_defaults
    upack_defaults["close"]="<Super>w"
    upack_defaults["maximize"]="<Super>Up"
    upack_defaults["unmaximize"]="<Super>Down"
    upack_defaults["minimize"]="<Super>h"
    upack_defaults["show-desktop"]="<Super>d"
    upack_defaults["screensaver"]="<Super>l"
    
    echo "🔍 Checking key UPack shortcuts:"
    for key in "${!upack_defaults[@]}"; do
        local expected="${upack_defaults[$key]}"
        local current=""
        
        if [[ "$key" == "screensaver" ]]; then
            current=$(gsettings get org.gnome.settings-daemon.plugins.media-keys "$key" 2>/dev/null | sed "s/\['//g" | sed "s/'\]//g")
        else
            current=$(gsettings get org.gnome.desktop.wm.keybindings "$key" 2>/dev/null | sed "s/\['//g" | sed "s/'\]//g")
        fi
        
        if [ "$current" = "$expected" ]; then
            echo -e "  ✅ $key: ${GREEN}$current${NC} (matches UPack default)"
        else
            echo -e "  ⚠️  $key: ${YELLOW}$current${NC} (expected: ${GREEN}$expected${NC})"
        fi
    done
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "🔍 UPack GNOME Hotkeys Checker"
    echo "Check currently configured keyboard shortcuts"
    echo ""
    
    if [[ "$1" == "--export" ]]; then
        export_current_settings
        exit 0
    elif [[ "$1" == "--compare" ]]; then
        compare_with_defaults
        exit 0
    elif [[ "$1" == "--help" ]]; then
        echo "Usage:"
        echo "  $0              Show current hotkeys"
        echo "  $0 --export     Export settings to file"
        echo "  $0 --compare    Compare with UPack defaults"
        echo "  $0 --help       Show this help"
        exit 0
    fi
    
    show_current_hotkeys
    
    echo ""
    echo "💡 Available options:"
    echo "  bash $0 --export     Export current settings"
    echo "  bash $0 --compare    Compare with UPack defaults"
fi
