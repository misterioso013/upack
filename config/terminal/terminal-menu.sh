#!/usr/bin/env bash

set -e

# Terminal Configuration Menu
# Allows user to choose which terminal configurations to apply

source "$(dirname "$0")/../utils/gum.sh" 2>/dev/null || true

show_terminal_menu() {
    echo "🎨 UPack Terminal Configuration"
    echo "Choose which terminal configurations to apply:"
    echo ""
    
    # Available terminal configurations
    local options=(
        "bash-config    Configure elegant Bash with Nord theme and modern prompt"
        "terminal-apps  Install Alacritty + Zsh with Oh-My-Zsh and Powerlevel10k"
        "fonts          Install JetBrains Mono and Nerd Fonts"
        "all            Apply all terminal configurations"
    )
    
    # Let user select which configurations to apply
    local selected=$(printf "%s\n" "${options[@]}" | gum choose --no-limit --height 10)
    
    if [ -z "$selected" ]; then
        echo "❌ No terminal configurations selected"
        return 0
    fi
    
    echo ""
    echo "🔄 Applying selected terminal configurations..."
    echo ""
    
    # Process selections
    while IFS= read -r line; do
        local config=$(echo "$line" | awk '{print $1}')
        
        case "$config" in
            "bash-config")
                apply_bash_config
                ;;
            "terminal-apps")
                apply_terminal_apps
                ;;
            "fonts")
                apply_fonts_only
                ;;
            "all")
                apply_all_configs
                ;;
        esac
    done <<< "$selected"
    
    echo ""
    echo "✅ Terminal configuration completed!"
    echo ""
    echo "📋 Next steps:"
    echo "   • Restart your terminal or run 'source ~/.bashrc' for Bash changes"
    echo "   • Run 'chsh -s /bin/zsh' to set Zsh as default shell (if installed)"
    echo "   • Open a new terminal tab to see the changes"
    echo "   • Configure Powerlevel10k by running 'p10k configure' (if installed)"
}

apply_bash_config() {
    echo "🔧 Configuring elegant Bash settings..."
    bash "$(dirname "$0")/bash-config.sh"
}

apply_terminal_apps() {
    echo "📱 Installing terminal applications..."
    bash "$(dirname "$0")/../../install/apps/optional/terminal-config.sh"
}

apply_fonts_only() {
    echo "🔤 Installing terminal fonts..."
    
    # Source the terminal config script and extract only the font function
    local terminal_config="$(dirname "$0")/../../install/apps/optional/terminal-config.sh"
    if [ -f "$terminal_config" ]; then
        source "$terminal_config"
        configure_terminal_fonts
    else
        echo "❌ Terminal config script not found at: $terminal_config"
        return 1
    fi
}

apply_all_configs() {
    echo "🚀 Applying all terminal configurations..."
    
    apply_bash_config
    apply_terminal_apps
    
    echo "🎉 All terminal configurations applied!"
}

# Show terminal preview
show_terminal_preview() {
    echo ""
    echo "🎨 Terminal Preview"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "After configuration, your terminal will feature:"
    echo ""
    echo "  🎯 Elegant Nord-themed color scheme"
    echo "  ⚡ Modern prompt with Git integration"
    echo "  🔤 JetBrains Mono font with programming ligatures"
    echo "  🛠️  Useful aliases and functions"
    echo "  📚 Command history improvements"
    echo "  🎨 Syntax highlighting (with Zsh)"
    echo "  🤖 Auto-suggestions (with Zsh)"
    echo "  🖥️  GPU-accelerated Alacritty terminal (optional)"
    echo "  ⭐ Powerlevel10k theme (with Zsh)"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    show_terminal_preview
    echo ""
    if gum confirm "🎨 Would you like to configure your terminal?"; then
        show_terminal_menu
    else
        echo "⏭️  Skipping terminal configuration"
    fi
fi
