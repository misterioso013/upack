#!/bin/bash

# UPack Cleanup - Remove deprecated and unused files
# Part of the v2.0.0 restructuring cleanup

echo "🧹 UPack v2.0.0 Cleanup"
echo "Removing deprecated files and directories..."
echo ""

# Files to remove (deprecated after restructuring)
deprecated_files=(
    "install/theme.sh"
    "install/gnome-extensions.sh" 
    "core/required.sh"
    "core/common.sh"
    "core/menu.sh"
    "core/optional.sh"
    "utils/mise.sh"
    "install/apps/optional/dev-languages.sh"
    "install/apps/optional/mise-setup.sh"
    "dev.sh"
    "start.sh"
    "install.sh"
)

# Directories to remove (deprecated)
deprecated_dirs=(
    "core/"
)

removed_count=0

# Remove deprecated files
for file in "${deprecated_files[@]}"; do
    if [ -f "$file" ]; then
        rm "$file"
        echo "✅ Removed: $file"
        ((removed_count++))
    fi
done

# Remove deprecated directories
for dir in "${deprecated_dirs[@]}"; do
    if [ -d "$dir" ]; then
        rm -rf "$dir"
        echo "✅ Removed directory: $dir"
        ((removed_count++))
    fi
done

# Clean up empty directories
find . -type d -empty -delete 2>/dev/null || true

echo ""
if [ $removed_count -gt 0 ]; then
    echo "🎉 Cleanup completed! Removed $removed_count deprecated items"
else
    echo "✨ Already clean! No deprecated files found"
fi

echo ""
echo "📂 Current UPack v2.0.0 structure:"
echo "├── setup.sh              # Main entry point"
echo "├── bin/upack             # Intelligent CLI"  
echo "├── install/core/         # Automated setup scripts"
echo "├── install/apps/         # Individual app installers"
echo "├── install/languages/    # Language installers (CLI)"
echo "├── config/               # Configuration files"
echo "├── assets/               # Icons, fonts, wallpapers"
echo "├── utils/                # Utility functions"
echo "└── docs/                 # Documentation"
echo ""
echo "Ready for UPack v2.0.0! 🚀"
