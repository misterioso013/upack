#!/bin/bash

# Install Development Tools - Essential development utilities and CLI tools
# Complements the main dev-languages script with useful development tools

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

# Install modern CLI tools (replacements for traditional Unix tools)
install_modern_cli_tools() {
    log_step "Installing modern CLI tools"
    
    # Install via cargo if Rust is available
    if command -v cargo &> /dev/null; then
        log_info "Installing tools via Cargo (Rust)"
        cargo install \
            ripgrep \
            fd-find \
            bat \
            exa \
            starship \
            bottom \
            procs \
            du-dust \
            tokei \
            hyperfine \
            gitui \
            zoxide
    else
        # Fallback to apt installations
        log_info "Installing available tools via apt"
        sudo apt update
        sudo apt install -y ripgrep fd-find bat
        
        # Install exa via wget (if not available via cargo)
        if ! command -v exa &> /dev/null; then
            EXA_VERSION=$(curl -s "https://api.github.com/repos/ogham/exa/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
            wget -O /tmp/exa.zip "https://github.com/ogham/exa/releases/download/${EXA_VERSION}/exa-linux-x86_64-${EXA_VERSION}.zip"
            unzip -o /tmp/exa.zip -d /tmp
            sudo mv /tmp/bin/exa /usr/local/bin/
            sudo mv /tmp/man/exa.1 /usr/local/share/man/man1/ 2>/dev/null || true
            sudo mv /tmp/completions/exa.bash /etc/bash_completion.d/ 2>/dev/null || true
            rm -rf /tmp/exa.zip /tmp/bin /tmp/man /tmp/completions
        fi
    fi
    
    log_success "Modern CLI tools installed"
}

# Install database tools
install_database_tools() {
    log_step "Installing database tools"
    
    # Install database clients
    sudo apt update
    sudo apt install -y \
        sqlite3 \
        postgresql-client \
        mysql-client \
        redis-tools \
        mongodb-clients
    
    # Install pgcli and mycli for better database interaction
    if command -v pip3 &> /dev/null; then
        pip3 install --user pgcli mycli litecli
    fi
    
    log_success "Database tools installed"
}

# Install container and orchestration tools
install_container_tools() {
    log_step "Installing container and orchestration tools"
    
    # Docker (if not already installed)
    if ! command -v docker &> /dev/null; then
        log_info "Installing Docker"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
    fi
    
    # Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        log_info "Installing Docker Compose"
        DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
        sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
    
    # Kubectl
    if ! command -v kubectl &> /dev/null; then
        log_info "Installing kubectl"
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install kubectl /usr/local/bin/kubectl
        rm kubectl
    fi
    
    # Helm
    if ! command -v helm &> /dev/null; then
        log_info "Installing Helm"
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    fi
    
    log_success "Container and orchestration tools installed"
}

# Install cloud CLI tools
install_cloud_tools() {
    log_step "Installing cloud CLI tools"
    
    # AWS CLI
    if ! command -v aws &> /dev/null; then
        log_info "Installing AWS CLI"
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
        rm -rf aws awscliv2.zip
    fi
    
    # Google Cloud SDK
    if ! command -v gcloud &> /dev/null; then
        log_info "Installing Google Cloud SDK"
        curl https://sdk.cloud.google.com | bash
        source ~/.bashrc
    fi
    
    # Azure CLI
    if ! command -v az &> /dev/null; then
        log_info "Installing Azure CLI"
        curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    fi
    
    # Terraform
    if ! command -v terraform &> /dev/null; then
        log_info "Installing Terraform"
        TERRAFORM_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | sed 's/v//')
        wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
        unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
        sudo mv terraform /usr/local/bin/
        rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
    fi
    
    log_success "Cloud CLI tools installed"
}

# Install API and networking tools
install_api_tools() {
    log_step "Installing API and networking tools"
    
    sudo apt update
    sudo apt install -y \
        curl \
        wget \
        httpie \
        jq \
        yq \
        nmap \
        netcat \
        telnet \
        dig \
        whois
    
    # Install httpie and other tools via pip if available
    if command -v pip3 &> /dev/null; then
        pip3 install --user httpie requests-toolbelt
    fi
    
    # Install Postman (if GUI is available)
    if [ "$XDG_CURRENT_DESKTOP" ]; then
        if ! command -v postman &> /dev/null; then
            log_info "Installing Postman"
            wget -O /tmp/postman.tar.gz https://dl.pstmn.io/download/latest/linux64
            sudo tar -xzf /tmp/postman.tar.gz -C /opt/
            sudo ln -sf /opt/Postman/Postman /usr/local/bin/postman
            rm /tmp/postman.tar.gz
        fi
    fi
    
    log_success "API and networking tools installed"
}

# Install text editors and IDEs
install_editors() {
    log_step "Installing text editors and development environments"
    
    # Neovim (modern Vim)
    if ! command -v nvim &> /dev/null; then
        sudo apt update
        sudo apt install -y neovim
    fi
    
    # Micro (modern nano alternative)
    if ! command -v micro &> /dev/null; then
        curl https://getmic.ro | bash
        sudo mv micro /usr/local/bin/
    fi
    
    # Helix (modern text editor)
    if ! command -v hx &> /dev/null; then
        sudo add-apt-repository ppa:maveonair/helix-editor -y
        sudo apt update
        sudo apt install -y helix
    fi
    
    log_success "Text editors installed"
}

# Install development utilities
install_dev_utilities() {
    log_step "Installing development utilities"
    
    sudo apt update
    sudo apt install -y \
        tree \
        htop \
        tmux \
        screen \
        unzip \
        zip \
        p7zip-full \
        rsync \
        ssh \
        git-lfs \
        meld \
        shellcheck \
        pandoc \
        imagemagick \
        ffmpeg
    
    # Install GitHub CLI
    if ! command -v gh &> /dev/null; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install -y gh
    fi
    
    log_success "Development utilities installed"
}

# Configure shell with useful aliases
setup_shell_aliases() {
    log_step "Setting up useful shell aliases"
    
    # Create aliases file
    local aliases_file="$HOME/.bash_aliases"
    
    cat >> "$aliases_file" << 'EOF'

# UPack Development Aliases
# Modern CLI tool replacements
if command -v exa &> /dev/null; then
    alias ls='exa --group-directories-first'
    alias ll='exa -la --group-directories-first'
    alias la='exa -a --group-directories-first'
    alias lt='exa --tree --level=2'
fi

if command -v bat &> /dev/null; then
    alias cat='bat --paging=never'
    alias less='bat'
fi

if command -v fd &> /dev/null; then
    alias find='fd'
fi

if command -v rg &> /dev/null; then
    alias grep='rg'
fi

if command -v bottom &> /dev/null; then
    alias top='btm'
fi

if command -v procs &> /dev/null; then
    alias ps='procs'
fi

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias glog='git log --oneline --graph --decorate'

# Docker aliases
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'

# Development shortcuts
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias json='python3 -m json.tool'

EOF
    
    # Source aliases in bashrc if not already done
    if ! grep -q "bash_aliases" ~/.bashrc; then
        echo "" >> ~/.bashrc
        echo "# Load custom aliases" >> ~/.bashrc
        echo "if [ -f ~/.bash_aliases ]; then" >> ~/.bashrc
        echo "    . ~/.bash_aliases" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi
    
    log_success "Shell aliases configured"
}

# Main installation function
install_dev_tools() {
    log_step "Installing development tools and utilities"
    log_info "This will install essential development tools and modern CLI utilities"
    
    # Show available tool categories
    echo ""
    echo "📋 Available tool categories:"
    echo "   • modern-cli - Modern CLI tools (ripgrep, bat, exa, etc.)"
    echo "   • database - Database clients and tools"
    echo "   • containers - Docker, kubectl, helm"
    echo "   • cloud - AWS, GCP, Azure CLI tools"
    echo "   • api-tools - HTTP clients, networking tools"
    echo "   • editors - Neovim, micro, helix"
    echo "   • utilities - General development utilities"
    echo "   • aliases - Useful shell aliases"
    echo ""
    
    # Select tool categories to install
    if command -v gum &>/dev/null; then
        CATEGORIES=$(gum choose --no-limit \
            "modern-cli" "database" "containers" "cloud" "api-tools" \
            "editors" "utilities" "aliases")
    else
        echo "Select tool categories to install (separate with spaces):"
        echo "Options: modern-cli database containers cloud api-tools editors utilities aliases"
        echo -n "Your choice: "
        read -r CATEGORIES
    fi
    
    # Install selected categories
    for category in $CATEGORIES; do
        case $category in
            "modern-cli") install_modern_cli_tools ;;
            "database") install_database_tools ;;
            "containers") install_container_tools ;;
            "cloud") install_cloud_tools ;;
            "api-tools") install_api_tools ;;
            "editors") install_editors ;;
            "utilities") install_dev_utilities ;;
            "aliases") setup_shell_aliases ;;
            *) log_warning "Unknown category: $category" ;;
        esac
    done
    
    echo ""
    log_success "Development tools installation completed!"
    echo ""
    echo "📝 Next steps:"
    echo "   • Restart your terminal or run: source ~/.bashrc"
    echo "   • For Docker: Log out and back in to use docker without sudo"
    echo "   • Configure cloud CLIs: aws configure, gcloud init, az login"
    echo "   • Try modern commands: exa, bat, rg, fd"
    echo ""
}

# Run the installation
install_dev_tools
