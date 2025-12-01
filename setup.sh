#!/bin/bash

#####################################
#                                   #
#  Mac M2 Pro Setup Script          #
#  Modular dotfiles & apps setup    #
#                                   #
#####################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MODULES_DIR="$SCRIPT_DIR/modules"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Function to run a module
run_module() {
    local module_name=$1
    local module_file="$MODULES_DIR/$module_name.sh"
    
    if [[ -f "$module_file" ]]; then
        print_info "Running module: $module_name"
        bash "$module_file" "$SCRIPT_DIR" || {
            print_error "Module $module_name failed"
            return 1
        }
        print_status "Module $module_name completed"
    else
        print_error "Module $module_name.sh not found in $MODULES_DIR"
        return 1
    fi
}

# Main setup function
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║   Mac M2 Pro Setup Script              ║"
    echo "║   Setting up your development env      ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Check if running on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is designed for macOS only"
        exit 1
    fi
    
    # Create modules directory if it doesn't exist
    mkdir -p "$MODULES_DIR"
    
    # Run modules in order
    print_info "Starting setup process..."
    echo ""
    
    run_module "homebrew" || exit 1
    run_module "git" || exit 1
    run_module "oh-my-zsh" || exit 1
    run_module "zsh-plugins" || exit 1
    run_module "lsd" || exit 1
    run_module "fonts" || exit 1
    run_module "zshrc" || exit 1
    run_module "apps" || exit 1
    run_module "tmux" || exit 1
    
    echo ""
    print_status "Setup completed successfully! 🎉"
    print_warning "Please restart your terminal or run: source ~/.zshrc"
}

# Run main function
main "$@"

