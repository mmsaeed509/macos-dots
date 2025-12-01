#!/bin/bash

# Exodia fonts installation module

SCRIPT_DIR=$1
FONTS_DIR="$SCRIPT_DIR/exodia-fonts"
FONT_INSTALL_DIR="$HOME/Library/Fonts"

print_status() {
    echo -e "\033[0;32m[✓]\033[0m $1"
}

print_info() {
    echo -e "\033[0;34m[i]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m[✗]\033[0m $1"
}

print_info "Installing Exodia fonts..."

# Check if fonts directory exists
if [[ ! -d "$FONTS_DIR" ]]; then
    print_error "Fonts directory not found: $FONTS_DIR"
    exit 1
fi

# Create fonts directory if it doesn't exist
mkdir -p "$FONT_INSTALL_DIR"

# Count fonts to install
font_count=$(find "$FONTS_DIR" -type f \( -name "*.ttf" -o -name "*.otf" -o -name "*.bdf" \) | wc -l | tr -d ' ')

if [[ $font_count -eq 0 ]]; then
    print_error "No font files found in $FONTS_DIR"
    exit 1
fi

print_info "Found $font_count font files to install"

# Install fonts
installed=0
# Use find to get all font files and process them
for font in "$FONTS_DIR"/*.ttf "$FONTS_DIR"/*.otf "$FONTS_DIR"/*.bdf; do
    # Check if file exists (glob might not match)
    [[ -f "$font" ]] || continue
    font_name=$(basename "$font")
    if [[ ! -f "$FONT_INSTALL_DIR/$font_name" ]]; then
        cp "$font" "$FONT_INSTALL_DIR/"
        ((installed++))
    fi
done

print_status "Installed $installed fonts (some may have already been installed)"

# Refresh font cache on macOS
print_info "Refreshing font cache..."
# On macOS, fonts are usually available immediately, but we can try to refresh
# Touch the Fonts directory to trigger a refresh
touch "$FONT_INSTALL_DIR" 2>/dev/null || true

# Try fontconfig if available (common with Homebrew)
if command -v fc-cache &> /dev/null; then
    fc-cache -f -v "$FONT_INSTALL_DIR" 2>/dev/null && print_status "Font cache refreshed"
fi

# Set JetBrainsMono Nerd Font as default terminal font
print_info "Setting JetBrainsMono Nerd Font as default terminal font..."

# Get the default terminal profile
TERMINAL_PROFILE=$(defaults read com.apple.Terminal "Default Window Settings" 2>/dev/null || echo "Basic")
PROFILE_PLIST="$HOME/Library/Preferences/com.apple.Terminal.plist"

# Use PlistBuddy to set the font
if command -v /usr/libexec/PlistBuddy &> /dev/null && [[ -f "$PROFILE_PLIST" ]]; then
    # Try to set the font for the current profile
    /usr/libexec/PlistBuddy -c "Set :'Window Settings':$TERMINAL_PROFILE:Font 'JetBrainsMono Nerd Font'" "$PROFILE_PLIST" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :'Window Settings':$TERMINAL_PROFILE:Font string 'JetBrainsMono Nerd Font'" "$PROFILE_PLIST" 2>/dev/null || true
    
    print_status "Terminal font configured to 'JetBrainsMono Nerd Font'"
    print_info "Restart Terminal.app for changes to take effect"
else
    print_warning "Could not automatically set terminal font"
    print_info "Please manually set 'JetBrainsMono Nerd Font' in Terminal → Preferences → Profiles → Text"
fi

print_status "Fonts setup complete"
print_info "Note: Restart your terminal for the font changes to take effect"

