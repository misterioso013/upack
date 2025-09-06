# 🚀 UPack - Ubuntu Productivity Pack

A comprehensive system manager and productivity suite that transforms your Ubuntu desktop into a beautiful, efficient workspace.

## ✨ Features

### 🎯 Syst---

**Made with ❤️ for the Ubuntu community — UPack**

**UPack** is a minimalistic, developer-focused setup tool for Ubuntu.

Run one command and get your machine ready for coding - fast, clean, and just essentials.agement
- **UPack CLI**: Powerful command-line interface for system management
- **Interactive TUI**: Beautiful terminal user interface
- **Desktop Application**: GUI launcher for lazy people
- **System Monitor**: Modern btop integration with Nord theme

### 🎨 Desktop Environment  
- **WhiteSur Theme**: Stunning macOS-like appearance
- **GNOME Extensions**: Curated productivity extensions
- **Nord Color Scheme**: Consistent theming across all components
- **Custom Hotkeys**: Keyboard-driven productivity workflows

### 💻 Development Tools
- **Terminal Setup**: Bash/Zsh with custom prompts and colors
- **Alacritty**: GPU-accelerated terminal with multiple configurations
- **VS Code**: Pre-configured with extensions and settings
- **Git Integration**: SSH keys and development workflow setup

### 📦 Application Management
- **Curated App Collection**: Essential and optional productivity apps
- **Easy Installation**: One-command setup for all applications
- **Update Management**: Keep all apps updated with `upack update`
- **System Health**: Monitor and maintain system performance

## 🚀 Quick Start

### One-Line Installation
```bash
curl -sSL https://raw.githubusercontent.com/misterioso013/upack/main/setup.sh | bash
```

### Manual Installation
```bash
git clone https://github.com/misterioso013/upack.git
cd upack
./setup.sh
```

## 🎮 Usage

### 🖥️ Desktop Application
Search for **"UPack Manager"** in Activities or run:
```bash
upack gui
```

### 💻 Command Line Interface
```bash
# System status and information
upack status

# Install applications
upack install discord vscode chrome

# Update all applications
upack update

# List available/installed apps
upack list --available
upack list --installed

# System monitoring
upack monitor

# Open interactive terminal UI
upack-tui
```

### ⌨️ Keyboard Shortcuts
- `Super + /` - Quick reference for all hotkeys
- `Super + T` - Open terminal
- `Super + E` - File manager
- `Super + 1-9` - Switch between applications
- And many more productivity shortcuts!

## 🔧 Advanced Usage

### Custom Installation Types
```bash
./setup.sh
# Choose from:
# 1. Full Installation (Recommended)
# 2. Minimal Installation  
# 3. Desktop Environment Only
# 4. Developer Setup
# 5. Custom Installation
```

### Configuration Management
```bash
# Apply GNOME settings
upack config gnome

# Setup terminal
upack config terminal

# Configure hotkeys
upack hotkeys

# Backup current configuration
upack backup
```

### System Maintenance
```bash
# System health check
upack doctor

# View system activity
upack activity

# Clean system
upack clean

# Update everything
upack update
```

## 🏗️ Project Structure

```
upack/
├── bin/                    # UPack CLI tools
│   ├── upack              # Main CLI interface
│   └── upack-tui          # Terminal UI
├── config/                # Configuration files
│   ├── alacritty/         # Terminal configurations
│   ├── gnome/             # Desktop environment
│   ├── terminal/          # Shell configurations
│   └── vscode/            # Editor settings
├── install/               # Installation scripts
│   ├── apps/              # Application installers
│   └── theme.sh           # Theme installation
├── utils/                 # Utility functions
├── setup.sh               # Main setup script
└── README.md              # This file
```

## 🛠️ Development

### Development Mode
```bash
# Run with verbose logging
./dev.sh

# Test individual components
./install/apps/required/vscode.sh
./config/gnome/apply-config.sh
```

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 🐛 Troubleshooting

### Common Issues
```bash
# Fix PATH issues
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Reinstall UPack CLI
./install/apps/required/upack-app.sh

# System health check
upack doctor
```

### Getting Help
- Run `upack --help` for command reference
- Check `upack status` for system information
- Use `upack doctor` for troubleshooting
- View logs in `~/.local/share/upack/logs/`

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Inspired by [Omakub](https://omakub.org) by DHH
- WhiteSur theme by [vinceliuice](https://github.com/vinceliuice/WhiteSur-gtk-theme)  
- Nord color scheme by [Arctic Ice Studio](https://github.com/arcticicestudio/nord)
- Various GNOME extension developers

---

**Made with ❤️ for the Ubuntu community**ack - Ubuntu Packager
**Upack** is a minimalistic, developer-fucused setup tool for Ubuntu.

Run one command and get your machine ready for coding - fast, clean, and just essentials.