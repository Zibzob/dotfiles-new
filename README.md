# My Portable Dotfiles

This repository contains my personal configuration files (dotfiles), designed to be simple, portable, and power-user friendly.

## Contents
- **zsh**: Zsh configuration with Powerlevel10k theme, plugins (autosuggestions, syntax highlighting), and custom aliases.
- **git**: Global git configuration.
- **scripts**: Utility scripts (if any).

## Installation

To install these dotfiles on a new machine:

1.  **Clone the repository**:
    ```bash
    git clone <your-repo-url> ~/dotfiles
    ```
    *(If you don't have a remote repo yet, just ensure this folder is at `~/dotfiles`)*

2.  **Run the install script**:
    ```bash
    cd ~/dotfiles
    ./install.sh
    ```

The script will:
- Back up your existing `.zshrc`, `.p10k.zsh`, and `.gitconfig` (renaming them with `.bak`).
- Create symlinks to the files in this repository.
- Install Oh My Zsh (if missing).
- download necessary Zsh plugins.

## Prerequisites
The following tools are recommended for the full experience:
- **zsh**: The shell itself.
- **curl/git**: For downloading components.
- **fzf**: For fuzzy search (Ctrl+T, Ctrl+R).
- **ripgrep (`rg`)**: For fast file searching with fzf.
- **bat** (or `batcat` on Ubuntu): For file previews.

## Key Features
- **Auto-Venv**: Automatically activates `.venv` or `venv` when you `cd` into a directory containing one.
- **Extract**: Helper function `extract <file>` handles tar, zip, gz, bz2, rar, etc.
- **Prompts**: Uses Powerlevel10k for a fast, informative prompt.
- **Vim Mode**: Zsh configured with `bindkey -v`. Type `jj` in insert mode to escape to normal mode.

## Custom Aliases
- `mydu`: Disk usage summary for current directory.
- `extract`: Smart archive extractor.
- `bat`: Syntax highlighted `cat`.
- `jj`: Escape to normal mode (in prompt).
