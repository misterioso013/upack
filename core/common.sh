#!/usr/bin/env bash

# Common functions for UPack installation scripts

# Configure GNOME settings (wallpaper, dark mode, accent color)
configure_gnome_settings() {
  local install_dir="$1"
  
  # Configure GNOME settings if available
  if command -v gsettings &>/dev/null && [[ "${XDG_CURRENT_DESKTOP:-}" == *"GNOME"* || -n "${GNOME_DESKTOP_SESSION_ID:-}" ]]; then
    echo "🎨 Configuring GNOME settings..."
    
    # Set dark mode
    if [[ "$(gsettings writable org.gnome.desktop.interface color-scheme 2>/dev/null)" == "true" ]]; then
      gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || true
    fi
    
    # Set accent color to orange
    if [[ "$(gsettings writable org.gnome.desktop.interface accent-color 2>/dev/null)" == "true" ]]; then
      gsettings set org.gnome.desktop.interface accent-color 'orange' || true
    fi
    
    # Set wallpaper
    local wallpaper_path="$install_dir/assets/ubuntu-neo-wallpaper.jpg"
    if [ -f "$wallpaper_path" ]; then
      # Set wallpaper options first
      if [[ "$(gsettings writable org.gnome.desktop.background picture-options 2>/dev/null)" == "true" ]]; then
        gsettings set org.gnome.desktop.background picture-options 'zoom' || true
      fi
      # Set wallpaper for light and dark modes
      if [[ "$(gsettings writable org.gnome.desktop.background picture-uri 2>/dev/null)" == "true" ]]; then
        gsettings set org.gnome.desktop.background picture-uri "file://$wallpaper_path" || true
      fi
      if [[ "$(gsettings writable org.gnome.desktop.background picture-uri-dark 2>/dev/null)" == "true" ]]; then
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$wallpaper_path" || true
      fi
      # Force refresh of the wallpaper
      sleep 1
      if command -v dconf &>/dev/null; then
        dconf write /org/gnome/desktop/background/picture-uri "'file://$wallpaper_path'" || true
      fi
      echo "✅ Wallpaper applied: $wallpaper_path"
    else
      echo "❌ Wallpaper not found: $wallpaper_path"
    fi
  else
    echo "ℹ️ GNOME not detected or gsettings not available, skipping desktop customization"
  fi
}

# Install GNOME extensions and configure them
install_gnome_extensions() {
  local install_dir="$1"
  
  # Check if we're running GNOME
  if [[ "${XDG_CURRENT_DESKTOP:-}" != *"GNOME"* && -z "${GNOME_DESKTOP_SESSION_ID:-}" ]]; then
    echo "ℹ️ GNOME not detected, skipping extensions installation"
    return 0
  fi
  
  echo "🧩 Do you want to install and configure GNOME extensions?"
  echo "   This includes: Tactile, Just Perfection, Blur My Shell, Space Bar,"
  echo "   TopHat, Alphabetical App Grid, and more!"
  
  if command -v gum &>/dev/null; then
    if gum confirm "Install GNOME extensions?"; then
      bash "$install_dir/install/gnome-extensions.sh"
    else
      echo "⏭️ GNOME extensions installation skipped"
    fi
  else
    echo "Install GNOME extensions? (y/N)"
    read -r answer
    if [[ $answer =~ ^[Yy]$ ]]; then
      bash "$install_dir/install/gnome-extensions.sh"
    else
      echo "⏭️ GNOME extensions installation skipped"
    fi
  fi
}

# Install and configure the minimalista theme
install_theme() {
  local install_dir="$1"
  
  echo "🎨 Do you want to install the minimalista theme? (WhiteSur + Nordzy + Sunity + SF Pro fonts)"
  
  if command -v gum &>/dev/null; then
    if gum confirm "Install minimalista theme?"; then
      bash "$install_dir/install/theme.sh"
    else
      echo "⏭️ Theme installation skipped"
    fi
  else
    echo "Install minimalista theme? (y/N)"
    read -r answer
    if [[ $answer =~ ^[Yy]$ ]]; then
      bash "$install_dir/install/theme.sh"
    else
      echo "⏭️ Theme installation skipped"
    fi
  fi
}

# Ask user about reboot and handle the response
handle_reboot_prompt() {
  echo ""
  echo "🎉 UPack installation completed!"
  echo "💡 To ensure all GNOME configurations (wallpaper, themes, etc.) are properly applied,"
  echo "   it's recommended to restart your computer."
  echo ""

  if command -v gum &>/dev/null; then
    local reboot_option
    reboot_option=$(gum choose "Restart now" "Restart later" --header "Choose an option:")
    
    case $reboot_option in
      "Restart now")
        echo "🔄 Restarting system in 3 seconds..."
        sleep 1
        echo "3..."
        sleep 1  
        echo "2..."
        sleep 1
        echo "1..."
        sudo reboot
        ;;
      "Restart later")
        echo "✅ You can restart manually later to apply all configurations."
        echo "   Just run: sudo reboot"
        ;;
    esac
  else
    echo "Would you like to restart now to apply all configurations? (y/N)"
    read -r answer
    if [[ $answer =~ ^[Yy]$ ]]; then
      echo "🔄 Restarting system in 3 seconds..."
      sleep 1
      echo "3..."
      sleep 1
      echo "2..."  
      sleep 1
      echo "1..."
      sudo reboot
    else
      echo "✅ You can restart manually later to apply all configurations."
      echo "   Just run: sudo reboot"
    fi
  fi
}

# Ensure gum is available for interactive prompts
ensure_gum() {
  if ! command -v gum &>/dev/null; then
    echo "📥 Gum not found. Installing..."
    bash utils/gum.sh
  fi
}
