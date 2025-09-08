#!/bin/bash

# UPack Setup Validator
# Validates that all components are correctly configured

echo "🔍 UPack Setup Validator"
echo "Checking setup.sh configuration..."
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Test 1: Syntax validation
echo "1. Testing setup.sh syntax..."
if bash -n setup.sh; then
    echo "   ✅ Syntax valid"
else
    echo "   ❌ Syntax errors found"
    exit 1
fi

# Test 2: Required scripts exist
echo "2. Checking required scripts..."
missing_scripts=0

scripts=(
    "install/core/dependencies.sh"
    "install/core/essential-apps.sh" 
    "install/core/theme-setup.sh"
    "install/core/gnome-config.sh"
    "install/core/terminal-setup.sh"
    "install/core/fonts-install.sh"
    "install/core/cli-install.sh"
    "install/core/infrastructure.sh"
    "install/core/apps-install.sh"
)

for script in "${scripts[@]}"; do
    if [ -f "$script" ]; then
        echo "   ✅ $script"
    else
        echo "   ❌ Missing: $script"
        ((missing_scripts++))
    fi
done

if [ $missing_scripts -gt 0 ]; then
    echo "   ❌ $missing_scripts scripts missing"
    exit 1
fi

# Test 3: Script permissions
echo "3. Checking script permissions..."
non_executable=0

for script in "${scripts[@]}"; do
    if [ -x "$script" ]; then
        echo "   ✅ Executable: $(basename "$script")"
    else
        echo "   ❌ Not executable: $script"
        ((non_executable++))
    fi
done

if [ $non_executable -gt 0 ]; then
    echo "   ❌ $non_executable scripts not executable"
    exit 1
fi

# Test 4: Common functions
echo "4. Testing common functions..."
if source install/core/common-functions.sh 2>/dev/null; then
    echo "   ✅ common-functions.sh loads correctly"
else
    echo "   ❌ Error loading common-functions.sh"
    exit 1
fi

# Test 5: CLI exists
echo "5. Checking UPack CLI..."
if [ -f "bin/upack" ]; then
    echo "   ✅ CLI binary exists"
    if [ -x "bin/upack" ]; then
        echo "   ✅ CLI is executable"
    else
        echo "   ❌ CLI not executable"
        exit 1
    fi
else
    echo "   ❌ CLI binary missing"
    exit 1
fi

echo ""
echo "🎉 All validation tests passed!"
echo "✅ UPack setup is ready to run"
echo ""
echo "To start setup: ./setup.sh"
