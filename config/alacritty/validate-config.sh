#!/bin/bash

# UPack Alacritty Configuration Validator
# Validates all Alacritty configuration files for warnings and errors

UPACK_DIR="${UPACK_DIR:-$HOME/.local/share/upack}"
source "$UPACK_DIR/utils/gum.sh" 2>/dev/null || {
    # Fallback log functions if gum.sh not available
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
    log_warning() { echo "⚠️  $1"; }
}

validate_alacritty_configs() {
    log_step "Validating Alacritty configurations..."
    
    local config_dir="$HOME/.config/alacritty"
    local configs=(
        "shared.toml"
        "theme.toml" 
        "font.toml"
        "pane.toml"
        "btop.toml"
    )
    
    local all_valid=true
    
    for config in "${configs[@]}"; do
        local config_file="$config_dir/$config"
        
        if [ -f "$config_file" ]; then
            log_info "Testing $config..."
            
            # Test configuration by running alacritty with it
            local test_output=$(timeout 2s alacritty --config-file "$config_file" --print-events 2>&1 | head -10)
            
            if echo "$test_output" | grep -qi "error"; then
                log_error "$config has errors:"
                echo "$test_output" | grep -i error
                all_valid=false
            elif echo "$test_output" | grep -qi "warn"; then
                log_warning "$config has warnings:"
                echo "$test_output" | grep -i warn
                all_valid=false
            else
                log_success "$config is valid"
            fi
        else
            log_error "$config not found at $config_file"
            all_valid=false
        fi
    done
    
    echo ""
    if [ "$all_valid" = true ]; then
        log_success "All Alacritty configurations are valid!"
        show_config_summary
    else
        log_error "Some configurations have issues. Please review above."
        return 1
    fi
}

show_config_summary() {
    echo ""
    log_info "Alacritty Configuration Summary:"
    echo "  📄 shared.toml  - Base configuration with keybindings"
    echo "  🎨 theme.toml   - Nord color scheme" 
    echo "  🔤 font.toml    - JetBrains Mono font settings"
    echo "  🖼️  pane.toml    - UPack Manager configuration"
    echo "  📊 btop.toml    - System monitor configuration"
    echo ""
    echo "  🚀 Usage:"
    echo "    upack gui      - Opens UPack Manager (uses pane.toml)"
    echo "    upack monitor  - Opens system monitor (uses btop.toml)" 
    echo "    alacritty      - Default terminal (uses shared config)"
    echo ""
}

fix_common_issues() {
    log_step "Checking for common configuration issues..."
    
    # Check for deprecated settings
    local deprecated_found=false
    
    if grep -r "^shell\s*=" "$HOME/.config/alacritty/" 2>/dev/null; then
        log_warning "Found deprecated 'shell' setting. Should be 'terminal.shell'"
        deprecated_found=true
    fi
    
    if grep -r "^import\s*=" "$HOME/.config/alacritty/" 2>/dev/null; then
        log_warning "Found deprecated 'import' setting. Should be 'general.import'"  
        deprecated_found=true
    fi
    
    if grep -r "draw_bold_text_with_bright_colors" "$HOME/.config/alacritty/" 2>/dev/null; then
        log_warning "Found deprecated 'draw_bold_text_with_bright_colors' setting"
        deprecated_found=true
    fi
    
    if [ "$deprecated_found" = false ]; then
        log_success "No deprecated settings found"
    else
        log_info "Run 'alacritty migrate' to automatically fix deprecated settings"
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    validate_alacritty_configs
    fix_common_issues
fi
