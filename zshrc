# ---- Path ----
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="$HOME/scripts:$PATH"

# ---- SSH (1Password agent) ----
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# ---- History ----
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY              # share history across sessions
setopt HIST_IGNORE_ALL_DUPS       # don't store duplicates
setopt HIST_REDUCE_BLANKS         # trim whitespace
setopt INC_APPEND_HISTORY         # write commands immediately

# ---- Editor ----
export EDITOR="nvim"
export VISUAL="nvim"

# ---- Tool integrations ----
eval "$(starship init zsh)"        # prompt
eval "$(zoxide init zsh)"          # smart cd → use `z foo`
eval "$(direnv hook zsh)"          # auto-load .envrc per directory
eval "$(mise activate zsh)"        # per-project Node/Python versions
eval "$(atuin init zsh)"           # synced shell history with Ctrl+R
source <(fzf --zsh)                # Ctrl+R fuzzy history (atuin wins if both)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ---- Aliases: Editor ----
alias vim="nvim"
alias vi="nvim"

# ---- Aliases: Listing ----
alias ls="eza"
alias ll="eza -lah --git"
alias lt="eza --tree --level=2"

# ---- Aliases: Git ----
alias gs="git status"
alias gd="git diff"
alias gp="git pull"
alias gpush="git push"
alias gco="git checkout"
alias gcm="git commit -m"
alias gl="git log --oneline -20"
alias glg="git log --graph --oneline --all --decorate"
alias gb="git branch"

# ---- Aliases: Navigation ----
alias cdc="cd ~/code"
alias dot="cd ~/dotfiles"

# ---- Aliases: Brewfile / dotfiles ----
alias bdump="brew bundle dump --file=~/Brewfile --describe --force"
alias bcheck="brew bundle check --file=~/Brewfile"
alias reload="exec zsh"

# ---- Aliases: Config quick-edit ----
alias ezsh="nvim ~/.zshrc"
alias estar="nvim ~/.config/starship.toml"
export PATH="$HOME/.local/bin:$PATH"
