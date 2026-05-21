#!/usr/bin/env bash
set -euo pipefail

# Personal Mac bootstrap script
# Run on a fresh macOS install:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/msagar1/dotfiles/main/install.sh)"

DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_REPO="https://github.com/msagar1/dotfiles"

echo "🚀 Starting bootstrap..."

# ---- 1. Install Homebrew if missing ----
if ! command -v brew &> /dev/null; then
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  if ! grep -q "brew shellenv" ~/.zprofile 2>/dev/null; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  fi
else
  echo "✅ Homebrew already installed"
fi

# ---- 2. Clone dotfiles if missing ----
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "📥 Cloning dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  echo "✅ Dotfiles already at $DOTFILES_DIR"
  echo "   Pulling latest..."
  git -C "$DOTFILES_DIR" pull
fi

# ---- 3. Install from Brewfile ----
echo "📦 Installing from Brewfile (this takes a while)..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ---- 4. Symlink configs ----
echo "🔗 Symlinking configs..."
ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/gitignore_global" "$HOME/.gitignore_global"

mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

# gitconfig — copy (not symlink) so machine-specific tweaks don't pollute the repo
if [ ! -f "$HOME/.gitconfig" ]; then
  cp "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
  echo "✅ Copied gitconfig"
else
  echo "✅ gitconfig already exists (skipping copy)"
fi

# ---- 5. Set up LazyVim ----
if [ ! -d "$HOME/.config/nvim" ]; then
  echo "📝 Setting up LazyVim..."
  git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
  rm -rf "$HOME/.config/nvim/.git"
  if [ -f "$DOTFILES_DIR/nvim-lazyvim.json" ]; then
    cp "$DOTFILES_DIR/nvim-lazyvim.json" "$HOME/.config/nvim/lazyvim.json"
  fi
else
  echo "✅ Neovim config already exists"
fi

# ---- 6. SSH config for 1Password agent ----
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/config" ]; then
  cat > "$HOME/.ssh/config" << 'SSH_EOF'
Host *
  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
SSH_EOF
  chmod 600 "$HOME/.ssh/config"
  echo "✅ Created ~/.ssh/config"
else
  echo "✅ ~/.ssh/config already exists"
fi

# ---- 7. Folder structure ----
echo "📁 Creating folder structure..."
mkdir -p "$HOME/code"
mkdir -p "$HOME/scripts"

# Symlink dotfiles scripts to ~/scripts so they're on PATH
if [ -d "$DOTFILES_DIR/scripts" ]; then
  for script in "$DOTFILES_DIR/scripts"/*; do
    [ -f "$script" ] || continue
    name=$(basename "$script")
    ln -sf "$script" "$HOME/scripts/$name"
    chmod +x "$script"
  done
  echo "✅ Linked scripts from dotfiles"
fi

# ---- 8. Done ----
cat << 'EOF'

✨ Bootstrap complete!

Manual steps still required:
  1. Sign into 1Password (Applications → 1Password)
     → Settings → Developer → enable "Use SSH agent" + "Integrate with 1Password CLI"
  2. gh auth login
     → choose GitHub.com → SSH → web browser
     → gh config set git_protocol ssh
  3. Open Rectangle, grant Accessibility permission
  4. Open Raycast, set Cmd+Space hotkey
     → System Settings → Keyboard → Keyboard Shortcuts → Spotlight → uncheck Cmd+Space
  5. Test SSH: ssh -T git@github.com
  6. Reload shell: exec zsh

Optional next steps:
  - Clone your repos into ~/code (gh repo clone msagar1/<repo>)
  - Sign into Slack, Zoom, browsers, etc.

EOF
