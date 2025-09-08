# ⚡ UPack Quick Start Guide

**Transform Ubuntu into a productivity powerhouse in one command.**

## 🚀 Installation (2 minutes)

```bash
git clone https://github.com/misterioso013/upack.git
cd upack
./setup.sh
```

**That's it!** ☕ The setup runs automatically for 10-15 minutes.

## ✨ What Happens During Setup

UPack automatically installs and configures:

### 🎨 Beautiful Desktop
- WhiteSur theme (macOS-inspired design)
- SF Pro Display fonts
- GNOME extensions for productivity
- Custom keyboard shortcuts

### 📦 Essential Applications
- Google Chrome (web browser)
- VS Code (code editor) 
- VLC (media player)
- Xournal++ (PDF annotation)
- GNOME Tweaks (system settings)

### 🤖 Smart CLI System
- `upack` command available globally
- Desktop launchers (UPack Manager, SendAny)
- Permanent installation (survives folder deletion)

## 🎯 After Setup: Using UPack CLI

### Development Languages
```bash
upack install node     # Node.js via NVM
upack install python   # Python with proper management  
upack install rust     # Rust via rustup
```

### Optional Applications
```bash
upack install discord      # Chat & voice for gamers
upack install obs-studio   # Streaming & recording
upack install btop         # Modern system monitor
```

### System Management
```bash
upack status    # Show what's installed
upack update    # Update all packages
upack --help    # See all commands
```

## 🎮 Desktop Applications

After setup, find these in your Applications menu or dock:
- **UPack Manager** - GUI for system management
- **SendAny** - Quick file sharing service

## ⌨️ New Keyboard Shortcuts

- `Super + /` - Show all hotkeys
- `Super + T` - Open terminal
- `Super + E` - File manager
- `Super + 1-9` - Switch between apps

## 🔧 Need Help?

### Check Installation
```bash
upack status        # Show system status
ls ~/.local/bin/    # Verify CLI is installed
```

### Complete Removal
```bash
upack-uninstall     # Remove everything cleanly
```

### Start Over
```bash
upack-uninstall     # Remove old installation
git clone https://github.com/misterioso013/upack.git
cd upack && ./setup.sh
```

## ⚡ Pro Tips

1. **No internet during setup?** The script will detect and gracefully fail with helpful messages.

2. **Want to customize later?** Everything is designed to be modified after installation.

3. **Deleted the original folder?** No problem! UPack is permanently installed and continues working.

4. **Need development tools?** Use `upack install` commands after setup - no need to reinstall everything.

---

## 🚀 That's All You Need!

UPack follows the **"Format → Clone → Run → Done"** philosophy.

Just run the setup and enjoy your perfectly configured Ubuntu system! 🎉
