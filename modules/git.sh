#!/bin/bash

# Git and GitHub CLI installation module

SCRIPT_DIR=$1

print_status() {
    echo -e "\033[0;32m[✓]\033[0m $1"
}

print_info() {
    echo -e "\033[0;34m[i]\033[0m $1"
}

print_info "Setting up Git and GitHub CLI..."

# Install Git via Homebrew (if not already installed)
if ! command -v git &> /dev/null; then
    print_info "Installing Git..."
    brew install git
else
    print_status "Git is already installed"
fi

# Install GitHub CLI
if ! command -v gh &> /dev/null; then
    print_info "Installing GitHub CLI..."
    brew install gh
    print_status "GitHub CLI installed"
else
    print_status "GitHub CLI is already installed"
    # Check if it needs updating
    print_info "Checking GitHub CLI version..."
    gh --version 2>/dev/null || true
fi

# Check if git is configured
if ! git config --global user.name &> /dev/null || ! git config --global user.email &> /dev/null; then
    print_info "Git is not configured. You may want to run:"
    echo "  git config --global user.name 'Your Name'"
    echo "  git config --global user.email 'your.email@example.com'"
fi

print_status "Git and GitHub CLI setup complete"

