#!/bin/bash

# Apply GNOME extensions configuration from conf file
# Reads the extensions.conf file and applies settings via gsettings

source "$(dirname "$0")/../../utils/gum.sh" 2>/dev/null || true

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
            
            # Remove quotes if present
            value=$(echo "$value" | sed "s/^'//;s/'$//")
            
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
                        log_info "Setting $schema.$key = $value"
                        gsettings set "$schema" "$key" "$value" 2>/dev/null || {
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
    if gum confirm "🎯 Would you like to configure productivity hotkeys for GNOME?"; then
        bash "$(dirname "$0")/hotkeys.sh"
    else
        log_info "Hotkeys configuration skipped"
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_dir="${1:-$PWD}"
    apply_extension_configs "$install_dir"
fi
