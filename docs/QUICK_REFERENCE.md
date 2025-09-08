# ⚡ UPack - Quick Reference

> **Quick reference guide for daily UPack usage**

## 🚀 Express Installation

### Ultra-Simple (One Command)
```bash
curl -sSL https://raw.githubusercontent.com/misterioso013/upack/main/boot.sh | bash
```

### Manual Method
```bash
git clone https://github.com/misterioso013/upack.git
cd upack  
./setup.sh
```

---

## 🕹️ Essential Commands

### Main CLI
```bash
upack status          # System status
upack update          # Update everything
upack install <app>   # Install application
upack list            # List apps
upack doctor          # Diagnostics
upack clean           # Cleanup
upack-tui             # Visual interface
```

### Configuration
```bash
upack config gnome       # Configure GNOME
upack config terminal    # Configure terminal
upack config hotkeys     # Configure shortcuts
upack backup            # Backup configurations
```

---

## ⌨️ Keyboard Shortcuts

### 🎯 Essential
| Shortcut | Action |
|----------|--------|
| `Super + /` | **Show all shortcuts** |
| `Super + T` | Terminal |
| `Super + E` | Explorer |
| `Super + L` | Lock |
| `Ctrl + Alt + T` | Quick terminal |

### 🪟 Windows
| Shortcut | Action |
|----------|--------|
| `Super + ←/→` | Split screen |
| `Super + ↑` | Maximize |
| `Super + ↓` | Restore |
| `Alt + Tab` | Switch apps |
| `Alt + F4` | Close window |

### 🏢 Workspaces
| Shortcut | Action |
|----------|--------|
| `Super + 1-9` | Go to workspace |
| `Ctrl + Alt + ←/→` | Navigate workspaces |
| `Super + Shift + 1-9` | Move window |

---

## 🖥️ Terminal

### 🎯 Git Aliases
```bash
gs     # git status
ga     # git add
gc     # git commit
gp     # git push
gl     # git pull
gd     # git diff
glog   # git log --oneline --graph
```

### 🔧 Useful Aliases
```bash
ll     # ls detailed (or exa -la)
la     # ls with hidden (or exa -a)
..     # cd ..
...    # cd ../..
c      # clear
h      # history
reload # source ~/.bashrc
```

### 🐍 Python
```bash
py     # python3
pip    # pip3
serve  # python3 -m http.server
json   # python3 -m json.tool
```

### 🐳 Docker
```bash
dc     # docker-compose
dps    # docker ps
di     # docker images
```

---

## 💻 Programming Languages

### 📦 Install Languages
```bash
# Via optional menu
./core/optional.sh

# Direct
./install/apps/optional/dev-languages.sh
```

### 🛠️ Available Tools
- **Node.js** → NVM
- **Rust** → rustup
- **Python** → apt + pipx
- **Java** → OpenJDK + Maven
- **Go** → official
- **PHP** → apt + Composer
- **C/C++** → build-essential
- **.NET** → Microsoft repo
- **Ruby** → rbenv
- **Zig** → GitHub
- **Deno** → official

### 🎛️ Manage with mise
```bash
mise install python@3.11  # Install version
mise use python@3.11      # Use version
mise list                 # List installed
mise ls-remote python     # List available
```

---

## 🛠️ Development Tools

### 📦 Install Tools
```bash
./install/apps/optional/dev-tools.sh
```

### ⚡ Modern Commands
```bash
# Modern replacements
ls    → exa -la --icons
cat   → bat
find  → fd
grep  → rg (ripgrep)
top   → btm (bottom)
ps    → procs

# Examples
fd "*.py"                    # Find Python files
rg "TODO" --type rust       # Search in Rust files
bat README.md               # View file with syntax
exa -la --tree             # Tree listing
btm                        # System monitor
```

---

## 🔧 Quick Troubleshooting

### 🩺 Diagnostics
```bash
upack doctor               # General check
upack status              # Detailed status
echo $PATH                # Check PATH
which upack               # Locate executable
```

### 🔄 Common Fixes
```bash
# Broken PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Aliases not working
source ~/.bash_aliases

# GNOME Extensions
Alt + F2 → "r" → Enter    # Restart GNOME Shell

# Reconfigure terminal
bash config/terminal/bash-config.sh
```

### 📋 Logs
```bash
tail -f ~/.local/share/upack/logs/upack.log  # View logs
UPACK_DEBUG=1 upack status                   # Debug mode
```

---

## 🎨 Quick Configuration

### 🖥️ Alacritty
```bash
# Main configuration
~/.config/alacritty/alacritty.yml

# Switch theme
ln -sf ~/.config/alacritty/themes/nord.toml ~/.config/alacritty/theme.toml
```

### 🎯 VS Code
```bash
# Open settings
code ~/.config/Code/User/settings.json

# Install extension
code --install-extension <extension-id>
```

### 🐚 Bash
```bash
# Main configuration
~/.bashrc

# Custom aliases  
~/.bash_aliases

# Reload
source ~/.bashrc
```

---

## 📊 Monitoring

### 🔍 System
```bash
btm                       # Modern monitor
htop                      # Classic monitor  
df -h                     # Disk space
free -h                   # Memory
upack activity            # UPack activity
```

### 🐳 Docker
```bash
docker ps                # Running containers
docker images            # Images
docker system df         # Space usage
docker system prune -f   # Cleanup
```

### 🌐 Network
```bash
ss -tulpn                # Ports in use
nmap localhost           # Local scan
ping google.com          # Test connectivity
```

---

## 🎯 Recommended Workflow

### 🏢 Workspace Organization
1. **Workspace 1**: Browser (research)
2. **Workspace 2**: VS Code (coding) 
3. **Workspace 3**: Terminal (commands)
4. **Workspace 4**: Communication

### 🔄 Daily Git Flow
```bash
gs                        # Check status
ga .                      # Add everything
gc -m "feat: new feature" # Commit
gp                        # Push
```

### 🐳 Docker Flow
```bash
dc up -d                  # Start services
dc logs -f app            # View logs
dc down                   # Stop services
```

---

## 📱 Useful Links

- **Complete Documentation**: `docs/COMPLETE_GUIDE.md`
- **GitHub**: https://github.com/misterioso013/upack
- **Issues**: https://github.com/misterioso013/upack/issues

---

**💡 Tip**: Bookmark this reference for quick daily lookup!

**🚀 Happy coding!**
