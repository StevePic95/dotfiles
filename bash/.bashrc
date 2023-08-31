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

# Source the functions from .bash_functions
if [ -f "$bash_dotfiles/.bash_functions" ]; then
	. "$bash_dotfiles/.bash_functions"
fi

# Configure the settings that control command history
configure_history_settings

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

set_default_aliases

# source the prompt file
if [ -f "$bash_dotfiles/.bash_prompt" ]; then
	. "$bash_dotfiles/.bash_prompt"
fi

# source the custom alias file
if [ -f "$bash_dotfiles/.bash_custom_aliases" ]; then
	. "$bash_dotfiles/.bash_custom_aliases"
fi

# source the PATH file
if [ -f "$bash_dotfiles/.bash_paths" ]; then
	. "$bash_dotfiles/.bash_paths"
fi

# source the secrets file
if [ -f "$bash_dotfiles/.bash_secrets" ]; then
	. "$bash_dotfiles/.bash_secrets"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# Initialize pyenv and pyenv-virtualenv
init_pyenv

# TODO: does this need to be here?
export PYTHON

# if (1) the tmux command is available, (2) we're in an interactive shell, (3) tmux isn't trying to run within itself
if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
	exec tmux new-session -A -s main
fi
