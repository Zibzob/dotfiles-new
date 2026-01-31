# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# 1. CORE ENVIRONMENT
# =============================================================================

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set Preferred Editor
export EDITOR='vim'

# Automatically cd when command is unknown but recognized as a valid directory
# Allows omitting 'cd' when navigating, e.g. just type '/some/dir' or use Alt-C (fzf)
setopt auto_cd

# =============================================================================
# 2. OH-MY-ZSH SETTINGS
# =============================================================================

# Theme: Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
# - git: aliases and helper functions
# - zsh-autosuggestions: suggests commands as you type (grey text)
# - zsh-syntax-highlighting: highlights commands (green/red)
# - z: tracks your most used directories, use 'z folder_name' to jump
plugins=(git zsh-autosuggestions zsh-syntax-highlighting z)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# 3. ALIASES & FUNCTIONS
# =============================================================================

# Alias 'bat' to 'batcat' (Ubuntu package name) for syntax highlighting
if command -v batcat &> /dev/null; then
    alias bat='batcat'
fi

alias mydu="du -h --max-depth=3 . | sort -rh | head -n 15"
alias ..='cd ..'
alias ...='cd ../..'
alias l='ls -alhF'
alias c='clear'
alias a="antigravity"
# Uses find to list files and sed to format the output into a tree-like structure:
# - find . -print: recursively lists all files and directories
# - s;[^/]*/;|____;g: replaces each directory level with indentation markers
# - s;____|; |;g: cleans up vertical bars for visual alignment
# alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# eza: modern ls replacement with git awareness
# - lt: tree view respecting .gitignore
# - ll: detailed list view with git status
if command -v eza &> /dev/null; then
    alias lt='eza --tree --git-ignore'
    alias ll='eza -la --git --icons'
fi

# =============================================================================
# 4. KEYBINDINGS & VIM MODE
# =============================================================================

# Enable Vi-mode
bindkey -v

# Reduce key sequence delay to 0.05s for snappy mode switching (default is 0.4s)
export KEYTIMEOUT=50

# Map 'jj' to switch to Normal Mode (vi-cmd-mode) quickly
bindkey -M viins 'jj' vi-cmd-mode

# -- Autosuggestions --
# Accept suggestion with Alt+l (represented as ^[l in zsh)
bindkey -M viins '^[l' autosuggest-accept
bindkey -M vicmd '^[l' autosuggest-accept

# =============================================================================
# 5. FZF & SEARCH INTEGRATION
# =============================================================================

# Source FZF shell integration (keybindings and completion)
# Supports both git-based install (~/.fzf.zsh) and apt-based install (/usr/share/doc/fzf/examples/)
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
elif [ -d /usr/share/doc/fzf/examples ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
fi

# -- General FZF Options --
# - height 40%: keeps context visible
# - layout=reverse: input at top
# - bind: use alt-j/k for navigation
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --bind 'alt-j:down,alt-k:up'"

# -- File Search (Ctrl+T) --
# Use 'rg' (Ripgrep) if available:
# - Respects .gitignore
# - Includes hidden files (e.g. .config)
# - Follows symlinks
# - Excludes .git directory
if command -v rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    
fi

# -- Directory Search (Alt+C) --
# Prefer 'fd' (fast) over 'find' (fallback)
if command -v fdfind &> /dev/null; then
    export FZF_ALT_C_COMMAND='fdfind --type d --hidden --exclude .git'
elif command -v fd &> /dev/null; then
    export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
else
    export FZF_ALT_C_COMMAND='find . -type d \( -name .git -o -name node_modules -o -name __pycache__ \) -prune -o -type d -print 2>/dev/null'
fi

# Preview directory contents when selecting with Alt+C
export FZF_ALT_C_OPTS="--preview 'ls -la {}'"

# -- Preview Settings --
# Show preview with 'bat' or 'batcat' when selecting files
# - style=numbers: show line numbers
# - color=always: preserve syntax highlighting
# - line-range :500: limit to first 500 lines for performance
if command -v batcat &> /dev/null; then
    _BAT_CMD="batcat"
elif command -v bat &> /dev/null; then
    _BAT_CMD="bat"
else
    _BAT_CMD="cat"
fi

export FZF_CTRL_T_OPTS="
  --preview '$_BAT_CMD --style=numbers --color=always --line-range :500 {}'
  --preview-window 'right:60%'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# =============================================================================
# 6. AUTO VENV ACTIVATION
# =============================================================================
# Auto-activate Python venv if present (Ported from .bashrc logic, adapted for zsh)
function chpwd() {
    if [ -d ".venv" ]; then
        source .venv/bin/activate
    elif [ -d "venv" ]; then
        source venv/bin/activate
    fi
}
# Run once on init
chpwd

# =============================================================================
# 7. EXTERNAL TOOLS
# =============================================================================

# Source uv/ruff environment if available
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# =============================================================================
# 8. FINAL THEME CONFIGURATION
# =============================================================================

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh