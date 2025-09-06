#!/bin/bash

# Elegant Bash configuration for UPack
# Creates a beautiful prompt and useful aliases

source "$(dirname "$0")/../../utils/gum.sh" 2>/dev/null || true

# Define log functions if not already available
if ! command -v log_step &> /dev/null; then
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
    log_warning() { echo "⚠️  $1"; }
fi

configure_bash() {
    log_step "Configuring elegant Bash settings"
    
    # Load color configuration
    local colors_conf="$(dirname "$0")/colors.conf"
    if [ -f "$colors_conf" ]; then
        source "$colors_conf"
        log_info "Nord color scheme loaded"
    fi
    
    # Backup existing .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Existing .bashrc backed up"
    fi
    
    # Create elegant .bashrc configuration
    create_bashrc_config
    
    # Create .bash_aliases file
    create_bash_aliases
    
    # Install modern CLI tools for better experience
    install_modern_cli_tools
    
    log_success "Bash configuration completed!"
    log_info "Restart your terminal or run 'source ~/.bashrc' to apply changes"
}

create_bashrc_config() {
    log_info "Creating elegant .bashrc configuration..."
    
    cat > "$HOME/.bashrc" << 'EOF'
# ~/.bashrc: executed by bash(1) for non-login shells.
# UPack Elegant Terminal Configuration

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Define colors for prompt
if [ "$color_prompt" = yes ]; then
    # Nord color scheme
    NORD_BLUE='\[\033[38;2;129;161;193m\]'
    NORD_GREEN='\[\033[38;2;163;190;140m\]'
    NORD_YELLOW='\[\033[38;2;235;203;139m\]'
    NORD_RED='\[\033[38;2;191;97;106m\]'
    NORD_PURPLE='\[\033[38;2;180;142;173m\]'
    NORD_CYAN='\[\033[38;2;136;192;208m\]'
    NORD_WHITE='\[\033[38;2;216;222;233m\]'
    NORD_GRAY='\[\033[38;2;76;86;106m\]'
    RESET='\[\033[0m\]'
    BOLD='\[\033[1m\]'
    
    # Git status function
    parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    }
    
    # Check if in git repository
    parse_git_dirty() {
        [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]] && echo "*"
    }
    
    # Custom prompt with git support
    PS1="${BOLD}${NORD_BLUE}┌─[${RESET}${BOLD}${NORD_GREEN}\u@\h${RESET}${BOLD}${NORD_BLUE}]${RESET} ${BOLD}${NORD_YELLOW}\w${RESET} ${NORD_PURPLE}\$(parse_git_branch)\$(parse_git_dirty)${RESET}\n${BOLD}${NORD_BLUE}└─${NORD_CYAN}\$ ${RESET}"
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Set default editor
export EDITOR=nano
export VISUAL=nano

# Improve readline behavior
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

# Custom functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract function
extract() {
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Show system info on terminal start (only for interactive shells)
if [[ $- == *i* ]]; then
    echo -e "\033[38;2;129;161;193m"
    echo "  ██╗   ██╗██████╗  █████╗  ██████╗██╗  ██╗"
    echo "  ██║   ██║██╔══██╗██╔══██╗██╔════╝██║ ██╔╝"
    echo "  ██║   ██║██████╔╝███████║██║     █████╔╝ "
    echo "  ██║   ██║██╔═══╝ ██╔══██║██║     ██╔═██╗ "
    echo "  ╚██████╔╝██║     ██║  ██║╚██████╗██║  ██╗"
    echo "   ╚═════╝ ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝"
    echo -e "\033[38;2;216;222;233m"
    echo "  Welcome to your elegant terminal environment!"
    echo -e "\033[0m"
    echo
fi

# UPack Terminal Configuration loaded
export UPACK_TERMINAL_LOADED=1
EOF
    
    log_success ".bashrc configuration created"
}

create_bash_aliases() {
    log_info "Creating useful bash aliases..."
    
    cat > "$HOME/.bash_aliases" << 'EOF'
# UPack Terminal Aliases
# Useful shortcuts and modern replacements

# Basic aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias cls='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# File operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -pv'
alias rmdir='rmdir -v'

# System monitoring
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias top='htop'
alias ports='netstat -tulanp'

# Network
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'
alias wget='wget -c'
alias ipe='curl ipinfo.io/ip'
alias ipi='ipconfig getifaddr en0'

# Git aliases (if git is available)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gm='git merge'

# Package management
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
alias install='sudo apt install'
alias search='apt search'
alias autoremove='sudo apt autoremove'
alias autoclean='sudo apt autoclean'

# Development
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'

# Modern replacements (only if installed)
if command -v exa > /dev/null 2>&1; then
    alias ls='exa --icons'
    alias ll='exa -alF --icons'
    alias la='exa -a --icons'
    alias tree='exa --tree --icons'
fi

if command -v bat > /dev/null 2>&1; then
    alias cat='bat'
    alias less='bat'
fi

if command -v fd > /dev/null 2>&1; then
    alias find='fd'
fi

if command -v rg > /dev/null 2>&1; then
    alias grep='rg'
fi

if command -v htop > /dev/null 2>&1; then
    alias top='htop'
fi

# Fun aliases
alias weather='curl wttr.in'
alias moon='curl wttr.in/Moon'
alias joke='curl -s https://api.jokes.one/jod | jq -r .contents.jokes[0].joke.text 2>/dev/null || echo "Could not fetch joke"'

# Typo corrections
alias cd..='cd ..'
alias pdw='pwd'
alias sl='ls'
alias gerp='grep'
alias claer='clear'
alias clera='clear'

# Safety aliases
alias rm='rm -I --preserve-root'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Archive extraction
alias untar='tar -zxvf'
alias untargz='tar -zxvf'
alias untarbz2='tar -jxvf'

# Quick editing
alias bashrc='${EDITOR} ~/.bashrc'
alias bashaliases='${EDITOR} ~/.bash_aliases'
alias vimrc='${EDITOR} ~/.vimrc'

# Process management
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

# System information
alias meminfo='free -m -l -t'
alias cpuinfo='lscpu'
alias diskinfo='df -h'
alias sysinfo='uname -a'

# Quick navigation to common directories
alias docs='cd ~/Documents'
alias down='cd ~/Downloads'
alias desk='cd ~/Desktop'
alias proj='cd ~/Projects'

# Terminal enhancement
alias c='clear'
alias q='exit'
alias x='exit'
EOF
    
    log_success "Bash aliases created"
}

install_modern_cli_tools() {
    log_step "Installing modern CLI tools for better terminal experience"
    
    # Update package list
    sudo apt update
    
    # Install useful terminal tools
    local tools=(
        "htop"          # Better top
        "tree"          # Directory tree view
        "curl"          # HTTP requests
        "wget"          # File downloader
        "jq"            # JSON processor
        "zip"           # Archive utilities
        "unzip"
        "p7zip-full"
        "neofetch"      # System information
        "git"           # Version control
    )
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            log_info "Installing $tool..."
            if sudo apt install -y "$tool"; then
                log_success "$tool installed"
            else
                log_warning "Failed to install $tool"
            fi
        else
            log_info "$tool already installed"
        fi
    done
    
    # Install modern replacements (optional)
    install_modern_replacements
}

install_modern_replacements() {
    log_info "Installing modern CLI tool replacements..."
    
    # Try to install exa (better ls)
    if ! command -v exa &> /dev/null; then
        if sudo apt install -y exa 2>/dev/null; then
            log_success "exa installed (modern ls replacement)"
        else
            log_info "exa not available in repositories, skipping"
        fi
    fi
    
    # Try to install bat (better cat)
    if ! command -v bat &> /dev/null; then
        if sudo apt install -y bat 2>/dev/null; then
            log_success "bat installed (modern cat replacement)"
        else
            log_info "bat not available in repositories, skipping"
        fi
    fi
    
    # Try to install fd (better find)
    if ! command -v fd &> /dev/null; then
        if sudo apt install -y fd-find 2>/dev/null; then
            log_success "fd installed (modern find replacement)"
        else
            log_info "fd not available in repositories, skipping"
        fi
    fi
    
    # Try to install ripgrep (better grep)
    if ! command -v rg &> /dev/null; then
        if sudo apt install -y ripgrep 2>/dev/null; then
            log_success "ripgrep installed (modern grep replacement)"
        else
            log_info "ripgrep not available in repositories, skipping"
        fi
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_bash
fi
