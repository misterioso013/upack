#!/bin/bash

# React Native Development Environment Setup
# Configures the complete environment for React Native development on Linux
# Based on: https://reactnative.dev/docs/set-up-your-environment?platform=android&os=linux

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
JAVA_VERSION="17"
ANDROID_SDK_VERSION="35"
ANDROID_BUILD_TOOLS_VERSION="35.0.0"
ANDROID_HOME="$HOME/Android/Sdk"

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Node.js is installed
check_node_installed() {
    if command_exists node && command_exists npm; then
        local node_version=$(node --version 2>/dev/null || echo "0.0.0")
        local major_version=$(echo "$node_version" | cut -d'.' -f1 | tr -d 'v')
        
        if [ "$major_version" -ge 18 ]; then
            show_info "Node.js $node_version is installed"
            return 0
        else
            show_warning "Node.js $node_version is too old (required >= 18.x)"
            return 1
        fi
    else
        show_warning "Node.js is not installed"
        return 1
    fi
}

# Check if Java is installed
check_java_installed() {
    if command_exists java && command_exists javac; then
        local java_version=$(java -version 2>&1 | head -n1 | cut -d'"' -f2 | cut -d'.' -f1)
        if [ "$java_version" = "17" ] || [ "$java_version" = "1.8" ]; then
            show_info "Java $java_version is installed"
            return 0
        else
            show_warning "Java version is incorrect. Required JDK 17 or 8"
            return 1
        fi
    else
        show_warning "Java JDK is not installed"
        return 1
    fi
}

# Check if Android Studio is installed
check_android_studio_installed() {
    if [ -d "$HOME/.local/opt/android-studio" ] && [ -f "$HOME/.local/opt/android-studio/bin/studio.sh" ]; then
        show_info "Android Studio is installed"
        return 0
    else
        show_warning "Android Studio is not installed"
        return 1
    fi
}

# Install Node.js if not available
install_node() {
    if ! check_node_installed; then
        show_step "Installing Node.js..."
        if [ -f "$SCRIPT_DIR/../languages/node.sh" ]; then
            bash "$SCRIPT_DIR/../languages/node.sh"
        else
            show_error "Node.js installation script not found"
            show_info "Run: upack install node"
            return 1
        fi
    fi
}

# Install Java JDK
install_java() {
    if ! check_java_installed; then
        show_step "Installing OpenJDK $JAVA_VERSION..."
        
        sudo apt update
        sudo apt install -y openjdk-${JAVA_VERSION}-jdk
        
        # Configure JAVA_HOME
        local java_home="/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64"
        
        # Add to bashrc
        if ! grep -q "JAVA_HOME" "$HOME/.bashrc"; then
            cat >> "$HOME/.bashrc" << EOF

# Java JDK
export JAVA_HOME="$java_home"
export PATH="\$PATH:\$JAVA_HOME/bin"
EOF
        fi
        
        # Add to zshrc if exists
        if [ -f "$HOME/.zshrc" ]; then
            if ! grep -q "JAVA_HOME" "$HOME/.zshrc"; then
                cat >> "$HOME/.zshrc" << EOF

# Java JDK
export JAVA_HOME="$java_home"
export PATH="\$PATH:\$JAVA_HOME/bin"
EOF
            fi
        fi
        
        # Set for current session
        export JAVA_HOME="$java_home"
        export PATH="$PATH:$JAVA_HOME/bin"
        
        show_success "OpenJDK $JAVA_VERSION installed and JAVA_HOME configured"
    fi
}

# Install Android Studio
install_android_studio() {
    if ! check_android_studio_installed; then
        show_step "Installing Android Studio..."
        if [ -f "$SCRIPT_DIR/android-studio.sh" ]; then
            bash "$SCRIPT_DIR/android-studio.sh"
        else
            show_error "Android Studio installation script not found"
            show_info "Run: upack install android-studio"
            return 1
        fi
    fi
}

# Configure Android SDK
configure_android_sdk() {
    show_step "Configuring Android SDK..."
    
    # Create Android SDK directory
    mkdir -p "$ANDROID_HOME"
    
    # Configure ANDROID_HOME environment
    if ! grep -q "ANDROID_HOME" "$HOME/.bashrc"; then
        cat >> "$HOME/.bashrc" << EOF

# Android SDK
export ANDROID_HOME="$ANDROID_HOME"
export PATH="\$PATH:\$ANDROID_HOME/emulator"
export PATH="\$PATH:\$ANDROID_HOME/platform-tools"
export PATH="\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="\$PATH:\$ANDROID_HOME/tools/bin"
EOF
    fi
    
    # Add to zshrc if exists
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "ANDROID_HOME" "$HOME/.zshrc"; then
            cat >> "$HOME/.zshrc" << EOF

# Android SDK
export ANDROID_HOME="$ANDROID_HOME"
export PATH="\$PATH:\$ANDROID_HOME/emulator"
export PATH="\$PATH:\$ANDROID_HOME/platform-tools"
export PATH="\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="\$PATH:\$ANDROID_HOME/tools/bin"
EOF
        fi
    fi
    
    # Set for current session
    export ANDROID_HOME="$ANDROID_HOME"
    export PATH="$PATH:$ANDROID_HOME/emulator"
    export PATH="$PATH:$ANDROID_HOME/platform-tools"
    export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
    export PATH="$PATH:$ANDROID_HOME/tools/bin"
    
    show_success "Variáveis de ambiente do Android SDK configuradas"
}

# Install Android SDK Command Line Tools
install_android_cmdline_tools() {
    show_step "Installing Android SDK Command Line Tools..."
    
    local cmdline_tools_url="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
    local temp_dir="/tmp/android-cmdline-tools"
    
    # Create temp directory
    mkdir -p "$temp_dir"
    cd "$temp_dir"
    
    # Download command line tools
    if ! wget -O cmdtools.zip "$cmdline_tools_url"; then
        show_error "Failed to download Android Command Line Tools"
        return 1
    fi
    
    # Extract tools
    unzip -q cmdtools.zip
    
    # Create cmdline-tools directory structure
    mkdir -p "$ANDROID_HOME/cmdline-tools/latest"
    mv cmdline-tools/* "$ANDROID_HOME/cmdline-tools/latest/"
    
    # Cleanup
    cd - > /dev/null
    rm -rf "$temp_dir"

    show_success "Android SDK Command Line Tools installed"
}

# Install Android SDK packages
install_android_sdk_packages() {
    show_step "Installing Android SDK packages..."
    
    # Ensure cmdline tools are in path
    local sdkmanager="$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager"
    
    if [ ! -f "$sdkmanager" ]; then
        show_error "sdkmanager não encontrado"
        return 1
    fi
    
    # Accept licenses
    yes | "$sdkmanager" --licenses > /dev/null 2>&1 || true
    
    # Install essential packages
    "$sdkmanager" \
        "platform-tools" \
        "platforms;android-${ANDROID_SDK_VERSION}" \
        "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
        "system-images;android-${ANDROID_SDK_VERSION};google_apis;x86_64" \
        "emulator" \
        "sources;android-${ANDROID_SDK_VERSION}"

    show_success "Android SDK packages installed"
}

# Create Android Virtual Device
create_avd() {
    show_step "Creating Android Virtual Device (AVD)..."
    
    local avdmanager="$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager"
    local avd_name="ReactNative_AVD"
    
    if [ ! -f "$avdmanager" ]; then
        show_error "avdmanager not found"
        return 1
    fi
    
    # Check if AVD already exists
    if "$avdmanager" list avd | grep -q "$avd_name"; then
        show_info "AVD '$avd_name' already exists"
        return 0
    fi
    
    # Create AVD
    echo "no" | "$avdmanager" create avd \
        -n "$avd_name" \
        -k "system-images;android-${ANDROID_SDK_VERSION};google_apis;x86_64" \
        -d "pixel_4"

    show_success "AVD '$avd_name' created"
}

# Install React Native CLI
install_react_native_cli() {
    show_step "Installing React Native CLI..."
    
    # Install @react-native-community/cli globally
    if command_exists npm; then
        npm install -g @react-native-community/cli
        show_success "React Native CLI installed globally"
    else
        show_error "npm not found"
        return 1
    fi
}

# Configure development environment
configure_dev_environment() {
    show_step "Configuring development environment..."
    
    # Create React Native workspace directory
    mkdir -p "$HOME/ReactNative"
    
    # Install additional tools
    if command_exists npm; then
        npm install -g flipper react-devtools
        show_success "Development tools installed"
    fi
}

# Show final instructions
show_final_instructions() {
    show_success "React Native environment configured successfully!"
    echo ""
    show_info "🎯 Next steps:"
    echo ""
    echo "  1. RESTART the terminal or run:"
    echo "     source ~/.bashrc"
    echo ""
    echo "  2. Check the installation:"
    echo "     npx react-native doctor"
    echo ""
    echo "  3. Create a new project:"
    echo "     npx react-native@latest init MeuApp"
    echo "     cd MeuApp"
    echo ""
    echo "  4. Run the project:"
    echo "     npx react-native run-android"
    echo ""
    show_info "🔧 Installed tools:"
    echo "  • Node.js (via NVM)"
    echo "  • Java JDK $JAVA_VERSION"
    echo "  • Android Studio"
    echo "  • Android SDK $ANDROID_SDK_VERSION"
    echo "  • Android Build Tools $ANDROID_BUILD_TOOLS_VERSION"
    echo "  • Android Virtual Device"
    echo "  • React Native CLI"
    echo ""
    show_info "📱 To use a physical device:"
    echo "  1. Enable 'Developer Mode' in settings"
    echo "  2. Enable 'USB Debugging'"
    echo "  3. Connect via USB and run: adb devices"
    echo ""
    show_info "🚀 Useful commands:"
    echo "  • upack status          - Check installations"
    echo "  • android-studio        - Open Android Studio"
    echo "  • emulator -list-avds   - List available AVDs"
    echo "  • adb devices           - List connected devices"
    echo ""
}

# Main installation function
main() {
    show_step "Starting React Native environment setup..."
    echo ""
    
    # Install dependencies in order
    install_node
    echo ""
    
    install_java
    echo ""
    
    install_android_studio
    echo ""
    
    configure_android_sdk
    echo ""
    
    install_android_cmdline_tools
    echo ""
    
    install_android_sdk_packages
    echo ""
    
    create_avd
    echo ""
    
    install_react_native_cli
    echo ""
    
    configure_dev_environment
    echo ""
    
    show_final_instructions
}

# Run main function
main "$@"