#!/bin/bash

# Applications installation module

SCRIPT_DIR=$1
APPS_YAML_FILE=$2

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

# Check if apps YAML file is provided
if [[ -z "$APPS_YAML_FILE" ]]; then
    print_error "No apps YAML file provided"
    exit 1
fi

if [[ ! -f "$APPS_YAML_FILE" ]]; then
    print_error "Apps YAML file not found: $APPS_YAML_FILE"
    exit 1
fi

print_info "Installing applications from: $APPS_YAML_FILE"

# Function to install app via Homebrew Cask
install_cask() {
    local app_name=$1
    local cask_name=${2:-$app_name}
    
    if brew list --cask "$cask_name" &> /dev/null; then
        print_status "$app_name is already installed"
    else
        print_info "Installing $app_name..."
        if brew install --cask "$cask_name"; then
            print_status "$app_name installed"
        else
            print_warning "Failed to install $app_name via Homebrew Cask"
            return 1
        fi
    fi
}

# Function to install CLI tool via Homebrew
install_brew() {
    local tool_name=$1
    local package_name=${2:-$tool_name}
    
    if command -v "$tool_name" &> /dev/null || brew list "$package_name" &> /dev/null 2>&1; then
        print_status "$tool_name is already installed"
    else
        print_info "Installing $tool_name..."
        if brew install "$package_name"; then
            print_status "$tool_name installed"
        else
            print_warning "Failed to install $tool_name"
            return 1
        fi
    fi
}

# Function to install Azure DevOps extension
install_azure_devops_extension() {
    if command -v az &> /dev/null; then
        print_info "Installing Azure DevOps CLI extension..."
        if az extension list --query "[?name=='azure-devops'].name" -o tsv 2>/dev/null | grep -q "azure-devops"; then
            print_status "Azure DevOps extension is already installed"
        else
            if az extension add --name azure-devops 2>/dev/null; then
                print_status "Azure DevOps extension installed"
            else
                print_warning "Failed to install Azure DevOps extension"
            fi
        fi
    else
        print_warning "Azure CLI not found, skipping Azure DevOps extension installation"
    fi
}

# Function to install NvChad
install_nvchad() {
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
}

# Function to parse YAML and extract values
parse_yaml() {
    local yaml_file=$1
    local section=$2
    
    # Extract items from specific section with name, package, and skip fields
    python3 -c "
import yaml
import sys

try:
    with open('$yaml_file', 'r') as f:
        data = yaml.safe_load(f)
    
    if 'apps' in data and '$section' in data['apps']:
        for item in data['apps']['$section']:
            name = item.get('name', '')
            package = item.get('package', name)
            skip = str(item.get('skip', False)).lower()
            print(f'{name}:{package}:{skip}')
except Exception as e:
    # Fallback to simple parsing if Python/PyYAML not available
    pass
" 2>/dev/null || {
        # Fallback parser using awk (simpler version)
        awk -v section="$section" '
        BEGIN { in_section = 0; in_apps = 0; in_item = 0 }
        /^apps:/ { in_apps = 1; next }
        in_apps && /^  [a-zA-Z]/ { 
            current_section = $1
            gsub(/:/, "", current_section)
            gsub(/^ +/, "", current_section)
            in_section = (current_section == section)
            next
        }
        in_section && /^    - name:/ {
            if (in_item) print name ":" package ":" skip
            gsub(/^    - name: /, "")
            name = $0
            package = name
            skip = "false"
            in_item = 1
            next
        }
        in_section && in_item && /^      package:/ {
            gsub(/^      package: /, "")
            package = $0
            next
        }
        in_section && in_item && /^      skip:/ {
            gsub(/^      skip: /, "")
            skip = $0
            next
        }
        in_section && /^  [a-zA-Z]/ { 
            if (in_item) print name ":" package ":" skip
            in_section = 0; in_item = 0
        }
        END { if (in_item) print name ":" package ":" skip }
        ' "$yaml_file"
    }
}

# Function to parse extensions from YAML
parse_extensions() {
    local yaml_file=$1
    
    python3 -c "
import yaml
import sys

try:
    with open('$yaml_file', 'r') as f:
        data = yaml.safe_load(f)
    
    if 'apps' in data and 'extensions' in data['apps']:
        for item in data['apps']['extensions']:
            name = item.get('name', '')
            ext_type = item.get('type', '')
            skip = str(item.get('skip', False)).lower()
            print(f'{name}:{ext_type}:{skip}')
except Exception as e:
    pass
" 2>/dev/null || {
        # Fallback parser
        awk '
        BEGIN { in_extensions = 0; in_apps = 0; in_item = 0 }
        /^apps:/ { in_apps = 1; next }
        in_apps && /^  extensions:/ { in_extensions = 1; next }
        in_extensions && /^  [a-zA-Z]/ { 
            if (in_item) print name ":" type ":" skip
            in_extensions = 0; in_item = 0
        }
        in_extensions && /^    - name:/ {
            if (in_item) print name ":" type ":" skip
            gsub(/^    - name: /, "")
            name = $0
            type = ""
            skip = "false"
            in_item = 1
            next
        }
        in_extensions && in_item && /^      type:/ {
            gsub(/^      type: /, "")
            type = $0
            next
        }
        in_extensions && in_item && /^      skip:/ {
            gsub(/^      skip: /, "")
            skip = $0
            next
        }
        END { if (in_item) print name ":" type ":" skip }
        ' "$yaml_file"
    }
}

# Function to parse special installations from YAML
parse_special() {
    local yaml_file=$1
    
    python3 -c "
import yaml
import sys

try:
    with open('$yaml_file', 'r') as f:
        data = yaml.safe_load(f)
    
    if 'apps' in data and 'special' in data['apps']:
        for item in data['apps']['special']:
            name = item.get('name', '')
            skip = str(item.get('skip', False)).lower()
            print(f'{name}:{skip}')
except Exception as e:
    pass
" 2>/dev/null || {
        # Fallback parser
        awk '
        BEGIN { in_special = 0; in_apps = 0; in_item = 0 }
        /^apps:/ { in_apps = 1; next }
        in_apps && /^  special:/ { in_special = 1; next }
        in_special && /^  [a-zA-Z]/ { 
            if (in_item) print name ":" skip
            in_special = 0; in_item = 0
        }
        in_special && /^    - name:/ {
            if (in_item) print name ":" skip
            gsub(/^    - name: /, "")
            name = $0
            skip = "false"
            in_item = 1
            next
        }
        in_special && in_item && /^      skip:/ {
            gsub(/^      skip: /, "")
            skip = $0
            next
        }
        END { if (in_item) print name ":" skip }
        ' "$yaml_file"
    }
}

# Install Homebrew Cask applications
print_info "Installing Homebrew Cask applications..."
while IFS=':' read -r name package skip; do
    [[ -z "$name" ]] && continue
    if [[ "$skip" == "true" ]]; then
        print_warning "Skipping $name (skip: true)"
        continue
    fi
    install_cask "$name" "$package"
done < <(parse_yaml "$APPS_YAML_FILE" "cask")

# Install Homebrew CLI tools
print_info "Installing Homebrew CLI tools..."
while IFS=':' read -r name package skip; do
    [[ -z "$name" ]] && continue
    if [[ "$skip" == "true" ]]; then
        print_warning "Skipping $name (skip: true)"
        continue
    fi
    install_brew "$name" "$package"
done < <(parse_yaml "$APPS_YAML_FILE" "brew")

# Install extensions
print_info "Installing extensions..."
while IFS=':' read -r name type skip; do
    [[ -z "$name" ]] && continue
    if [[ "$skip" == "true" ]]; then
        print_warning "Skipping $name extension (skip: true)"
        continue
    fi
    case "$name" in
        "azure-devops")
            install_azure_devops_extension
            ;;
        *)
            print_warning "Unknown extension: $name"
            ;;
    esac
done < <(parse_extensions "$APPS_YAML_FILE")

# Install special applications
print_info "Installing special applications..."
while IFS=':' read -r name skip; do
    [[ -z "$name" ]] && continue
    if [[ "$skip" == "true" ]]; then
        print_warning "Skipping $name (skip: true)"
        continue
    fi
    case "$name" in
        "nvchad")
            install_nvchad
            ;;
        *)
            print_warning "Unknown special installation: $name"
            ;;
    esac
done < <(parse_special "$APPS_YAML_FILE")

print_status "Applications setup complete"