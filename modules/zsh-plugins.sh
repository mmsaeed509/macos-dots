#!/bin/bash

# Oh My Zsh plugins installation module

SCRIPT_DIR=$1
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

print_status() {
    echo -e "\033[0;32m[✓]\033[0m $1"
}

print_info() {
    echo -e "\033[0;34m[i]\033[0m $1"
}

print_info "Installing Oh My Zsh plugins..."

# Create custom plugins directory if it doesn't exist
mkdir -p "$ZSH_CUSTOM/plugins"

# Install zsh-autosuggestions
if [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    print_status "zsh-autosuggestions is already installed"
else
    print_info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    print_status "zsh-autosuggestions installed"
fi

# Install zsh-syntax-highlighting
if [[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    print_status "zsh-syntax-highlighting is already installed"
else
    print_info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    print_status "zsh-syntax-highlighting installed"
fi

# web-search is already included in oh-my-zsh, no need to install separately
print_status "web-search plugin is included in Oh My Zsh"

print_status "Oh My Zsh plugins setup complete"

