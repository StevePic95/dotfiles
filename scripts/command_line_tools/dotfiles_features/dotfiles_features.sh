#!/usr/bin/env bash
# Displays all features provided by the dotfiles setup.
# Intended to be called via the 'features' alias.

BOLD='\033[1m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

header() { echo -e "\n${BOLD}${BLUE}$1${NC}"; echo -e "${BLUE}$(printf '%.0s─' $(seq 1 ${#1}))${NC}"; }
item()   { echo -e "  ${GREEN}•${NC} $1"; }
cmd()    { echo -e "  ${GREEN}•${NC} ${CYAN}$1${NC} ${YELLOW}→${NC} $2"; }

echo -e "\n${BOLD}${PURPLE}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${PURPLE}║       Dotfiles Feature Guide         ║${NC}"
echo -e "${BOLD}${PURPLE}╚══════════════════════════════════════╝${NC}"

header "Shell (zsh)"
item "Vi-mode line editing (${CYAN}bindkey -v${NC})"
item "Shared history across sessions (10,000 entries)"
item "Auto-cd: type a directory name to cd into it"
item "Extended globbing and dotfile matching"
item "Case-insensitive tab completion with menu selection"
item "${CYAN}zsh-autosuggestions${NC}: ghost text from history, accept with ${CYAN}→${NC}"
item "${CYAN}zsh-syntax-highlighting${NC}: valid commands in green, errors in red"
item "Auto-attaches to tmux session '${CYAN}main${NC}' on terminal open"

header "Prompt (Starship)"
item "Shows: directory, git branch/status, python venv, node, rust, docker"
item "Command duration shown when > 2 seconds"
item "Vi-mode indicator: ${GREEN}>${NC} normal, ${GREEN}<${NC} insert"
item "Config: ${CYAN}~/dotfiles/starship/starship.toml${NC}"

header "Fuzzy Finder (fzf)"
cmd "Ctrl+R" "fuzzy search command history"
cmd "Ctrl+T" "fuzzy search files in current directory"
cmd "Alt+C"  "fuzzy cd into subdirectory"
cmd "**<TAB>" "trigger fzf completion (e.g. vim **<TAB>)"

header "Tmux"
item "Prefix: ${CYAN}Ctrl+Space${NC} (instead of Ctrl+B)"
cmd "Alt+H / Alt+L" "switch to previous / next window"
cmd "Ctrl+H/J/K/L"  "navigate panes (works seamlessly with nvim)"
item "Mouse enabled for scrolling, selecting, resizing"
item "Vi-style copy mode"
item "New panes open in current working directory"
item "Theme: ${CYAN}catppuccin macchiato${NC}"
item "Status bar: directory, user, host, session"
item "Clipboard: ${CYAN}tmux-yank${NC} integration"

header "Neovim"
item "Based on ${CYAN}LazyVim${NC} starter config"
item "LSP support via mason (auto-installed):"
item "  bash, python, rust, typescript, C/C++, docker, json, yaml, sql, css, markdown, latex, java"
item "Seamless tmux pane navigation with ${CYAN}Ctrl+H/J/K/L${NC}"
item "Filetype detection for all zsh and bash dotfiles"

header "Custom Aliases"
cmd "lsa"   "list all custom aliases with descriptions"
cmd "open"  "open file/directory in Windows (WSL)"
cmd "kts"   "kill tmux server (close everything)"
cmd "ows"   "open a tmuxp workspace preset"
cmd "fws"   "freeze current workspace as a tmuxp preset"
cmd "sgsh"  "start a git daemon server in CWD"
cmd "ecb"   "echo clipboard contents (WSL)"
cmd "cheix" "convert HEIC/HEIF images"

header "Dev Tools"
cmd "pyenv"  "manage Python versions (pyenv install 3.x.x)"
cmd "nvm"    "manage Node.js versions (nvm install --lts)"
cmd "tmuxp"  "manage tmux workspace presets"
cmd "rg"     "fast recursive text search (ripgrep)"
cmd "fdfind" "fast file finder (fd)"

header "Dotfiles Management"
cmd "features"      "show this guide"
cmd "bootstrap.sh"  "idempotent setup script (safe to re-run)"
item "Secrets: ${CYAN}~/dotfiles/zsh/.zsh_secrets${NC} (gitignored)"
item "Claude config tracked in ${CYAN}~/dotfiles/claude/${NC}"

echo ""
