# dotfiles
The dotfile repo I use to backup and port my dev environment.

## Quick Start
```bash
git clone https://github.com/StevePic95/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```
The bootstrap script is idempotent -- run it again anytime to pick up changes or finish a partial install.

Run `features` after setup to see a complete guide of everything available.

## Features

### zsh
* Modular config split into separate files (prompt, aliases, paths, exports, functions, secrets)
* Vi-mode line editing
* Enhanced completion with case-insensitive matching and menu selection
* History shared across sessions (10,000 entries)
* Auto-cd, extended globbing, dotfile matching
* **zsh-autosuggestions**: ghost text from history, accept with right arrow
* **zsh-syntax-highlighting**: valid commands green, errors red as you type
* Auto-attaches to tmux session "main" on terminal open

### Starship Prompt
* Shows git branch/status, python venv, node version, rust, docker context
* Command duration for long-running commands
* Vi-mode indicator in prompt character

### fzf (Fuzzy Finder)
* `Ctrl+R` - fuzzy search command history
* `Ctrl+T` - fuzzy search files
* `Alt+C` - fuzzy cd into subdirectory
* `**<TAB>` - trigger fzf completion

### tmux
* Prefix: `Ctrl+Space`, mouse enabled, vi copy mode
* Seamless vim/tmux pane navigation with `Ctrl+H/J/K/L`
* Theme: catppuccin macchiato with informative status bar
* tmux-yank for clipboard, new panes open in CWD
* tmuxp workspace presets with `ows` / `fws` aliases
* Plugins auto-installed by bootstrap

### Neovim
* Based on LazyVim starter config
* LSP support for 14 languages via mason (auto-installed)
* Seamless tmux pane navigation

## What the Bootstrap Script Installs
* **zsh** + autosuggestions + syntax-highlighting plugins
* **Starship** prompt
* **fzf** fuzzy finder
* **tmux** + tpm (auto-installs plugins) + tmuxp (workspace presets)
* **Neovim** (via PPA)
* **Node.js** (via nvm, for mason LSP servers)
* **pyenv** + build dependencies
* **ripgrep**, **fd-find**, **wslu**
* **Claude Code** config symlinks

## After Setup
1. Open a new terminal to start zsh
2. Open nvim -- plugins will auto-install on first launch
3. Install a Python version with `pyenv install 3.x.x`
4. Create `~/dotfiles/zsh/.zsh_secrets` for sensitive environment variables (gitignored)
5. Run `features` to see everything available
