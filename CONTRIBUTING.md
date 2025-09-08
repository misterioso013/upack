# 🤝 Contributing to UPack

Thank you for your interest in contributing to UPack! This document provides guidelines and information for contributors.

## 🌟 Philosophy

UPack follows the **"Format → Clone → Run → Done"** philosophy. All contributions should align with these core principles:

- **Simplicity First**: Keep it simple and automated
- **Zero User Decisions**: Smart defaults over configuration options
- **Single Command Setup**: Everything should work with `./setup.sh`
- **Post-Setup Flexibility**: Advanced features via `upack` CLI
- **Ubuntu Focus**: Optimized specifically for Ubuntu LTS versions

## 🚀 Quick Start for Contributors

### Prerequisites
- Ubuntu 22.04 LTS or 24.04 LTS
- Git and basic bash scripting knowledge
- Understanding of UPack's structure and philosophy

### Development Setup
```bash
# Fork the repository on GitHub
git clone https://github.com/YOUR_USERNAME/upack.git
cd upack

# Create a feature branch
git checkout -b feature/your-feature-name

# Test your changes
./setup.sh  # Test on a VM or container
./validate-setup.sh  # Run validation

# Make your changes and test
upack status  # Verify CLI functionality
```

## 📝 Types of Contributions

### 🐛 Bug Reports
- Use the bug report template
- Include system information and reproduction steps
- Test on a fresh Ubuntu installation when possible

### ✨ Feature Requests
- Use the feature request template
- Ensure alignment with UPack's philosophy
- Consider impact on the "one command" setup experience

### 🔧 Code Contributions
- Follow the coding standards below
- Test thoroughly before submitting
- Update documentation as needed

### 📚 Documentation
- Use clear, concise language
- Include practical examples
- Keep the focus on user experience

## 🏗️ Project Structure

```
upack/
├── setup.sh              # Main entry point
├── install/core/          # Core installation scripts
├── install/apps/          # Application installers
├── install/languages/     # Language-specific installers
├── bin/                   # UPack CLI tools
├── config/                # Configuration templates
├── assets/                # Themes, fonts, images
└── docs/                  # Documentation
```

### Key Components

#### 🎯 **setup.sh**
- Single entry point for installation
- Linear execution, no user interaction
- Calls scripts in `install/core/` sequentially

#### 🔧 **install/core/**
- Modular installation scripts
- Each script handles one major component
- Must be idempotent (safe to run multiple times)

#### 🖥️ **bin/upack**
- Post-installation CLI management
- Handles optional software and languages
- Smart detection of installed components

## 🛠️ Coding Standards

### Bash Scripting Guidelines

#### 1. Script Headers
```bash
#!/bin/bash
# Description: Brief description of what this script does
# Part of: UPack Ubuntu Productivity Pack
# Requires: List any dependencies
```

#### 2. Error Handling
```bash
set -e  # Exit on any error

# Function example with error handling
install_something() {
    local item="$1"
    
    if ! command -v "$item" &> /dev/null; then
        echo "Installing $item..."
        # installation commands
    else
        echo "$item is already installed"
    fi
}
```

#### 3. Logging and Output
```bash
# Use consistent output formatting
echo "🔧 Installing theme components..."
echo "✅ Theme installation completed"
echo "❌ Error: Could not install theme"

# For debug output
[[ "${DEBUG:-false}" == "true" ]] && echo "Debug: Variable value is $var"
```

#### 4. Function Structure
```bash
# Clear function names and documentation
install_application() {
    local app_name="$1"
    local description="$2"
    
    echo "📦 Installing $app_name..."
    
    # Check if already installed
    if command -v "$app_name" &> /dev/null; then
        echo "✅ $app_name already installed"
        return 0
    fi
    
    # Installation logic here
    
    echo "✅ $app_name installation completed"
}
```

#### 5. Variable Naming
```bash
# Use descriptive variable names
UPACK_DIR="$HOME/.local/share/upack"
ASSETS_DIR="$UPACK_DIR/assets"
CONFIG_FILE="$UPACK_DIR/config/settings.conf"

# Use uppercase for constants, lowercase for local variables
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
local temp_file="/tmp/upack_temp.$$"
```

### CLI Development (bin/upack)

#### Command Structure
```bash
# Each command should have consistent structure
upack_install() {
    local package="$1"
    
    case "$package" in
        node|nodejs)
            install_nodejs
            ;;
        python)
            install_python
            ;;
        *)
            echo "❌ Unknown package: $package"
            echo "Run 'upack list --available' to see options"
            return 1
            ;;
    esac
}
```

#### Help and Usage
```bash
# Always provide helpful usage information
show_help() {
    cat << EOF
UPack CLI v2.0.0 - Ubuntu Productivity Pack

Usage: upack <command> [options]

Commands:
  status              Show system status
  install <package>   Install a package
  list               List installed packages
  update             Update all packages
  help               Show this help

Examples:
  upack install node
  upack status
  upack list --available
EOF
}
```

## 🧪 Testing Guidelines

### Before Submitting
1. **Test on Clean Ubuntu**: Use a VM or container
2. **Run Validation**: Execute `./validate-setup.sh`
3. **Test CLI Functions**: Verify `upack` commands work
4. **Check Documentation**: Update docs if needed

### Testing Commands
```bash
# Validate script syntax
./validate-setup.sh

# Test specific components
bash -n install/core/theme-setup.sh  # Syntax check

# Test CLI functionality
upack status
upack list
upack install node  # Test installation
```

### Test Environments
- **Ubuntu 22.04 LTS** (Primary)
- **Ubuntu 24.04 LTS** (Primary)
- Fresh installations (not upgraded systems)

## 📋 Pull Request Process

### 1. Preparation
- [ ] Fork the repository
- [ ] Create a feature branch with a descriptive name
- [ ] Make your changes following the coding standards
- [ ] Test thoroughly on a clean Ubuntu installation

### 2. Documentation
- [ ] Update relevant documentation
- [ ] Add comments to complex code sections
- [ ] Update CHANGELOG.md if significant changes

### 3. Submission
- [ ] Write a clear PR title and description
- [ ] Reference any related issues
- [ ] Include testing information
- [ ] Request review from maintainers

### 4. Review Process
- Maintainers will review your code
- Address any feedback promptly
- Be patient - quality is important!

## 🎯 Contribution Ideas

### Easy (Good First Issues)
- Fix typos in documentation
- Improve error messages
- Add validation checks
- Update package versions

### Medium
- Add new application installers
- Improve theme configurations
- Enhance CLI functionality
- Add language support

### Advanced
- Major architecture improvements
- Performance optimizations
- New feature development
- Complex integrations

## 🏷️ Issue Labels

When contributing issues or PRs, these labels help organize work:

- `bug` - Something isn't working
- `enhancement` - New feature or improvement
- `documentation` - Documentation improvements
- `good first issue` - Good for newcomers
- `help wanted` - Community help needed
- `question` - Questions and support
- `needs-testing` - Requires testing
- `priority-high` - High priority items

## 💬 Communication

### Discord/Community
- Join discussions in GitHub Discussions
- Be respectful and constructive
- Help other users when possible

### Code Review
- Provide constructive feedback
- Focus on code quality and maintainability
- Consider the impact on end users

## 📜 License

By contributing to UPack, you agree that your contributions will be licensed under the same license as the project.

## 🙏 Recognition

Contributors are recognized in several ways:
- Listed in the project contributors
- Mentioned in release notes for significant contributions
- Given credit in commit messages

---

## 🚀 Ready to Contribute?

1. **Read this guide thoroughly**
2. **Look at existing issues** for inspiration
3. **Start small** with documentation or simple fixes
4. **Ask questions** if you're unsure about anything

Thank you for helping make UPack better for the Ubuntu community! 🎉
