#!/bin/bash

# Fix relative paths in UPack scripts
# This script updates all scripts to use absolute paths

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPACK_DIR="$HOME/.local/share/upack"

echo "🔧 Fixing relative paths in UPack scripts..."

# Function to fix a single script file
fix_script() {
    local file="$1"
    local backup_file="${file}.bak"
    
    # Create backup
    cp "$file" "$backup_file"
    
    # Replace relative path patterns
    sed -i 's|source "$(dirname "$0")/../../utils/gum.sh"|UPACK_DIR="${UPACK_DIR:-$HOME/.local/share/upack}"\nsource "$UPACK_DIR/utils/gum.sh" 2>/dev/null \|\| {\n    # Fallback log functions if gum.sh not available\n    log_step() { echo "🔄 $1"; }\n    log_info() { echo "ℹ️  $1"; }\n    log_success() { echo "✅ $1"; }\n    log_error() { echo "❌ $1"; }\n    log_warning() { echo "⚠️  $1"; }\n}|g' "$file"
    
    sed -i 's|source "$(dirname "$0")/../../../utils/gum.sh"|UPACK_DIR="${UPACK_DIR:-$HOME/.local/share/upack}"\nsource "$UPACK_DIR/utils/gum.sh" 2>/dev/null \|\| {\n    # Fallback log functions if gum.sh not available\n    log_step() { echo "🔄 $1"; }\n    log_info() { echo "ℹ️  $1"; }\n    log_success() { echo "✅ $1"; }\n    log_error() { echo "❌ $1"; }\n    log_warning() { echo "⚠️  $1"; }\n}|g' "$file"
    
    # Replace other common relative paths
    sed -i 's|source "$(dirname "$0")/common.sh"|source "$UPACK_DIR/core/common.sh"|g' "$file"
    sed -i 's|source core/common.sh|source "$UPACK_DIR/core/common.sh"|g' "$file"
    sed -i 's|bash core/|bash "$UPACK_DIR/core/"|g' "$file"
    sed -i 's|bash install/|bash "$UPACK_DIR/install/"|g' "$file"
    sed -i 's|bash config/|bash "$UPACK_DIR/config/"|g' "$file"
    
    echo "✅ Fixed: $file"
}

# Find and fix all shell scripts in the project
echo "🔍 Finding shell scripts to fix..."

# Compute repository root
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
if [ ! -d "$REPO_ROOT" ]; then
    echo "❌ Repository root not found"
    exit 1
fi

# Fix scripts in install/apps/required/
find "$REPO_ROOT/install/apps/required" -name "*.sh" -type f | while read -r script; do
    if [ "$script" != "$REPO_ROOT/install/apps/required/gnome-extension-manager.sh" ]; then
        fix_script "$script"
    fi
done

# Fix scripts in install/apps/optional/
find "$REPO_ROOT/install/apps/optional" -name "*.sh" -type f | while read -r script; do
    if [ "$script" != "$REPO_ROOT/install/apps/required/upack-app.sh" ]; then
        fix_script "$script"
    fi
done

# Fix scripts in config/
find "$REPO_ROOT/config" -name "*.sh" -type f | while read -r script; do
    fix_script "$script"
done

# Fix scripts in core/
find "$REPO_ROOT/core" -name "*.sh" -type f | while read -r script; do
    fix_script "$script"
done

# Fix scripts in utils/
find "$REPO_ROOT/utils" -name "*.sh" -type f | while read -r script; do
    fix_script "$script"
done

echo ""
echo "✅ All relative paths have been fixed!"
echo "📁 Backup files created with .bak extension"
echo ""
echo "🧪 To test the fixes:"
echo "  ./dev.sh"
echo ""
echo "🗑️  To remove backup files:"
echo "  find . -name '*.bak' -delete"
