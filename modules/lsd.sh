#!/bin/bash

# lsd installation module

SCRIPT_DIR=$1

print_status() {
    echo -e "\033[0;32m[✓]\033[0m $1"
}

print_info() {
    echo -e "\033[0;34m[i]\033[0m $1"
}

print_info "Installing lsd..."

# Check if lsd is already installed
if command -v lsd &> /dev/null; then
    print_status "lsd is already installed"
else
    print_info "Installing lsd via Homebrew..."
    brew install lsd
    print_status "lsd installed successfully"
fi

print_status "lsd setup complete"

