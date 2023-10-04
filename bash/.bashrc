# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Store the path to the bash dotfile subdirectory for brevity
bash_dotfiles="$HOME/dotfiles/bash"

# The source files used by this file
source_files=(
  ".bash_prompt"
  ".bash_custom_aliases"
  ".bash_paths"
  ".bash_secrets"
  ".bash_functions"
)

# now actually source them
for src in "${source_files[@]}"; do
  src="$bash_dotfiles/$src"
  if [ -f "$src" ]; then
   # shellcheck disable=SC1090
    . "$src"
  fi
done

# Functions executed on all hosts
configure_history_settings      # Configure the settings that control command history
set_default_aliases             # Sets the aliases that came with the OS - I'm used to them now
enable_programmable_completion  # Enable completion features, default setting in Pop OS
eval_lesspipe                   # Make the less command more friendly for non-text input files
set_host_id                     # Used to figure out which host the script is running on

# Functions run only on my laptop
if [[ $DOTFILE_HOST_ID == "e54fc0399347b5ccf800e22152daf65fb3d86ffbc4da0d009f6cf13e3250599c" ]]; then
  init_pyenv                    # Initialize pyenv and pyenv-virtualenv
  init_nvm

# Functions run only on my cloud instance
elif [[ $DOTFILE_HOST_ID == "a960ea7d4c3951d07549f2c8d9922892e64cf1ee3b12b3af8914d07c42d48734" ]]; then
  add_go_bin_to_path            # Executables built with Go (lazygit is one)
fi


shopt -s checkwinsize           # check window size after commands and updates LINES and COLUMNS
shopt -s globstar               # the pattern "**" used in fp expansion will recursively match dirs
set -o vi                       # set a vi-style line editing interface

# user hits enter to attach directly to tmux
if
  # the tmux command is available
  command -v tmux &>/dev/null   &&
  # we're in an interactive shell
  [ -n "$PS1" ]                 &&
  # tmux isn't trying to run within itself
  [[ ! "$TERM" =~ screen ]]     &&
  [[ ! "$TERM" =~ tmux ]]       &&
  [ -z "$TMUX" ]; then

  # now that we know it's ok, ask the user
  printf "Start in main tmux session? [y]/n "
  read -r ans
  if [[ -z "$ans" ]] || [[ "${ans,,}" != "n" ]]; then
    exec tmux new-session -A -s main
  else
    clear
  fi
fi

