# Functions used in the main bash config file (.bashrc) are defined here

# initialize pyenv
init_pyenv() {
	# Initialize pyenv and pyenv-virtualenv
	export PYENV_ROOT="$HOME/.pyenv"
	command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
}

# configure history settings
configure_history_settings() {
	# don't put duplicate lines or lines starting with space in the history.
	# See bash(1) for more options
	HISTCONTROL=ignoreboth

	# append to the history file, don't overwrite it
	shopt -s histappend

	# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
	HISTSIZE=1000
	HISTFILESIZE=2000
}

# set the default aliases that came with the OS
set_default_aliases() {
	# enable color support of ls and also add handy aliases
	if [ -x /usr/bin/dircolors ]; then
		test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
		alias ls='ls --color=auto'
		#alias dir='dir --color=auto'
		#alias vdir='vdir --color=auto'

		alias grep='grep --color=auto'
		alias fgrep='fgrep --color=auto'
		alias egrep='egrep --color=auto'
	fi

	# colored GCC warnings and errors
	export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

	# some more ls aliases
	alias ll='ls -alF'
	alias la='ls -A'
	alias l='ls -CF'

	# Add an "alert" alias for long running commands.  Use like so:
	#   sleep 10; alert
	alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
}

# enable programmable completion features (you don't need to enable
# this if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
enable_programmable_completion() {
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
  fi
}

# make less more friendly for non-text input files, see lesspipe(1)
eval_lesspipe() {
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
}

# Loads and enables bash completions for Node Version Manager (nvm)
init_nvm() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

# Adds compiled Go executables to PATH
add_go_bin_to_path() {
  export PATH=~/go/bin:${PATH}
}
