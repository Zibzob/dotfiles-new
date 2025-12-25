#!/bin/bash

# Define dotfiles directory dynamically (based on script location)
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "========================================"
echo "  Dotfiles Installation Script"
echo "========================================"
echo "Dotfiles location: $DOTFILES"
echo ""

# Function to backup and symlink
link_file() {
    local src=$1
    local dest=$2

    if [ -e "$dest" ]; then
        if [ -L "$dest" ]; then
            local current_link=$(readlink "$dest")
            if [ "$current_link" == "$src" ]; then
                echo "  ✅ Already linked: $dest -> $src"
                return
            fi
        fi
        echo "  📦 Backing up existing $dest to ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    echo "  🔗 Creating symlink: $dest -> $src"
    ln -s "$src" "$dest"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# ============================================
# 1. Install Zsh (if missing)
# ============================================
echo "--- [1/7] Zsh Installation ---"
if command_exists zsh; then
    echo "  ✅ Zsh is already installed: $(zsh --version)"
else
    echo "  ⚠️  Zsh is not installed."
    read -p "  Install zsh? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        echo "  📥 Installing zsh..."
        sudo apt update && sudo apt install -y zsh
        if command_exists zsh; then
            echo "  ✅ Zsh installed successfully."
        else
            echo "  ❌ Failed to install zsh. Exiting."
            exit 1
        fi
    else
        echo "  ⏭️  Skipping zsh installation. Note: This dotfiles setup requires zsh."
    fi
fi

# ============================================
# 2. Set Zsh as default shell
# ============================================
echo ""
echo "--- [2/7] Default Shell ---"
current_shell=$(basename "$SHELL")
if [ "$current_shell" = "zsh" ]; then
    echo "  ✅ Zsh is already your default shell."
else
    echo "  ⚠️  Current default shell: $current_shell"
    read -p "  Set zsh as your default shell? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        chsh -s "$(which zsh)"
        echo "  ✅ Default shell changed to zsh. Changes take effect on next login."
    else
        echo "  ⏭️  Skipping default shell change."
    fi
fi

# ============================================
# 3. Install recommended tools
# ============================================
echo ""
echo "--- [3/7] Recommended Tools ---"

install_tool() {
    local cmd=$1
    local pkg=${2:-$1}  # Package name, defaults to command name
    
    if command_exists "$cmd"; then
        echo "  ✅ $cmd is installed."
        return 0
    else
        echo "  ⚠️  $cmd is not installed."
        read -p "    Install $pkg? [Y/n] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
            sudo apt install -y "$pkg"
            return $?
        fi
        return 1
    fi
}

# Check for curl (needed for oh-my-zsh)
install_tool "curl" "curl"

# Check for git (needed for cloning plugins)
install_tool "git" "git"

# Poweruser tools
install_tool "fzf" "fzf"
install_tool "rg" "ripgrep"

# bat is called batcat on Ubuntu/Debian
if command_exists bat || command_exists batcat; then
    echo "  ✅ bat is installed."
else
    echo "  ⚠️  bat is not installed."
    read -p "    Install bat? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        sudo apt install -y bat
    fi
fi

# eza (modern ls replacement with git awareness) - requires adding repository
if command_exists eza; then
    echo "  ✅ eza is installed."
else
    echo "  ⚠️  eza is not installed."
    read -p "    Install eza? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        echo "  📥 Adding eza repository..."
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        sudo apt update
        sudo apt install -y eza
        echo "  ✅ eza installed."
    fi
fi

# ============================================
# 4. Install Oh My Zsh
# ============================================
echo ""
echo "--- [4/7] Oh My Zsh ---"
# Check for actual oh-my-zsh.sh file, not just directory (plugins may create ~/.oh-my-zsh/custom before OMZ is installed)
if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    echo "  ✅ Oh My Zsh is already installed."
else
    echo "  📥 Installing Oh My Zsh..."
    # Remove potentially incomplete installation
    [ -d "$HOME/.oh-my-zsh" ] && rm -rf "$HOME/.oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
        echo "  ✅ Oh My Zsh installed."
    else
        echo "  ❌ Oh My Zsh installation failed. Please check your network connection."
        exit 1
    fi
fi

# ============================================
# 5. Install Powerlevel10k Theme
# ============================================
echo ""
echo "--- [5/7] Powerlevel10k Theme ---"
P10K_DIR="${ZSH_CUSTOM}/themes/powerlevel10k"
if [ -d "$P10K_DIR" ]; then
    echo "  ✅ Powerlevel10k is already installed."
else
    echo "  📥 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    echo "  ✅ Powerlevel10k installed."
fi

# ============================================
# 6. Install Zsh Plugins
# ============================================
echo ""
echo "--- [6/7] Zsh Plugins ---"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "  📥 Cloning zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "  ✅ zsh-autosuggestions already installed."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "  📥 Cloning zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "  ✅ zsh-syntax-highlighting already installed."
fi

# ============================================
# 7. Symlink Configuration Files
# ============================================
echo ""
echo "--- [7/7] Configuration Files ---"
link_file "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
link_file "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"

# ============================================
# Done!
# ============================================
echo ""
echo "========================================"
echo "  ✅ Installation Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: exec zsh"
echo "  2. If using VSCode/Antigravity, set your default terminal to zsh:"
echo "     - Open Settings (Ctrl+,)"
echo "     - Search for 'terminal.integrated.defaultProfile.linux'"
echo "     - Set it to 'zsh'"
echo ""
echo "  3. Your editor settings are stored in: $DOTFILES/vscode/"
echo "     Copy them to your Windows editor config folder if needed."
echo ""
echo "Enjoy your new shell! 🚀"
