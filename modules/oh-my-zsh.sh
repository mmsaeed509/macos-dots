#!/bin/bash

# Oh My Zsh installation module

SCRIPT_DIR=$1

print_status() {
    echo -e "\033[0;32m[✓]\033[0m $1"
}

print_info() {
    echo -e "\033[0;34m[i]\033[0m $1"
}

print_info "Setting up Oh My Zsh..."

# Check if Oh My Zsh is already installed
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    print_status "Oh My Zsh is already installed"
else
    print_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_status "Oh My Zsh installed successfully"
fi

print_status "Oh My Zsh setup complete"

