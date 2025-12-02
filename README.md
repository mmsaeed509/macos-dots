# Mac M2 Pro Setup Scripts

Modular setup scripts for configuring your Mac M2 Pro development environment with dotfiles and applications.

## What This Setup Does

The setup script will install and configure:

1. **Homebrew** - Package manager for macOS
2. **Git** - Version control system
3. **GitHub CLI** - Command-line interface for GitHub
4. **Oh My Zsh** - Zsh configuration framework
5. **Oh My Zsh Plugins**:
   - zsh-autosuggestions
   - zsh-syntax-highlighting
   - web-search
6. **lsd** - Modern `ls` replacement with colors and icons
7. **Exodia Fonts** - All fonts from the `exodia-fonts/` directory
8. **Zsh Configuration** - Custom `.zshrc` with:
   - Homebrew aliases (replacing Pacman aliases)
   - Custom prompt
   - Updated ASCII art (ozil instead of Exodia OS)
   - macOS-specific aliases
9. **Applications**:
   - Kiro
   - Cursor
   - Brave Browser
   - Termius
   - Discord
   - OBS Studio
   - Neovim
   - NvChad (Neovim configuration)
   - tmux
10. **tmux Configuration**:
   - TPM (tmux plugin manager)
   - Catppuccin theme
   - Custom tmux configuration

## Usage

### Making Scripts Executable

Before running the setup, make all scripts executable:

```bash
chmod +x setup.sh modules/*.sh
```

### Running the Setup

```bash
./setup.sh
```

### Running Individual Modules

You can also run individual modules if you only need to install specific components:

```bash
# Example: Install only fonts
./modules/fonts.sh /path/to/repo

# Example: Install only apps
./modules/apps.sh /path/to/repo
```

## Module Structure

The setup is organized into modular scripts:

- `setup.sh` - Main orchestrator script
- `modules/homebrew.sh` - Homebrew installation
- `modules/git.sh` - Git and GitHub CLI setup
- `modules/oh-my-zsh.sh` - Oh My Zsh installation
- `modules/zsh-plugins.sh` - Oh My Zsh plugins
- `modules/lsd.sh` - lsd installation
- `modules/fonts.sh` - Font installation
- `modules/zshrc.sh` - Zsh configuration setup
- `modules/apps.sh` - Application installations
- `modules/tmux.sh` - tmux configuration setup

### Application Configuration

Applications are installed via Homebrew Cask (for GUI apps) or Homebrew formulas (for CLI tools). To add or remove applications, edit the `modules/apps.sh` file.

## Customizations

### Zsh Configuration

The `zshrc.txt` file contains your custom zsh configuration with:
- Homebrew aliases (replacing Pacman commands)
- Custom prompt
- ASCII art (ozil)
- macOS-specific aliases

The setup script copies `zshrc.txt` directly to `~/.zshrc` without modifications, so you can customize `zshrc.txt` as needed.

### Homebrew Aliases

The following aliases are created (replacing Pacman commands):

- `b-sync` → `brew update`
- `install` → `brew install`
- `ipkg` → `brew install --cask`
- `update` → `brew update && brew upgrade`
- `search` → `brew search`
- `search-local` → `brew list`
- `pkg-info` → `brew info`
- `clr-cache` → `brew cleanup`
- `remove` → `brew uninstall`
- `autoremove` → `brew autoremove`


## Notes

- The script will backup your existing `.zshrc` before overwriting it (saved as `~/.zshrc.backup.YYYYMMDD_HHMMSS`)
- If applications are already installed, the script will skip them
- Some applications (like Kiro) may not be available in Homebrew and may need manual installation
- If the font does not change, you must change it manually.