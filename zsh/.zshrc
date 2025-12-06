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
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

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
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# -- General FZF Options --
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --bind 'alt-j:down,alt-k:up'"

# -- File Search (Ctrl+T) --
# Use 'rg' (Ripgrep) if available
if command -v rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    
    # -- Directory Search (Alt+C) --
    # Use rg to find directories only
    export FZF_ALT_C_COMMAND='rg --files --null --hidden --follow --glob "!.git/*" --null-separator | xargs -0 dirname | sort -u'
fi

# -- Preview Settings --
# Show preview with 'bat' or 'batcat' when selecting files
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
# 7. FINAL THEME CONFIGURATION
# =============================================================================

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh