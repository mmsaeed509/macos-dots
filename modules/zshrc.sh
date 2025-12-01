#!/bin/bash

# zshrc configuration installation module

SCRIPT_DIR=$1
ZSHRC_SOURCE="$SCRIPT_DIR/zshrc.txt"
ZSHRC_TARGET="$HOME/.zshrc"
ZSHRC_BACKUP="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"

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

print_info "Setting up zshrc configuration..."

# Check if source file exists
if [[ ! -f "$ZSHRC_SOURCE" ]]; then
    print_error "zshrc.txt not found: $ZSHRC_SOURCE"
    exit 1
fi

# Backup existing zshrc if it exists
if [[ -f "$ZSHRC_TARGET" ]]; then
    print_warning "Backing up existing .zshrc to $ZSHRC_BACKUP"
    cp "$ZSHRC_TARGET" "$ZSHRC_BACKUP"
fi

# Copy zshrc.txt to ~/.zshrc without modifications
print_info "Installing zshrc configuration..."
cp "$ZSHRC_SOURCE" "$ZSHRC_TARGET"

print_status "zshrc configuration installed"
if [[ -f "$ZSHRC_BACKUP" ]]; then
    print_warning "Backup saved to: $ZSHRC_BACKUP"
fi

