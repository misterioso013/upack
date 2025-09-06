#!/bin/bash

# Apply GNOME extensions configuration from conf file
# Reads the extensions.conf file and applies settings via gsettings

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
fi

apply_extension_configs() {
    local install_dir="$1"
    local config_file="$install_dir/config/gnome/extensions.conf"
    
    if [ ! -f "$config_file" ]; then
        log_error "Configuration file not found: $config_file"
        return 1
    fi
    
    log_step "Applying GNOME extensions configuration"
    
    # Wait for extensions to be loaded
    sleep 3
    
    # Parse and apply configuration
    local current_section=""
    local schema_prefix="org.gnome.shell.extensions"
    
    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^#.*$ ]] && continue
        
        # Check if line is a section header
        if [[ "$line" =~ ^\[(.+)\]$ ]]; then
            current_section="${BASH_REMATCH[1]}"
            continue
        fi
        
        # Check if line is a key-value pair
        if [[ "$line" =~ ^([^=]+)=(.*)$ ]]; then
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"
            
            # Detect and preserve value types for gsettings
            local processed_value
            if [[ "$value" =~ ^(true|false)$ ]]; then
                # Boolean value - pass as-is
                processed_value="$value"
            elif [[ "$value" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
                # Numeric value - pass as-is
                processed_value="$value"
            elif [[ "$value" =~ ^\[.*\]$ ]] || [[ "$value" =~ ^\{.*\}$ ]]; then
                # Array or object - pass as-is
                processed_value="$value"
            else
                # String value - create proper GVariant string literal
                # Strip outer quotes if present
                processed_value="${value#\'}"
                processed_value="${processed_value%\'}"
                processed_value="${value#\"}"
                processed_value="${processed_value%\"}"
                # Escape embedded single quotes using standard shell idiom
                processed_value="${processed_value//\'/\'\"\'\"\'}"
                # Wrap in single quotes for GVariant
                processed_value="'$processed_value'"
            fi
            
            if [[ -n "$current_section" ]]; then
                # Build the full schema path - handle dot notation
                local schema
                if [[ "$current_section" == *"."* ]]; then
                    # Replace dots with dashes in section names for schema paths
                    schema="$schema_prefix.${current_section//./-}"
                else
                    schema="$schema_prefix.$current_section"
                fi
                
                # Check if the schema exists and is writable
                if gsettings list-schemas | grep -q "^$schema$"; then
                    if gsettings writable "$schema" "$key" 2>/dev/null | grep -q "true"; then
                        log_info "Setting $schema.$key = $processed_value"
                        gsettings set "$schema" "$key" "$processed_value" 2>/dev/null || {
                            log_error "Failed to set $schema.$key"
                        }
                    else
                        log_info "Skipping non-writable key: $schema.$key"
                    fi
                else
                    log_info "Schema not found (extension may not be installed): $schema"
                fi
            fi
        fi
    done < "$config_file"
    
    log_success "Extension configuration applied!"
    log_info "Some changes may require logging out and back in to take effect"
    
    # Ask if user wants to configure productivity hotkeys
    echo ""
    # Check if hotkeys should be skipped (CI/headless mode)
    if [[ "$UPACK_SKIP_HOTKEYS" == "1" ]] || [[ ! -t 0 ]]; then
        log_info "Hotkeys configuration skipped (non-interactive session or UPACK_SKIP_HOTKEYS=1)"
    elif command -v gum >/dev/null 2>&1; then
        if gum confirm "🎯 Would you like to configure productivity hotkeys for GNOME?"; then
            bash "$(dirname "$0")/hotkeys.sh"
        else
            log_info "Hotkeys configuration skipped"
        fi
    else
        printf "🎯 Would you like to configure productivity hotkeys for GNOME? (y/N): "
        read -r response
        case "$response" in
            [yY]|[yY][eE][sS])
                bash "$(dirname "$0")/hotkeys.sh"
                ;;
            *)
                log_info "Hotkeys configuration skipped"
                ;;
        esac
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_dir="${1:-$PWD}"
    apply_extension_configs "$install_dir"
fi
