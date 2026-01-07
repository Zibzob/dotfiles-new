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
- Download necessary Zsh plugins.
- Optionally install `fd-find` for faster directory search.

## Prerequisites

| Tool | Purpose |
|------|---------|
| `zsh` | The shell itself |
| `curl`/`git` | For downloading components |
| `fzf` | Fuzzy search (Ctrl+T, Alt+C, Ctrl+R) |
| `ripgrep` (`rg`) | Fast file searching with fzf |
| `bat` / `batcat` | Syntax-highlighted file previews |
| `fd-find` | Fast directory search (Alt+C) — *optional but recommended* |
| `eza` | Modern `ls` replacement with git awareness — *optional* |

---

## Features & Shortcuts

### 🚀 Core Stack
- **Shell**: `zsh` with **Oh My Zsh** framework
- **Theme**: **Powerlevel10k** — fast, info-rich prompt (Git status, execution time, icons)
- **Editor**: `vim` (configurable via `$EDITOR`)

### ⚡ Intelligent Typing

| Feature | Description |
|---------|-------------|
| **Autosuggestions** | Suggests commands from history (grey text) |
| **Accept Suggestion** | `Alt + l` |
| **Syntax Highlighting** | Green = valid command, Red = invalid |

### 🧭 Navigation & Jumping

| Shortcut | Action |
|----------|--------|
| `z <keyword>` | Smart jump to frequently used directories |
| `Ctrl + T` | Fuzzy find **files** with syntax-highlighted preview |
| `Alt + C` | Fuzzy find **directories** and cd into them |
| `Ctrl + R` | Fuzzy search command **history** |
| `Ctrl + /` | Toggle file preview (in fzf) |
| `Alt + j/k` | Navigate up/down in fzf results |

### ⌨️ Vi Mode

The shell uses Vim keybindings on the command line:

| Action | Keybinding |
|--------|------------|
| Switch to Normal Mode | `jj` or `Esc` |
| Key timeout | Optimized to `0.05s` for snappy switching |

### 🔍 Search Tools (FZF + Ripgrep + Bat)

- **Ctrl+T**: Find files using `ripgrep` (respects `.gitignore`, includes hidden files, excludes `.git/`)
- **Alt+C**: Find directories using `fd` (fast) or `find` (fallback)
- **Ctrl+R**: Fuzzy search command history
- **Preview**: Syntax-highlighted with `bat`, toggle with `Ctrl+/`

### 🐍 Auto Venv

Automatically activates `.venv` or `venv` when you `cd` into a directory containing one.

---

## Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `l` | `ls -alhF` | Detailed list with hidden files |
| `c` | `clear` | Clear terminal |
| `a` | `antigravity` | Launch Antigravity IDE |
| `mydu` | `du -h --max-depth=3 \| sort -rh \| head -n 15` | Disk usage summary |
| `bat` | `batcat` | Syntax highlighted `cat` |

### If `eza` is installed:

| Alias | Command | Description |
|-------|---------|-------------|
| `lt` | `eza --tree --git-ignore` | Tree view respecting .gitignore |
| `ll` | `eza -la --git --icons` | Detailed list with git status & icons |

---

## Quick Tips

**Preview a file with syntax highlighting:**
```bash
bat filename.py
```

**Search code (much faster than grep):**
```bash
rg "search_term" .
```

**Jump to a frequently used directory:**
```bash
z project    # Jumps to ~/dev/my-project if you've been there before
```

---

## Key Configuration Files

| File | Purpose |
|------|---------|
| `~/.zshrc` | Main config: plugins, keybindings, fzf settings, aliases |
| `~/.p10k.zsh` | Powerlevel10k theme configuration |
| `~/.fzf.zsh` | FZF shell integration (keybindings + completion) |
| `~/.gitconfig` | Global git configuration |
