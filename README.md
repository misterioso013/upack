# 🚀 UPack - Ubuntu Productivity Pack

**The simplest way to set up Ubuntu for productivity and development.**

Transform your fresh Ubuntu installation into a beautiful, productive workspace in just one command. No menus, no decisions, no complexity - just automated perfection.

## ⚡ Quick Start

### 🎯 One-Command Setup
```bash
git clone https://github.com/misterioso013/upack.git
cd upack
./setup.sh
```

**That's it!** ☕ Grab a coffee and come back to a fully configured Ubuntu system in 10-15 minutes.

## ✨ What You Get

### 🎨 Beautiful Desktop
### 🎨 Beautiful Desktop
- **WhiteSur Theme**: Elegant macOS-inspired design
- **GNOME Extensions**: Curated productivity extensions
- **Custom Hotkeys**: Keyboard-driven workflow
- **Modern Terminal**: Customized bash with colors and fonts

### 📦 Essential Applications
- **Google Chrome**: Modern web browser
- **VS Code**: Code editor with extensions
- **VLC**: Media player
- **Xournal++**: Note-taking and PDF annotation
- **GNOME Tweaks**: System customization
- **And more**: All the tools you need for daily productivity

### 🤖 Smart CLI Management
After setup, manage your system with the intelligent UPack CLI:
```bash
# Install development languages
upack install node python rust

# Install optional applications
upack install discord obs-studio btop

# System maintenance
upack status    # Show what's installed
upack update    # Update everything
upack --help    # See all commands
```

## 🖥️ Desktop Applications

UPack includes desktop launchers that are automatically added to your dock:

- **UPack Manager**: System status and management GUI
- **SendAny**: Quick file sharing service
- Search for them in your Applications menu or find them in the dock

## 🛠️ Development Ready

### Programming Languages (via CLI)
```bash
upack install node     # Node.js via NVM (industry standard)
upack install python   # Python via system/pyenv
upack install rust     # Rust via rustup (official installer)
```

### Development Tools
```bash
upack install btop      # Modern system monitor
upack install docker    # Container platform
```

Each language installer uses the community's preferred tool - no conflicts, no complexity.

## 🔧 System Requirements

- **Ubuntu 22.04 LTS** or **24.04 LTS**
- **Internet connection** for downloads
- **sudo privileges** for system package installation

## 🎯 Philosophy

UPack follows the **"Format → Clone → Run → Done"** philosophy:

1. **No interactive menus** during initial setup
2. **Zero decisions required** - smart defaults for everything  
3. **Development tools installed separately** via CLI when needed
4. **Permanent installation** - works even if you delete the original folder
5. **Clean uninstall** capability with `upack-uninstall`

## 🚀 Advanced Usage

### Custom Installation
The setup is fully automated, but you can customize post-installation:

```bash
# Check system status
upack status

# Install specific applications
upack install discord obs-studio

# Update all installed packages
upack update

# List available packages
upack list --available

# Uninstall UPack completely
upack-uninstall
```

### Keyboard Shortcuts
After setup, you get productive hotkeys:
- `Super + /` - Quick reference for all hotkeys
- `Super + T` - Open terminal  
- `Super + E` - File manager
- `Super + 1-9` - Switch between applications

## �️ What's Installed Automatically

### Essential Applications
✅ **Google Chrome** - Modern web browser  
✅ **VS Code** - Code editor with extensions  
✅ **VLC Media Player** - Universal media player  
✅ **Xournal++** - PDF annotation and note-taking  
✅ **GNOME Tweaks** - System customization tools  
✅ **Extension Manager** - Manage GNOME extensions  

### System Configuration  
✅ **WhiteSur Theme** - Beautiful macOS-inspired design  
✅ **SF Pro Display Fonts** - Apple's system fonts  
✅ **GNOME Extensions** - Dock, workspace management  
✅ **Custom Hotkeys** - Productivity keyboard shortcuts  
✅ **Terminal Customization** - Colors, prompts, and themes  

### UPack Infrastructure
✅ **UPack CLI** - Intelligent package management  
✅ **Desktop Applications** - GUI launcher and file sharing  
✅ **Permanent Installation** - Survives folder deletion  
✅ **Global Access** - Commands work from anywhere  

## 📱 Optional Applications (Install Later)

Use the UPack CLI to install additional software as needed:

```bash
# Entertainment & Communication
upack install discord      # Voice/video chat for gamers
upack install obs-studio   # Live streaming and recording

# Development & System Tools  
upack install btop         # Modern system monitor
upack install docker       # Container platform

# Programming Languages
upack install node         # Node.js via NVM
upack install python       # Python with package management
upack install rust         # Rust programming language
```

## 🏗️ Project Structure

The automated setup installs everything to permanent locations:

```
~/.local/share/upack/       # Main UPack installation
├── assets/                 # Icons, fonts, wallpapers
├── config/                 # GNOME, terminal, app configs  
├── install/                # Installation scripts
└── utils/                  # Utility functions

~/.local/bin/               # CLI tools (in your PATH)
├── upack                   # Main CLI interface
├── upack-tui              # Terminal UI
└── upack-uninstall        # Complete removal tool

~/.local/share/applications/ # Desktop entries
├── upack-manager.desktop   # UPack Manager GUI
└── sendany.desktop         # File sharing app
```

## 🛠️ Development & Contributing

### Development Setup
```bash
# Clone for development
git clone https://github.com/misterioso013/upack.git
cd upack

# The CLI automatically detects development vs installed mode
./bin/upack --help    # Run from source during development
```

### Contributing
1. Fork the repository on GitHub
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and test thoroughly
4. Commit with clear messages: `git commit -m "Add amazing feature"`
5. Push and create a Pull Request

## 🐛 Troubleshooting

### Common Issues

**UPack command not found:**
```bash
# Add to PATH manually if needed
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Desktop applications missing icons:**
```bash
# Icons are automatically installed to permanent location
ls ~/.local/share/upack/assets/icons/
```

**Want to start over completely:**
```bash
# Complete removal
upack-uninstall

# Then reinstall
git clone https://github.com/misterioso013/upack.git
cd upack && ./setup.sh
```

### Getting Help
- **Quick status check**: `upack status`
- **List all commands**: `upack --help`
- **Check installation**: `ls ~/.local/share/upack/`
- **View installed apps**: `upack list --installed`

## 🎉 What Makes UPack Different

### ✅ True Automation
- **No menus or dialogs** during setup
- **Smart defaults** for everything
- **Zero user decisions** required

### ✅ Permanent Installation  
- **Survives folder deletion** - works even after removing the original clone
- **Global CLI access** - commands work from any directory
- **Clean uninstall** - complete removal in one command

### ✅ Intelligent Package Management
- **Best practices** - each language uses its preferred installer
- **Conflict-free** - no duplicate package managers
- **Community standards** - NVM for Node, rustup for Rust, etc.

### ✅ Professional Quality
- **Robust error handling** - graceful failure with helpful messages
- **Permanent infrastructure** - proper system integration
- **Modern interface** - beautiful CLI with colors and clear output

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Inspired by [Omakub](https://omakub.org) by DHH
- [WhiteSur Theme](https://github.com/vinceliuice/WhiteSur-gtk-theme) by vinceliuice  
- [Nord Color Scheme](https://github.com/arcticicestudio/nord) by Arctic Ice Studio
- Ubuntu and GNOME communities

---

## 🚀 Ready to Transform Your Ubuntu?

```bash
git clone https://github.com/misterioso013/upack.git
cd upack
./setup.sh
```

**Just one command. Zero complexity. Maximum productivity.** ☕

---

<div align="center">

**Made with ❤️ for the Ubuntu community**

[⭐ Star this repo](https://github.com/misterioso013/upack) • [🐛 Report bugs](https://github.com/misterioso013/upack/issues) • [💡 Request features](https://github.com/misterioso013/upack/discussions)

</div>