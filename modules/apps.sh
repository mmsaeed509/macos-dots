#!/bin/bash

# Applications installation module

SCRIPT_DIR=$1

print_status() {
    echo -e "\033[0;32m[✓]\033[0m $1"
}

print_info() {
    echo -e "\033[0;34m[i]\033[0m $1"
}

print_warning() {
    echo -e "\033[1;33m[!]\033[0m $1"
}

print_info "Installing applications..."

# Function to install app via Homebrew Cask
install_cask() {
    local app_name=$1
    local cask_name=${2:-$app_name}
    
    if brew list --cask "$cask_name" &> /dev/null; then
        print_status "$app_name is already installed"
    else
        print_info "Installing $app_name..."
        brew install --cask "$cask_name" || {
            print_warning "Failed to install $app_name via Homebrew Cask"
            return 1
        }
        print_status "$app_name installed"
    fi
}

# Install Kiro
print_info "Installing Kiro..."
if brew list --cask kiro &> /dev/null; then
    print_status "Kiro is already installed"
else
    # Kiro might not be in Homebrew, try alternative installation
    print_warning "Kiro may not be available in Homebrew. Please install manually if needed."
    # Try to install if available
    brew install --cask kiro 2>/dev/null || print_warning "Kiro installation skipped (not found in Homebrew)"
fi

# Install Cursor
print_info "Installing Cursor..."
if brew list --cask cursor &> /dev/null; then
    print_status "Cursor is already installed"
else
    brew install --cask cursor || {
        print_warning "Cursor installation failed. You may need to install it manually from cursor.sh"
    }
fi

# Install Brave Browser
install_cask "Brave Browser" "brave-browser"

# Install Termius
install_cask "Termius" "termius"

# Install Discord
install_cask "Discord" "discord"

# Install OBS Studio
install_cask "OBS Studio" "obs"

# Install RustDesk
install_cask "RustDesk" "rustdesk"

# Install tmux
print_info "Installing tmux..."
if command -v tmux &> /dev/null; then
    print_status "tmux is already installed"
else
    brew install tmux
    print_status "tmux installed"
fi

# Install Neovim
print_info "Installing Neovim..."
if command -v nvim &> /dev/null; then
    print_status "Neovim is already installed"
else
    brew install neovim
    print_status "Neovim installed"
fi

# Install NvChad
print_info "Setting up NvChad..."
NVIM_CONFIG="$HOME/.config/nvim"
if [[ -d "$NVIM_CONFIG" ]]; then
    if [[ -d "$NVIM_CONFIG/.git" ]]; then
        print_status "NvChad appears to be already installed"
        print_info "Updating NvChad..."
        cd "$NVIM_CONFIG" && git pull
    else
        print_warning "Existing Neovim config found. Backing up..."
        mv "$NVIM_CONFIG" "${NVIM_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Installing NvChad..."
        git clone https://github.com/NvChad/NvChad "$NVIM_CONFIG" --depth 1
        print_status "NvChad installed"
    fi
else
    print_info "Installing NvChad..."
    mkdir -p "$(dirname "$NVIM_CONFIG")"
    git clone https://github.com/NvChad/NvChad "$NVIM_CONFIG" --depth 1
    print_status "NvChad installed"
fi

print_status "Applications setup complete"

