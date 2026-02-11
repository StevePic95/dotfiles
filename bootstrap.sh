#!/usr/bin/env bash
# bootstrap.sh - Set up a complete development environment from zero.
#
# This script is idempotent: running it multiple times is safe and will only
# apply changes that haven't been made yet. It provides verbose, color-coded
# output so you can see exactly what happened.
#
# Usage: ./bootstrap.sh

set -euo pipefail

# ---------------------------------------------------------------------------
# Output helpers
# ---------------------------------------------------------------------------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC}    $1"; }
ok()      { echo -e "${GREEN}[OK]${NC}      $1"; }
skip()    { echo -e "${YELLOW}[SKIP]${NC}    $1"; }
err()     { echo -e "${RED}[ERROR]${NC}   $1"; }
section() { echo -e "\n${BOLD}=== $1 ===${NC}"; }

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/old_dotfiles_bkp"
NVM_DIR_PATH="$HOME/.nvm"
ZSH_PLUGINS_DIR="$HOME/.zsh/plugins"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Check if a command exists
has() { command -v "$1" &>/dev/null; }

# Install apt packages that aren't already installed
apt_install() {
  local to_install=()
  for pkg in "$@"; do
    if dpkg -s "$pkg" &>/dev/null; then
      skip "$pkg is already installed"
    else
      to_install+=("$pkg")
    fi
  done
  if [[ ${#to_install[@]} -gt 0 ]]; then
    info "Installing: ${to_install[*]}"
    sudo apt-get install -y "${to_install[@]}"
    for pkg in "${to_install[@]}"; do
      ok "Installed $pkg"
    done
  fi
}

# Clone a git repo if the target directory doesn't exist
ensure_clone() {
  local repo="$1"
  local dest="$2"
  local name
  name="$(basename "$dest")"
  if [[ -d "$dest" ]]; then
    skip "$name is already cloned at $dest"
  else
    info "Cloning $name..."
    git clone --depth=1 "$repo" "$dest"
    ok "Cloned $name"
  fi
}

# Back up a file or directory, then remove the original
backup() {
  local target="$1"
  local backup_dest="$2"
  if [[ -e "$target" ]] || [[ -L "$target" ]]; then
    mkdir -p "$(dirname "$backup_dest")"
    mv "$target" "$backup_dest"
    info "Backed up $target -> $backup_dest"
  fi
}

# Create a symlink if it doesn't already point to the right place
ensure_symlink() {
  local source="$1"
  local dest="$2"
  if [[ -L "$dest" ]] && [[ "$(readlink -f "$dest")" == "$(readlink -f "$source")" ]]; then
    skip "Symlink already correct: $dest -> $source"
    return
  fi
  if [[ -e "$dest" ]] || [[ -L "$dest" ]]; then
    backup "$dest" "$BACKUP_DIR/${dest#$HOME/}"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$source" "$dest"
  ok "Symlinked $dest -> $source"
}

# ---------------------------------------------------------------------------
# 1. System packages
# ---------------------------------------------------------------------------
install_system_packages() {
  section "System Packages"
  info "Updating apt package index..."
  sudo apt-get update -qq

  apt_install \
    zsh \
    tmux \
    git \
    curl \
    wget \
    python3 \
    python3-pip \
    python3-venv \
    pipx \
    build-essential \
    software-properties-common \
    unzip \
    ripgrep \
    fd-find \
    fzf \
    wslu \
    xdg-utils
}

# ---------------------------------------------------------------------------
# 2. Neovim
# ---------------------------------------------------------------------------
install_neovim() {
  section "Neovim"

  if has nvim; then
    local current_version
    current_version="$(nvim --version | head -1 | grep -oP '\d+\.\d+')"
    skip "Neovim is already installed (v${current_version})"
    return
  fi

  info "Adding Neovim PPA..."
  if ! grep -q "neovim-ppa" /etc/apt/sources.list.d/*.list 2>/dev/null; then
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt-get update -qq
  fi
  sudo apt-get install -y neovim
  ok "Installed Neovim $(nvim --version | head -1)"
}

# ---------------------------------------------------------------------------
# 3. Node.js (via nvm, needed for LSP servers installed by mason)
# ---------------------------------------------------------------------------
install_node() {
  section "Node.js (via nvm)"

  if [[ -s "$NVM_DIR_PATH/nvm.sh" ]]; then
    skip "nvm is already installed at $NVM_DIR_PATH"
    # shellcheck source=/dev/null
    source "$NVM_DIR_PATH/nvm.sh"
  else
    info "Installing nvm..."
    PROFILE=/dev/null bash -c \
      'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash'
    export NVM_DIR="$NVM_DIR_PATH"
    # shellcheck source=/dev/null
    source "$NVM_DIR/nvm.sh"
    ok "Installed nvm"
  fi

  if has node; then
    skip "Node.js is already installed ($(node --version))"
  else
    info "Installing latest Node.js LTS..."
    nvm install --lts
    ok "Installed Node.js $(node --version)"
  fi
}

# ---------------------------------------------------------------------------
# 4. pyenv
# ---------------------------------------------------------------------------
install_pyenv() {
  section "pyenv"

  # pyenv build dependencies
  apt_install \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev

  if [[ -d "$HOME/.pyenv" ]]; then
    skip "pyenv is already installed at ~/.pyenv"
  else
    info "Installing pyenv..."
    curl -fsSL https://pyenv.run | bash
    ok "Installed pyenv"
  fi
}

# ---------------------------------------------------------------------------
# 5. Starship prompt
# ---------------------------------------------------------------------------
install_starship() {
  section "Starship Prompt"

  if has starship; then
    skip "Starship is already installed ($(starship --version | head -1))"
  else
    info "Installing Starship..."
    curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
    ok "Installed Starship"
  fi
}

# ---------------------------------------------------------------------------
# 6. tmux plugin manager (tpm) + plugins
# ---------------------------------------------------------------------------
install_tpm() {
  section "Tmux Plugin Manager (tpm)"

  ensure_clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"

  # Auto-install tmux plugins (requires tmux config to be symlinked first)
  if [[ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]]; then
    info "Installing tmux plugins via tpm..."
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
    ok "Tmux plugins installed"
  fi
}

# ---------------------------------------------------------------------------
# 7. tmuxp (tmux workspace manager)
# ---------------------------------------------------------------------------
install_tmuxp() {
  section "tmuxp"

  if has tmuxp; then
    skip "tmuxp is already installed ($(tmuxp --version))"
  else
    info "Installing tmuxp via pipx..."
    pipx install tmuxp
    ok "Installed tmuxp"
  fi
}

# ---------------------------------------------------------------------------
# 8. Zsh plugins
# ---------------------------------------------------------------------------
install_zsh_plugins() {
  section "Zsh Plugins"

  mkdir -p "$ZSH_PLUGINS_DIR"

  ensure_clone "https://github.com/zsh-users/zsh-autosuggestions" \
    "$ZSH_PLUGINS_DIR/zsh-autosuggestions"

  ensure_clone "https://github.com/zsh-users/zsh-syntax-highlighting" \
    "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
}

# ---------------------------------------------------------------------------
# 9. Symlinks
# ---------------------------------------------------------------------------
setup_symlinks() {
  section "Symlinks"

  mkdir -p "$BACKUP_DIR"

  # zsh
  ensure_symlink "$DOTFILES_DIR/zsh/.zshrc"    "$HOME/.zshrc"
  ensure_symlink "$DOTFILES_DIR/zsh/.zprofile"  "$HOME/.zprofile"

  # neovim
  ensure_symlink "$DOTFILES_DIR/nvim"           "$HOME/.config/nvim"

  # tmux
  mkdir -p "$HOME/.config/tmux"
  ensure_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

  # tmuxp workspace presets
  mkdir -p "$HOME/.config/tmuxp"
  for preset in "$DOTFILES_DIR"/tmux/tmuxp/*.yaml; do
    [[ -f "$preset" ]] || continue
    local name
    name="$(basename "$preset")"
    ensure_symlink "$preset" "$HOME/.config/tmuxp/$name"
  done

  # starship
  ensure_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

  # claude code
  mkdir -p "$HOME/.claude"
  for cfg in "$DOTFILES_DIR"/claude/*; do
    [[ -f "$cfg" ]] || continue
    local name
    name="$(basename "$cfg")"
    ensure_symlink "$cfg" "$HOME/.claude/$name"
  done
}

# ---------------------------------------------------------------------------
# 10. Set default shell to zsh
# ---------------------------------------------------------------------------
set_default_shell() {
  section "Default Shell"

  local zsh_path
  zsh_path="$(which zsh)"

  if [[ "$SHELL" == "$zsh_path" ]]; then
    skip "Default shell is already zsh"
    return
  fi

  # Ensure zsh is in /etc/shells
  if ! grep -qx "$zsh_path" /etc/shells; then
    info "Adding $zsh_path to /etc/shells..."
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi

  info "Changing default shell to zsh (you may be prompted for your password)..."
  chsh -s "$zsh_path"
  ok "Default shell set to zsh"
}

# ---------------------------------------------------------------------------
# 11. Post-install reminders
# ---------------------------------------------------------------------------
print_next_steps() {
  section "Setup Complete"
  echo ""
  info "Next steps:"
  echo "  1. Open a new terminal (or run 'zsh') to start using your new shell"
  echo "  2. Neovim plugins will auto-install on first launch"
  echo "  3. To install a Python version: ${BOLD}pyenv install 3.x.x${NC}"
  echo "  4. Create ${BOLD}~/dotfiles/zsh/.zsh_secrets${NC} for API keys and tokens (gitignored)"
  echo "  5. Run ${BOLD}lsa${NC} to see your custom aliases"
  echo ""
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
  echo -e "${BOLD}Dotfiles Bootstrap${NC}"
  echo "Dotfiles directory: $DOTFILES_DIR"
  echo ""

  install_system_packages
  install_neovim
  install_node
  install_pyenv
  install_starship
  install_zsh_plugins
  setup_symlinks
  install_tpm
  install_tmuxp
  set_default_shell
  print_next_steps
}

main "$@"
