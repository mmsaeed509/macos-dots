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
    local extra_arg=$2
    local module_file="$MODULES_DIR/$module_name.sh"
    
    if [[ -f "$module_file" ]]; then
        print_info "Running module: $module_name"
        if [[ -n "$extra_arg" ]]; then
            bash "$module_file" "$SCRIPT_DIR" "$extra_arg" || {
                print_error "Module $module_name failed"
                return 1
            }
        else
            bash "$module_file" "$SCRIPT_DIR" || {
                print_error "Module $module_name failed"
                return 1
            }
        fi
        print_status "Module $module_name completed"
    else
        print_error "Module $module_name.sh not found in $MODULES_DIR"
        return 1
    fi
}

# Parse command line arguments
INSTALL_APPS=""
APPS_YAML_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --install-apps)
            INSTALL_APPS="true"
            APPS_YAML_FILE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --install-apps <file>    Install applications from specified YAML file"
            echo "  -h, --help              Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

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
    
    # Only run apps module if --install-apps flag is provided
    if [[ "$INSTALL_APPS" == "true" ]]; then
        if [[ -n "$APPS_YAML_FILE" && -f "$APPS_YAML_FILE" ]]; then
            print_info "Installing apps from: $APPS_YAML_FILE"
            run_module "apps" "$APPS_YAML_FILE" || exit 1
        else
            print_error "Apps YAML file not found: $APPS_YAML_FILE"
            exit 1
        fi
    else
        print_info "Skipping apps installation (use --install-apps <file> to install apps)"
    fi
    
    run_module "tmux" || exit 1
    
    echo ""
    print_status "Setup completed successfully! 🎉"
    print_warning "Please restart your terminal or run: source ~/.zshrc"
}

# Run main function
main "$@"

