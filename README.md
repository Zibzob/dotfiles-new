# My Portable Dotfiles

This repository contains my personal configuration files (dotfiles), designed to be simple, portable, and power-user friendly. Perfect for setting up a fresh Ubuntu/WSL2 environment.

## Contents

- **zsh/**: Zsh configuration with Powerlevel10k theme, plugins (autosuggestions, syntax highlighting), and custom aliases.
- **git/**: Global git configuration.
- **vscode/**: Editor settings for VSCode/Antigravity/Cursor (copy to Windows, not symlinked).

## Quick Start

On a fresh Ubuntu/WSL2 environment:

```bash
# 1. Clone the repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# 2. Make the script executable and run it
chmod +x install.sh
./install.sh

# 3. Restart your terminal or run:
exec zsh
```

The script will interactively:
- Install `zsh` if missing and set it as your default shell
- Install recommended tools (`curl`, `git`, `fzf`, `ripgrep`, `bat`, `eza`)
- Install Oh My Zsh and Powerlevel10k theme
- Install zsh plugins (autosuggestions, syntax-highlighting)
- Symlink your `.zshrc`, `.p10k.zsh`, and `.gitconfig`

## Editor Setup (VSCode/Antigravity/Cursor)

Since the editor runs on Windows (connecting to WSL via Remote), settings live on the Windows side.

1. **Copy settings manually** from `vscode/settings.json` to:
   - **VS Code**: `%APPDATA%\Code\User\settings.json`
   - **Antigravity**: `%APPDATA%\Antigravity\User\settings.json`
   - **Cursor**: `%APPDATA%\Cursor\User\settings.json`

2. **Set zsh as default terminal** in your editor:
   - Open Settings (Ctrl+,)
   - Search for `terminal.integrated.defaultProfile.linux`
   - Set it to `zsh`

3. **Install a Nerd Font** for Powerlevel10k icons:
   - Download [MesloLGS NF](https://github.com/romkatv/powerlevel10k#fonts)
   - Install on Windows and set as terminal font in your editor

## Prerequisites

The install script will offer to install these if missing:

| Tool | Purpose |
|------|---------|
| `zsh` | The shell itself |
| `curl` | For downloading Oh My Zsh |
| `git` | For cloning plugins and themes |
| `fzf` | Fuzzy finder (Ctrl+T, Ctrl+R) |
| `ripgrep` (`rg`) | Fast file searching with fzf |
| `bat` | Syntax-highlighted `cat` (for file previews) |
| `eza` | Modern `ls` replacement with git awareness |

## Key Features

- **Auto-Venv**: Automatically activates `.venv` or `venv` when you `cd` into a directory containing one.
- **Extract**: Helper function `extract <file>` handles tar, zip, gz, bz2, rar, etc.
- **Prompts**: Uses Powerlevel10k for a fast, informative prompt.
- **Vim Mode**: Zsh configured with `bindkey -v`. Type `jj` in insert mode to escape to normal mode.

## Custom Aliases

- `mydu`: Disk usage summary for current directory.
- `extract`: Smart archive extractor.
- `bat`: Syntax highlighted `cat` (aliased to `batcat` on Ubuntu).
- `jj`: Escape to normal mode (in prompt).
- `lt`: Tree view respecting `.gitignore` (requires `eza`).
- `ll`: Detailed list with git status & icons (requires `eza`).

## eza — Tree & File Listing

[eza](https://github.com/eza-community/eza) is a modern replacement for `ls` with built-in git awareness, colors, and icons.

### Quick Reference

| Command | Description |
|---------|-------------|
| `lt` | Tree view, respects `.gitignore` |
| `lt -L 2` | Tree view, max depth 2 |
| `ll` | Detailed list with git status & icons |
| `eza -la` | List all files (long format) |
| `eza --tree` | Full tree (ignores nothing) |
| `eza --tree -a --git-ignore` | Tree with hidden files, respects `.gitignore` |

### Common Use Cases

```bash
# See project structure without node_modules, .git, etc.
lt

# Limit depth for large projects
lt -L 3

# See git status of files in current directory
ll

# Full tree including hidden files
eza --tree -a --git-ignore
```

## Repository Structure

```
dotfiles/
├── install.sh          # Main installation script
├── README.md
├── zsh/
│   ├── .zshrc          # Zsh configuration
│   └── .p10k.zsh       # Powerlevel10k theme config
├── git/
│   └── .gitconfig      # Git configuration
└── vscode/
    ├── settings.json   # Editor settings (copy to Windows)
    ├── keybindings.json
    └── extensions.txt  # Extensions list
```

## Updating

To update your dotfiles after making changes:

```bash
cd ~/dotfiles
git add .
git commit -m "Update dotfiles"
git push
```

To pull updates on another machine:

```bash
cd ~/dotfiles
git pull
./install.sh  # Re-run to apply any new symlinks
```
