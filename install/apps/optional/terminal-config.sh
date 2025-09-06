#!/bin/bash

# Configure elegant terminal themes and settings
# Supports GNOME Terminal, Alacritty, and other popular terminals

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

install_terminal_configs() {
    log_step "Configuring elegant terminal settings"
    
    # Configure GNOME Terminal if available
    if command -v gnome-terminal &> /dev/null; then
        configure_gnome_terminal
    fi
    
    # Install and configure Alacritty (modern GPU-accelerated terminal)
    configure_alacritty
    
    # Configure Zsh with Oh My Zsh for better shell experience
    configure_zsh
    
    # Configure terminal fonts
    configure_terminal_fonts
    
    log_success "Terminal configuration completed!"
    log_info "Restart your terminal or open a new tab to see the changes"
}

configure_gnome_terminal() {
    log_step "Configuring GNOME Terminal"
    
    # Create a new terminal profile for UPack
    local profile_id=$(dconf list /org/gnome/terminal/legacy/profiles:/ | head -n 1 | tr -d '/')
    if [ -z "$profile_id" ]; then
        profile_id=$(uuidgen)
        dconf write /org/gnome/terminal/legacy/profiles:/list "['$profile_id']"
    fi
    
    local profile_path="/org/gnome/terminal/legacy/profiles:/:$profile_id"
    
    # Configure profile settings
    dconf write "$profile_path/visible-name" "'UPack Dark'"
    dconf write "$profile_path/background-color" "'rgb(46,52,64)'"
    dconf write "$profile_path/foreground-color" "'rgb(216,222,233)'"
    dconf write "$profile_path/use-theme-colors" "false"
    dconf write "$profile_path/use-system-font" "false"
    dconf write "$profile_path/font" "'JetBrains Mono 12'"
    dconf write "$profile_path/cursor-shape" "'block'"
    dconf write "$profile_path/cursor-blink-mode" "'on'"
    dconf write "$profile_path/scrollbar-policy" "'never'"
    dconf write "$profile_path/scrollback-unlimited" "true"
    
    # Nord color palette for terminal
    dconf write "$profile_path/palette" "['rgb(46,52,64)', 'rgb(191,97,106)', 'rgb(163,190,140)', 'rgb(235,203,139)', 'rgb(129,161,193)', 'rgb(180,142,173)', 'rgb(136,192,208)', 'rgb(229,233,240)', 'rgb(76,86,106)', 'rgb(191,97,106)', 'rgb(163,190,140)', 'rgb(235,203,139)', 'rgb(129,161,193)', 'rgb(180,142,173)', 'rgb(136,192,208)', 'rgb(236,239,244)']"
    
    # Set as default profile
    dconf write /org/gnome/terminal/legacy/profiles:/default "'$profile_id'"
    
    log_success "GNOME Terminal configured with Nord theme"
}

configure_alacritty() {
    log_step "Installing and configuring Alacritty"
    
    # Install Alacritty
    if ! command -v alacritty &> /dev/null; then
        if sudo apt update && sudo apt install -y alacritty; then
            # Verify installation succeeded
            if command -v alacritty >/dev/null 2>&1; then
                log_success "Alacritty installed via APT"
            else
                log_warning "Alacritty installation completed but binary not found"
                return 1
            fi
        else
            log_warning "Failed to install Alacritty, skipping configuration"
            return 1
        fi
    else
        log_info "Alacritty already installed"
    fi
    
    # Create Alacritty config directory
    mkdir -p "$HOME/.config/alacritty"
    
    # Create Alacritty configuration with Nord theme
    cat > "$HOME/.config/alacritty/alacritty.yml" << 'EOF'
# UPack Elegant Terminal Configuration for Alacritty
# Nord Theme with modern features

window:
  # Window dimensions (changes require restart)
  dimensions:
    columns: 120
    lines: 30
  
  # Window padding (changes require restart)
  padding:
    x: 10
    y: 10
  
  # Spread additional padding evenly around the terminal content
  dynamic_padding: true
  
  # Window decorations
  decorations: full
  
  # Startup Mode (changes require restart)
  startup_mode: Windowed
  
  # Window title
  title: UPack Terminal
  
  # Allow terminal applications to change Alacritty's window title
  dynamic_title: true

scrolling:
  # Maximum number of lines in the scrollback buffer
  history: 10000
  
  # Scrolling distance multiplier
  multiplier: 3

# Font configuration
font:
  # Normal (roman) font face
  normal:
    family: JetBrains Mono
    style: Regular
  
  # Bold font face
  bold:
    family: JetBrains Mono
    style: Bold
  
  # Italic font face
  italic:
    family: JetBrains Mono
    style: Italic
  
  # Bold italic font face
  bold_italic:
    family: JetBrains Mono
    style: Bold Italic
  
  # Point size
  size: 12.0
  
  # Offset is the extra space around each character
  offset:
    x: 0
    y: 0
  
  # Glyph offset determines the locations of the glyphs within their cells
  glyph_offset:
    x: 0
    y: 0

# If true, bold text is drawn using the bright color variants
draw_bold_text_with_bright_colors: false

# Colors (Nord Theme)
colors:
  # Default colors
  primary:
    background: '#2e3440'
    foreground: '#d8dee9'
    dim_foreground: '#a5aaad'
    bright_foreground: '#eceff4'

  # Cursor colors
  cursor:
    text: '#2e3440'
    cursor: '#d8dee9'

  # Vi mode cursor colors
  vi_mode_cursor:
    text: '#2e3440'
    cursor: '#d8dee9'

  # Selection colors
  selection:
    text: CellForeground
    background: '#4c566a'

  # Search colors
  search:
    matches:
      foreground: '#2e3440'
      background: '#88c0d0'
    focused_match:
      foreground: '#2e3440'
      background: '#5e81ac'

  # Normal colors
  normal:
    black:   '#3b4252'
    red:     '#bf616a'
    green:   '#a3be8c'
    yellow:  '#ebcb8b'
    blue:    '#81a1c1'
    magenta: '#b48ead'
    cyan:    '#88c0d0'
    white:   '#e5e9f0'

  # Bright colors
  bright:
    black:   '#4c566a'
    red:     '#bf616a'
    green:   '#a3be8c'
    yellow:  '#ebcb8b'
    blue:    '#81a1c1'
    magenta: '#b48ead'
    cyan:    '#8fbcbb'
    white:   '#eceff4'

  # Dim colors
  dim:
    black:   '#373e4d'
    red:     '#94545d'
    green:   '#809575'
    yellow:  '#b29e75'
    blue:    '#68809a'
    magenta: '#8c738c'
    cyan:    '#6d96a5'
    white:   '#aeb3bb'

# Bell
bell:
  animation: EaseOutExpo
  duration: 0
  color: '#ffffff'

# Background opacity
background_opacity: 0.95

selection:
  semantic_escape_chars: ",│`|:\"' ()[]{}<>\t"
  save_to_clipboard: true

cursor:
  style: Block
  unfocused_hollow: true
  thickness: 0.15

# Live config reload (changes require restart)
live_config_reload: true

# Shell
shell:
  program: /bin/zsh
  args:
    - --login

# Startup directory
working_directory: None

# Send ESC (\x1b) before characters when alt is pressed
alt_send_esc: true

mouse:
  hide_when_typing: true

# Key bindings
key_bindings:
  # (Windows, Linux, and BSD only)
  - { key: V,         mods: Control|Shift, action: Paste                     }
  - { key: C,         mods: Control|Shift, action: Copy                      }
  - { key: Insert,    mods: Shift,         action: PasteSelection            }
  - { key: Key0,      mods: Control,       action: ResetFontSize             }
  - { key: Equals,    mods: Control,       action: IncreaseFontSize          }
  - { key: Plus,      mods: Control,       action: IncreaseFontSize          }
  - { key: Minus,     mods: Control,       action: DecreaseFontSize          }
  - { key: F11,       mods: None,          action: ToggleFullscreen          }
  - { key: Paste,     mods: None,          action: Paste                     }
  - { key: Copy,      mods: None,          action: Copy                      }
  - { key: L,         mods: Control,       action: ClearLogNotice            }
  - { key: L,         mods: Control,       chars: "\x0c"                     }
  - { key: PageUp,    mods: None,          action: ScrollPageUp,   mode: ~Alt }
  - { key: PageDown,  mods: None,          action: ScrollPageDown, mode: ~Alt }
  - { key: Home,      mods: Shift,         action: ScrollToTop,    mode: ~Alt }
  - { key: End,       mods: Shift,         action: ScrollToBottom, mode: ~Alt }

debug:
  render_timer: false
  persistent_logging: false
  log_level: Warn
  print_events: false
EOF
    
    log_success "Alacritty configured with Nord theme and modern features"
}

configure_zsh() {
    log_step "Configuring Zsh with Oh My Zsh"
    
    # Install Zsh if not available
    if ! command -v zsh &> /dev/null; then
        sudo apt update && sudo apt install -y zsh
    fi
    
    # Install Oh My Zsh if not already installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        export RUNZSH=no
        export CHSH=no
        
        # Download installer to temp file with error checking
        local temp_installer="/tmp/oh-my-zsh-install.sh"
        if ! curl -fsSLo "$temp_installer" "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"; then
            log_error "Failed to download Oh My Zsh installer (curl exit code: $?)"
            rm -f "$temp_installer"
            return 1
        fi
        
        # Run installer and check exit status
        if sh "$temp_installer" --unattended; then
            log_success "Oh My Zsh installed successfully"
        else
            local installer_exit_code=$?
            log_error "Oh My Zsh installation failed (installer exit code: $installer_exit_code)"
            rm -f "$temp_installer"
            return 1
        fi
        
        # Cleanup temp file
        rm -f "$temp_installer"
    else
        log_info "Oh My Zsh already installed"
    fi
    
    # Install Powerlevel10k theme
    if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
        log_info "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    fi
    
    # Install useful plugins
    install_zsh_plugins
    
    # Create .zshrc configuration
    create_zshrc_config
    
    log_success "Zsh configured with Oh My Zsh and Powerlevel10k"
    log_info "Run 'chsh -s /bin/zsh' to set Zsh as default shell"
}

install_zsh_plugins() {
    log_info "Installing useful Zsh plugins..."
    
    # zsh-autosuggestions
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        log_info "Installing zsh-autosuggestions..."
        if git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"; then
            log_success "zsh-autosuggestions installed"
        else
            log_error "Failed to clone zsh-autosuggestions from https://github.com/zsh-users/zsh-autosuggestions to $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
            rm -rf "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
            return 1
        fi
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        log_info "Installing zsh-syntax-highlighting..."
        if git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"; then
            log_success "zsh-syntax-highlighting installed"
        else
            log_error "Failed to clone zsh-syntax-highlighting from https://github.com/zsh-users/zsh-syntax-highlighting.git to $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
            rm -rf "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
            return 1
        fi
    fi
    
    # zsh-completions
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
        log_info "Installing zsh-completions..."
        if git clone https://github.com/zsh-users/zsh-completions "$HOME/.oh-my-zsh/custom/plugins/zsh-completions"; then
            log_success "zsh-completions installed"
        else
            log_error "Failed to clone zsh-completions from https://github.com/zsh-users/zsh-completions to $HOME/.oh-my-zsh/custom/plugins/zsh-completions"
            rm -rf "$HOME/.oh-my-zsh/custom/plugins/zsh-completions"
            return 1
        fi
    fi
}

create_zshrc_config() {
    log_info "Creating elegant .zshrc configuration..."
    
    # Backup existing .zshrc
    [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Create new .zshrc
    cat > "$HOME/.zshrc" << 'EOF'
# UPack Elegant Terminal Configuration
# Oh My Zsh configuration with Powerlevel10k theme

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion
HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
    git
    sudo
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    colorize
    cp
    history
    jsontools
    web-search
    extract
    z
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='code'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though users are
# encouraged to define aliases within the ZSH_CUSTOM folder.

# UPack Custom Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias cls='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'

# Modern replacements (install with: sudo apt install exa bat fd-find ripgrep)
if command -v exa > /dev/null 2>&1; then
    alias ls='exa'
    alias ll='exa -alF'
    alias la='exa -a'
    alias tree='exa --tree'
fi

if command -v bat > /dev/null 2>&1; then
    alias cat='bat'
fi

if command -v fd > /dev/null 2>&1; then
    alias find='fd'
fi

if command -v rg > /dev/null 2>&1; then
    alias grep='rg'
fi

# Functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract function
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# UPack Terminal Configuration loaded
echo "🎨 UPack Terminal Configuration loaded"
EOF
    
    log_success ".zshrc configuration created"
}

configure_terminal_fonts() {
    log_step "Installing terminal fonts"
    
    # Install modern terminal fonts
    if ! fc-list | grep -q "JetBrains Mono"; then
        log_info "Installing JetBrains Mono font..."
        
        # Create fonts directory
        mkdir -p "$HOME/.local/share/fonts"
        
        # Setup cleanup trap
        local temp_zip="/tmp/JetBrainsMono.zip"
        local temp_dir="/tmp/JetBrainsMono"
        trap 'rm -rf "$temp_zip" "$temp_dir"' EXIT
        
        # Download JetBrains Mono with error checking
        if ! wget -O "$temp_zip" "https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"; then
            log_error "Failed to download JetBrains Mono font (wget exit code: $?)"
            return 1
        fi
        
        # Verify file was downloaded
        if [ ! -f "$temp_zip" ] || [ ! -s "$temp_zip" ]; then
            log_error "JetBrains Mono font download appears to have failed - file missing or empty"
            return 1
        fi
        
        # Unzip with error checking
        if ! unzip -o "$temp_zip" -d "$temp_dir/"; then
            log_error "Failed to extract JetBrains Mono font archive (unzip exit code: $?)"
            return 1
        fi
        
        # Verify TTF files exist
        if [ ! -d "$temp_dir/fonts/ttf" ] || [ -z "$(find "$temp_dir/fonts/ttf" -name "*.ttf" 2>/dev/null)" ]; then
            log_error "JetBrains Mono TTF files not found after extraction"
            return 1
        fi
        
        # Copy fonts with proper permissions
        if ! cp "$temp_dir/fonts/ttf/"*.ttf "$HOME/.local/share/fonts/"; then
            log_error "Failed to copy JetBrains Mono fonts to $HOME/.local/share/fonts/"
            return 1
        fi
        
        # Set correct permissions
        chmod 644 "$HOME/.local/share/fonts/"JetBrainsMono*.ttf
        
        # Update font cache
        if ! fc-cache -fv "$HOME/.local/share/fonts/" >/dev/null 2>&1; then
            log_error "Failed to update font cache (fc-cache exit code: $?)"
            return 1
        fi
        
        log_success "JetBrains Mono font installed"
    else
        log_info "JetBrains Mono font already installed"
    fi
    
    # Install Nerd Fonts for icons in terminal
    if ! fc-list | grep -q "JetBrainsMono Nerd Font"; then
        log_info "Installing JetBrains Mono Nerd Font..."
        
        local temp_zip="/tmp/JetBrainsMonoNerd.zip"
        trap 'rm -rf "$temp_zip"' EXIT
        
        # Download with retries for transient failures
        local max_retries=3
        local retry=0
        while [ $retry -lt $max_retries ]; do
            if wget -O "$temp_zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"; then
                break
            else
                retry=$((retry + 1))
                if [ $retry -lt $max_retries ]; then
                    log_info "Download attempt $retry failed, retrying in 2 seconds..."
                    sleep 2
                else
                    log_error "Failed to download JetBrains Mono Nerd Font after $max_retries attempts"
                    return 1
                fi
            fi
        done
        
        # Verify download
        if [ ! -f "$temp_zip" ] || [ ! -s "$temp_zip" ]; then
            log_error "JetBrains Mono Nerd Font download failed - file missing or empty"
            return 1
        fi
        
        # Extract and install
        if ! unzip -o "$temp_zip" -d "$HOME/.local/share/fonts/"; then
            log_error "Failed to extract JetBrains Mono Nerd Font (unzip exit code: $?)"
            return 1
        fi
        
        # Set permissions on installed fonts
        chmod 644 "$HOME/.local/share/fonts/"*JetBrains*
        
        # Update font cache
        if ! fc-cache -fv "$HOME/.local/share/fonts/" >/dev/null 2>&1; then
            log_error "Failed to update font cache after Nerd Font installation"
            return 1
        fi
        
        log_success "JetBrains Mono Nerd Font installed"
    else
        log_info "JetBrains Mono Nerd Font already installed"
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_terminal_configs
fi
