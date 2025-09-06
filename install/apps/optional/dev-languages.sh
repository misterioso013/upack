#!/bin/bash

# Install Development Languages - Essential programming languages and tools
# Installs Node.js (via nvm), Rust, Python, Java, Go, PHP and other popular languages

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
    log_warning() { echo "⚠️  $1"; }
fi

# Install mise for language version management
install_mise() {
    if command -v mise &> /dev/null; then
        log_info "mise already installed"
        return 0
    fi
    
    log_step "Installing mise (universal language version manager)"
    
    # Install dependencies
    sudo apt update -y && sudo apt install -y gpg wget curl
    sudo install -dm 755 /etc/apt/keyrings
    
    # Add mise repository
    wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1>/dev/null
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
    
    # Install mise
    sudo apt update && sudo apt install -y mise
    
    # Add mise to shell profile
    if ! grep -q 'mise activate' ~/.bashrc; then
        echo 'eval "$(mise activate bash)"' >> ~/.bashrc
    fi
    
    # Activate mise for current session
    eval "$(mise activate bash)"
    
    log_success "mise installed successfully"
}

# Install Node.js via NVM (Node Version Manager)
install_nodejs() {
    log_step "Installing Node.js via NVM"
    
    # Check if nvm is already installed
    if [ -s "$HOME/.nvm/nvm.sh" ]; then
        log_info "NVM already installed"
        source "$HOME/.nvm/nvm.sh"
        source "$HOME/.nvm/bash_completion"
    else
        # Install NVM
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        
        # Add NVM to bash profile if not already added
        if ! grep -q 'NVM_DIR' ~/.bashrc; then
            {
                echo 'export NVM_DIR="$HOME/.nvm"'
                echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
                echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'
            } >> ~/.bashrc
        fi
        
        # Source NVM for current session
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    fi
    
    # Install latest LTS Node.js
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
    
    # Install popular global packages
    npm install -g yarn pnpm @vue/cli @angular/cli create-react-app typescript ts-node nodemon
    
    log_success "Node.js $(node --version) installed with npm $(npm --version), yarn, and pnpm"
}

# Install Rust via rustup
install_rust() {
    log_step "Installing Rust via rustup"
    
    if command -v rustc &> /dev/null; then
        log_info "Rust already installed: $(rustc --version)"
        return 0
    fi
    
    # Install Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    
    # Add cargo to PATH for current session
    source "$HOME/.cargo/env"
    
    # Add to bash profile if not already added
    if ! grep -q 'cargo/env' ~/.bashrc; then
        echo 'source "$HOME/.cargo/env"' >> ~/.bashrc
    fi
    
    # Install popular Rust tools
    cargo install ripgrep fd-find bat exa starship bottom
    
    log_success "Rust $(rustc --version) installed with cargo and popular tools"
}

# Install Python (system + pip + pipx)
install_python() {
    log_step "Installing Python development environment"
    
    # Install Python and pip via apt
    sudo apt update && sudo apt install -y python3 python3-pip python3-venv python3-dev build-essential
    
    # Install pipx for global Python apps
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
    
    # Add pipx to PATH for current session
    export PATH="$PATH:$HOME/.local/bin"
    
    # Install popular Python tools via pipx
    pipx install poetry
    pipx install black
    pipx install flake8
    pipx install mypy
    pipx install pytest
    pipx install jupyter
    pipx install cookiecutter
    
    log_success "Python $(python3 --version) installed with pip, pipx, and development tools"
}

# Install Java (OpenJDK + Maven + Gradle)
install_java() {
    log_step "Installing Java development environment"
    
    # Install OpenJDK 17 (LTS) and development tools
    sudo apt update && sudo apt install -y openjdk-17-jdk openjdk-17-jre maven gradle
    
    # Set JAVA_HOME if not already set
    if ! grep -q 'JAVA_HOME' ~/.bashrc; then
        {
            echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64'
            echo 'export PATH=$PATH:$JAVA_HOME/bin'
        } >> ~/.bashrc
    fi
    
    # Set for current session
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
    export PATH=$PATH:$JAVA_HOME/bin
    
    log_success "Java $(java --version | head -n1) installed with Maven and Gradle"
}

# Install Go
install_go() {
    log_step "Installing Go programming language"
    
    if command -v go &> /dev/null; then
        log_info "Go already installed: $(go version)"
        return 0
    fi
    
    # Get the latest Go version
    GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n1)
    
    # Download and install Go
    wget -q "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz" -O "/tmp/${GO_VERSION}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "/tmp/${GO_VERSION}.linux-amd64.tar.gz"
    rm "/tmp/${GO_VERSION}.linux-amd64.tar.gz"
    
    # Add Go to PATH
    if ! grep -q '/usr/local/go/bin' ~/.bashrc; then
        {
            echo 'export PATH=$PATH:/usr/local/go/bin'
            echo 'export GOPATH=$HOME/go'
            echo 'export PATH=$PATH:$GOPATH/bin'
        } >> ~/.bashrc
    fi
    
    # Set for current session
    export PATH=$PATH:/usr/local/go/bin
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    
    log_success "Go $(go version | cut -d' ' -f3) installed"
}

# Install PHP
install_php() {
    log_step "Installing PHP development environment"
    
    # Install PHP and common extensions
    sudo apt update && sudo apt install -y php php-cli php-fpm php-json php-common php-mysql \
        php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-dev
    
    # Install Composer
    if ! command -v composer &> /dev/null; then
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
        sudo chmod +x /usr/local/bin/composer
    fi
    
    log_success "PHP $(php --version | head -n1) installed with Composer"
}

# Install C/C++ development tools
install_cpp() {
    log_step "Installing C/C++ development environment"
    
    # Install build essentials and CMake
    sudo apt update && sudo apt install -y build-essential gcc g++ gdb cmake make ninja-build
    
    # Install clang and LLVM
    sudo apt install -y clang lldb lld
    
    log_success "C/C++ development tools installed (GCC $(gcc --version | head -n1 | cut -d')' -f2))"
}

# Install .NET
install_dotnet() {
    log_step "Installing .NET development environment"
    
    # Add Microsoft package repository
    wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    
    # Install .NET SDK
    sudo apt update && sudo apt install -y dotnet-sdk-8.0
    
    log_success ".NET $(dotnet --version) installed"
}

# Install Ruby via rbenv
install_ruby() {
    log_step "Installing Ruby via rbenv"
    
    if [ -d "$HOME/.rbenv" ]; then
        log_info "rbenv already installed"
        return 0
    fi
    
    # Install dependencies
    sudo apt update && sudo apt install -y git curl libssl-dev libreadline-dev zlib1g-dev \
        autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev \
        libffi-dev libgdbm-dev
    
    # Install rbenv
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    
    # Install ruby-build
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    
    # Add rbenv to PATH
    if ! grep -q 'rbenv init' ~/.bashrc; then
        {
            echo 'export PATH="$HOME/.rbenv/bin:$PATH"'
            echo 'eval "$(rbenv init -)"'
        } >> ~/.bashrc
    fi
    
    # Set for current session
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    
    # Install latest stable Ruby
    RUBY_VERSION=$(rbenv install -l | grep -v - | tail -1 | xargs)
    rbenv install "$RUBY_VERSION"
    rbenv global "$RUBY_VERSION"
    
    # Install bundler
    gem install bundler
    
    log_success "Ruby $(ruby --version) installed with rbenv and bundler"
}

# Install Zig
install_zig() {
    log_step "Installing Zig programming language"
    
    if command -v zig &> /dev/null; then
        log_info "Zig already installed: $(zig version)"
        return 0
    fi
    
    # Get latest Zig version
    ZIG_VERSION=$(curl -s https://api.github.com/repos/ziglang/zig/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    
    # Download and install Zig
    wget -q "https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz" -O "/tmp/zig.tar.xz"
    tar -xf "/tmp/zig.tar.xz" -C /tmp
    sudo mv "/tmp/zig-linux-x86_64-${ZIG_VERSION}" /opt/zig
    sudo ln -sf /opt/zig/zig /usr/local/bin/zig
    rm "/tmp/zig.tar.xz"
    
    log_success "Zig $(zig version) installed"
}

# Install Deno
install_deno() {
    log_step "Installing Deno runtime"
    
    if command -v deno &> /dev/null; then
        log_info "Deno already installed: $(deno --version | head -n1)"
        return 0
    fi
    
    # Install Deno
    curl -fsSL https://deno.land/install.sh | sh
    
    # Add to PATH
    if ! grep -q 'deno/bin' ~/.bashrc; then
        echo 'export PATH="$HOME/.deno/bin:$PATH"' >> ~/.bashrc
    fi
    
    # Set for current session
    export PATH="$HOME/.deno/bin:$PATH"
    
    log_success "Deno $(deno --version | head -n1) installed"
}

# Main installation function
install_dev_languages() {
    log_step "Installing development languages and tools"
    log_info "This will install popular programming languages using their recommended installers"
    
    # Show available languages
    echo ""
    echo "📋 Available languages and tools:"
    echo "   • mise - Universal language version manager"
    echo "   • Node.js - JavaScript runtime (via NVM)"
    echo "   • Rust - Systems programming language (via rustup)"
    echo "   • Python - Development environment with pipx"
    echo "   • Java - OpenJDK 17 with Maven and Gradle"
    echo "   • Go - Google's programming language"
    echo "   • PHP - Web development with Composer"
    echo "   • C/C++ - Build tools and compilers"
    echo "   • .NET - Microsoft's development platform"
    echo "   • Ruby - Dynamic programming language (via rbenv)"
    echo "   • Zig - Modern systems programming language"
    echo "   • Deno - Secure JavaScript/TypeScript runtime"
    echo ""
    
    # Select languages to install
    if command -v gum &>/dev/null; then
        LANGUAGES=$(gum choose --no-limit \
            "mise" "nodejs" "rust" "python" "java" "go" "php" \
            "cpp" "dotnet" "ruby" "zig" "deno")
    else
        echo "Select languages to install (separate with spaces):"
        echo "Options: mise nodejs rust python java go php cpp dotnet ruby zig deno"
        echo -n "Your choice: "
        read -r LANGUAGES
    fi
    
    # Install selected languages
    for lang in $LANGUAGES; do
        case $lang in
            "mise") install_mise ;;
            "nodejs") install_nodejs ;;
            "rust") install_rust ;;
            "python") install_python ;;
            "java") install_java ;;
            "go") install_go ;;
            "php") install_php ;;
            "cpp") install_cpp ;;
            "dotnet") install_dotnet ;;
            "ruby") install_ruby ;;
            "zig") install_zig ;;
            "deno") install_deno ;;
            *) log_warning "Unknown language: $lang" ;;
        esac
    done
    
    echo ""
    log_success "Development languages installation completed!"
    echo ""
    echo "📝 Next steps:"
    echo "   • Restart your terminal or run: source ~/.bashrc"
    echo "   • Use 'mise use <language>@<version>' for version management"
    echo "   • Check installed versions:"
    echo "     - node --version && npm --version"
    echo "     - rustc --version && cargo --version"
    echo "     - python3 --version && pip3 --version"
    echo "     - java --version && mvn --version"
    echo "     - go version"
    echo "     - php --version && composer --version"
    echo ""
}

# Run the installation
install_dev_languages
