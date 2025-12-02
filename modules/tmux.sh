#!/bin/bash

# tmux configuration installation module

SCRIPT_DIR=$1
TMUX_CONF_SOURCE="$SCRIPT_DIR/tmux.conf"
TMUX_CONFIG_DIR="$HOME/.config/tmux"
TMUX_CONF_TARGET="$TMUX_CONFIG_DIR/tmux.conf"
TPM_DIR="$HOME/.tmux/plugins/tpm"
CATPPUCCIN_DIR="$HOME/.config/tmux/plugins/catppuccin/tmux"

print_status() {
    echo -e "\033[0;32m[✓]\033[0m $1"
}

print_info() {
    echo -e "\033[0;34m[i]\033[0m $1"
}

print_warning() {
    echo -e "\033[1;33m[!]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m[✗]\033[0m $1"
}

print_info "Setting up tmux configuration..."

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    print_error "tmux is not installed. Please install it first."
    exit 1
fi

# Check if source file exists
if [[ ! -f "$TMUX_CONF_SOURCE" ]]; then
    print_error "tmux.conf not found: $TMUX_CONF_SOURCE"
    exit 1
fi

# Create tmux configuration directory
print_info "Creating tmux configuration directory..."
mkdir -p "$TMUX_CONFIG_DIR"
print_status "Configuration directory created"

# Install TPM (tmux plugin manager)
print_info "Installing TPM (tmux plugin manager)..."
if [[ -d "$TPM_DIR" ]]; then
    print_status "TPM is already installed"
    print_info "Updating TPM..."
    cd "$TPM_DIR" && git pull 2>/dev/null || true
else
    print_info "Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR" 2>/dev/null
    print_status "TPM installed"
fi

# Install Catppuccin theme
print_info "Installing Catppuccin theme..."
if [[ -d "$CATPPUCCIN_DIR" ]]; then
    print_status "Catppuccin theme is already installed"
    print_info "Updating Catppuccin theme..."
    cd "$CATPPUCCIN_DIR" && git pull 2>/dev/null || true
else
    print_info "Cloning Catppuccin theme..."
    mkdir -p "$(dirname "$CATPPUCCIN_DIR")"
    git clone -b v2.1.3 https://github.com/catppuccin/tmux.git "$CATPPUCCIN_DIR" 2>/dev/null
    print_status "Catppuccin theme installed"
fi

# Copy tmux.conf to ~/.config/tmux/tmux.conf
print_info "Installing tmux configuration..."
cp "$TMUX_CONF_SOURCE" "$TMUX_CONF_TARGET"
print_status "tmux configuration installed to $TMUX_CONF_TARGET"

# Note: The tmux.conf file already has TPM initialization at the bottom
# Users will need to reload tmux or run: tmux source ~/.config/tmux/tmux.conf

print_status "tmux setup complete"
print_info "Note: Reload tmux configuration with: tmux source ~/.config/tmux/tmux.conf"
print_info "Or restart your tmux session to apply changes"


