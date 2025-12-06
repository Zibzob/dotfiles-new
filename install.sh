#!/bin/bash

# Define dotfiles directory
DOTFILES="$HOME/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "Starting Dotfiles Installation..."

# Function to backup and symlink
link_file() {
    local src=$1
    local dest=$2

    if [ -e "$dest" ]; then
        if [ -L "$dest" ]; then
            local current_link=$(readlink "$dest")
            if [ "$current_link" == "$src" ]; then
                echo "Already linked: $dest -> $src"
                return
            fi
        fi
        echo "Backing up existing $dest to ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    echo "Creating symlink: $dest -> $src"
    ln -s "$src" "$dest"
}

# 1. Symlink Configuration Files
echo "--- configuration files ---"
link_file "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
link_file "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"

# 2. Check/Install Oh My Zsh
echo "--- oh-my-zsh ---"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh is already installed."
fi

# 3. Install Plugins
echo "--- plugins ---"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Cloning zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions already installed."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Cloning zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting already installed."
fi

# 4. Check for Poweruser Tools
echo "--- poweruser tools check ---"
check_tool() {
    if ! command -v "$1" &> /dev/null; then
        echo "⚠️  '$1' not found. Recommended for full experience."
    else
        echo "✅ '$1' found."
    fi
}

check_tool "nvim"
check_tool "rg"
check_tool "fzf"

if command -v batcat &> /dev/null || command -v bat &> /dev/null; then
    echo "✅ 'bat' found."
else
    echo "⚠️  'bat' (or 'batcat') not found. Recommended for file previews."
fi

echo "--- completion ---"
echo "Installation complete! Please restart your shell or run 'source ~/.zshrc'."
