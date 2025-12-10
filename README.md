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
9. **Applications** (configurable via `apps.yaml`):
   - **GUI Apps**: Kiro, Cursor, Brave Browser, Termius, Discord, OBS Studio, RustDesk, VirtualBox, Docker
   - **CLI Tools**: Podman, Minikube, kubectl, OpenShift CLI (oc), tmux, Azure CLI, Neovim
   - **Extensions**: Azure DevOps CLI extension
   - **Special**: NvChad (Neovim configuration)
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

#### Basic Setup (without applications)
```bash
./setup.sh
```

#### Full Setup with Applications
```bash
./setup.sh --install-apps apps.yaml
```

#### Help
```bash
./setup.sh --help
```

### Running Individual Modules

You can also run individual modules if you only need to install specific components:

```bash
# Example: Install only fonts
./modules/fonts.sh /path/to/repo

# Example: Install only apps from YAML config
./modules/apps.sh /path/to/repo apps.yaml
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

Applications are now configured via the `apps.yaml` file, which provides a structured way to manage installations:

#### YAML Structure

```yaml
apps:
  # GUI Applications (Homebrew Cask)
  cask:
    - name: cursor
      package: cursor
    - name: kiro
      package: kiro
      skip: true  # Skip installation

  # CLI Tools (Homebrew)
  brew:
    - name: kubectl
      package: kubectl
    - name: openshift-cli
      package: openshift-cli

  # Extensions
  extensions:
    - name: azure-devops
      type: az-extension

  # Special installations
  special:
    - name: nvchad
      type: git-clone
```

#### Adding/Removing Applications

1. **Add new application**: Add entry to appropriate section in `apps.yaml`
2. **Skip installation**: Set `skip: true` for any application
3. **Remove application**: Either delete the entry or set `skip: true`

#### Skip Functionality

Use the `skip` field to temporarily disable installation of specific packages:

```yaml
- name: virtualbox
  package: virtualbox
  skip: true  # This will be skipped during installation
```

When skipped, the installer will show a warning message and continue with other packages.

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


## Configuration Files

### apps.yaml

The `apps.yaml` file controls which applications are installed. It supports:

- **Multiple installation types**: cask, brew, extensions, special
- **Skip functionality**: Set `skip: true` to skip any package
- **Package mapping**: Use different package names than display names
- **Structured organization**: Clear separation of GUI apps, CLI tools, etc.

### Command Line Options

- `--install-apps <file>`: Install applications from specified YAML file
- `--help`: Show usage information

## Notes

- **Backup**: The script will backup your existing `.zshrc` before overwriting it (saved as `~/.zshrc.backup.YYYYMMDD_HHMMSS`)
- **Duplicate detection**: If applications are already installed, the script will skip them
- **Manual installation**: Some applications (like Kiro) may not be available in Homebrew and are marked with `skip: true` by default
- **Font changes**: If the font does not change after installation, you must change it manually in your terminal settings
- **Selective installation**: Applications are only installed when using the `--install-apps` flag
- **Python dependency**: The YAML parser uses Python3 with PyYAML when available, falls back to AWK parsing
- **Modular design**: Each component can be run independently or skipped as needed