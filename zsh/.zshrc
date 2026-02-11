# ~/.zshrc: executed by zsh for interactive shells.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Store the path to the zsh dotfile subdirectory for brevity
zsh_dotfiles="$HOME/dotfiles/zsh"

# The source files used by this file
source_files=(
  ".zsh_prompt"
  ".zsh_custom_aliases"
  ".zsh_paths"
  ".zsh_secrets"
  ".zsh_exports"
  ".zsh_functions"
)

# now actually source them
for src in "${source_files[@]}"; do
  src="$zsh_dotfiles/$src"
  if [[ -f "$src" ]]; then
    source "$src"
  fi
done

configure_history_settings      # Configure the settings that control command history
set_default_aliases             # Sets the aliases that came with the OS - I'm used to them now
init_nvm                        # Initialize nvm (node version manager)
init_pyenv                      # Initialize pyenv and pyenv-virtualenv
setup_completion                # Enable the zsh completion system
eval_lesspipe                   # Make the less command more friendly for non-text input files

setopt AUTO_CD                  # cd into a directory just by typing its name
setopt GLOB_DOTS                # include dotfiles in globbing
setopt EXTENDED_GLOB            # extended globbing with patterns like ^, ~, #
bindkey -v                      # set a vi-style line editing interface

# fzf - fuzzy finder keybindings and completion (Ctrl+R for history, Ctrl+T for files)
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi
if [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
  source /usr/share/doc/fzf/examples/completion.zsh
fi
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# zsh plugins (cloned by bootstrap.sh)
zsh_plugins="$HOME/.zsh/plugins"
[[ -f "$zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# if (1) the tmux command is available, (2) we're in an interactive shell, (3) tmux isn't trying to run within itself
if command -v tmux &>/dev/null && [[ -n "$PS1" ]] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [[ -z "$TMUX" ]]; then
	exec tmux new-session -A -s main
fi
