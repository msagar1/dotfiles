# ---- Path ----
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# ---- History ----
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY              # share history across sessions
setopt HIST_IGNORE_ALL_DUPS       # don't store duplicates
setopt HIST_REDUCE_BLANKS         # trim whitespace
setopt INC_APPEND_HISTORY         # write commands immediately

# ---- Tool integrations ----
eval "$(starship init zsh)"        # prompt
eval "$(zoxide init zsh)"          # smart cd → use `z foo`
source <(fzf --zsh)                # Ctrl+R fuzzy history, Ctrl+T fuzzy file

# ---- Aliases ----
alias ls="eza"
alias ll="eza -lah --git"
alias lt="eza --tree --level=2"
alias cat="bat"
alias grep="rg"

# Git shortcuts
alias gs="git status"
alias gd="git diff"
alias gp="git pull"
alias gco="git checkout"
alias gcm="git commit -m"

# ---- Editor ----
export EDITOR="cursor"   # or "code" or "nvim"

# Open the code directory
alias cdc="cd ~/code"

# ---- Node / pnpm ----
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
