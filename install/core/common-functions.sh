#!/bin/bash

# UPack Core - Common Functions
# Shared functions for all installation scripts

# Check if app is installed
is_installed() {
    command -v "$1" &>/dev/null
}

# Check if package is installed via apt
is_apt_installed() {
    dpkg -l "$1" &>/dev/null 2>&1
}

# Simple log functions
log_step() { echo "🔄 $1"; }
log_info() { echo "ℹ️  $1"; }
log_success() { echo "✅ $1"; }
log_error() { echo "❌ $1"; }
log_warning() { echo "⚠️  $1"; }
