#!/bin/bash

# Android Studio Installation Script
# Installs Android Studio for Android and React Native development
# Based on: https://developer.android.com/studio

set -e

# Import common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../core/common-functions.sh" 2>/dev/null || {
    # Fallback log functions
    show_step() { echo "🔄 $1"; }
    show_info() { echo "ℹ️  $1"; }
    show_success() { echo "✅ $1"; }
    show_error() { echo "❌ $1"; }
    show_warning() { echo "⚠️  $1"; }
}

# Configuration
ANDROID_STUDIO_VERSION="2025.1.3.7"
ANDROID_STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${ANDROID_STUDIO_VERSION}/android-studio-${ANDROID_STUDIO_VERSION}-linux.tar.gz"
INSTALL_DIR="$HOME/.local/opt"
ANDROID_STUDIO_DIR="$INSTALL_DIR/android-studio"
APPLICATIONS_DIR="$HOME/.local/share/applications"

# Check if Android Studio is already installed
check_android_studio_installed() {
    [ -d "$ANDROID_STUDIO_DIR" ] && [ -f "$ANDROID_STUDIO_DIR/bin/studio.sh" ]
}

# Install dependencies
install_dependencies() {
    show_step "Installing Android Studio dependencies..."
    
    sudo apt update
    # sudo apt install -y \
    #     libc6:i386 \
    #     libncurses5:i386 \
    #     libstdc++6:i386 \
    #     lib32z1 \
    #     libbz2-1.0:i386 \
    #     libxrender1 \
    #     libxtst6 \
    #     libxi6 \
    #     libfreetype6 \
    #     libxft2 \
    #     wget \
    #     unzip \
    #     default-jdk

    show_success "Dependencies installed"
}

# Download and install Android Studio
install_android_studio() {
    show_step "Downloading Android Studio ${ANDROID_STUDIO_VERSION}..."
    
    # Create installation directory
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    
    # Download Android Studio
    if ! wget -O android-studio.tar.gz "$ANDROID_STUDIO_URL"; then
        show_error "Failed to download Android Studio"
        return 1
    fi

    show_step "Extracting Android Studio..."
    tar -xzf android-studio.tar.gz
    rm android-studio.tar.gz

    show_success "Android Studio extracted to $ANDROID_STUDIO_DIR"
}

# Create desktop entry
create_desktop_entry() {
    show_step "Creating application menu entry..."
    
    mkdir -p "$APPLICATIONS_DIR"
    
    cat > "$APPLICATIONS_DIR/android-studio.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Android Studio
Comment=The Drive to Develop
Exec="$ANDROID_STUDIO_DIR/bin/studio.sh" %f
Icon=$ANDROID_STUDIO_DIR/bin/studio.png
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-studio
StartupNotify=true
NoDisplay=false
Keywords=android;development;studio;ide;jetbrains;
EOF
    
    chmod +x "$APPLICATIONS_DIR/android-studio.desktop"
    show_success "Application menu entry created"
}

# Add to PATH
add_to_path() {
    show_step "Adding Android Studio to PATH..."
    
    # Add to bashrc
    if ! grep -q "ANDROID_STUDIO_HOME" "$HOME/.bashrc"; then
        cat >> "$HOME/.bashrc" << EOF

# Android Studio
export ANDROID_STUDIO_HOME="$ANDROID_STUDIO_DIR"
export PATH="\$PATH:\$ANDROID_STUDIO_HOME/bin"
EOF
    fi
    
    # Add to zshrc if exists
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "ANDROID_STUDIO_HOME" "$HOME/.zshrc"; then
            cat >> "$HOME/.zshrc" << EOF

# Android Studio
export ANDROID_STUDIO_HOME="$ANDROID_STUDIO_DIR"
export PATH="\$PATH:\$ANDROID_STUDIO_HOME/bin"
EOF
        fi
    fi

    show_success "Android Studio added to PATH"
}

# Show post-installation instructions
show_instructions() {
    show_success "Android Studio installed successfully!"
    echo ""
    show_info "Next steps:"
    echo "  1. Restart the terminal or run: source ~/.bashrc"
    echo "  2. Run: android-studio or search for 'Android Studio' in the menu"
    echo "  3. During the first run, install the Android SDK"
    echo "  4. Configure the ANDROID_HOME environment variable if needed"
    echo ""
    show_info "For React Native development:"
    echo "  • Run: upack install react-native"
    echo "  • Or manually configure the Android environment"
    echo ""
    show_info "Installation locations:"
    echo "  • Android Studio: $ANDROID_STUDIO_DIR"
    echo "  • Command: $ANDROID_STUDIO_DIR/bin/studio.sh"
}

# Main installation function
main() {
    show_step "Checking Android Studio installation..."
    
    if check_android_studio_installed; then
        show_info "Android Studio is already installed at $ANDROID_STUDIO_DIR"
        show_info "To reinstall, remove the directory and run again"
        return 0
    fi

    show_step "Starting Android Studio installation..."

    install_dependencies
    install_android_studio
    create_desktop_entry
    add_to_path
    show_instructions

    show_success "Android Studio installation completed!"
}

# Run main function
main "$@"