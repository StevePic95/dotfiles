# dotfiles
The dotfile repo I use to backup and port my dev environment

## Features
Some of the nice features that come with this repo.

### tmux
* The terminal is automatically attached to a tmux session called "main". If it doesn't already exist, it is created first. This behavior is set in the `.bashrc` file. To detach from the session (e.g., close the terminal but keep it saved in the background for later), use the `<leader> d` command.
  * In effect, this behavior mimics the way modern IDEs are "just the way you left them" when you exit and come back.
  * As of this commit, the session isn't persisted between reboots, but I may add this feature using tmux-ressurect.
* The leader for tmux has been changed to `CTRL + SPACE` for ease of use.
* Theme has been set to catppuccin/macchiato with a nice informative status bar 
* Window and pane navigation has been set to integrate flawlessly with neovim when it's active in one of your panes
* Mouse is enabled
* tmuxp is set up to allow users to freeze and load workspace presets, and the aliases `ows` (Open WorkSpace) and `fws` (Freeze WorkSpace) have been set for ease of use

### Neovim
* The Neovim configuration is based on the Lazyvim starter config
* A language server for bash scripting has been configured

### bash
* Bash configs have been split logically into separate files for organization
* Helpful aliases have been set in a file with comments formatted for easy parsing by scripts that display custom aliases (in case I forget)

### gnome-terminal
* Remove the default padding from the bottom of the terminal window so the tmux status bar is actually at the bottom


## Installation Steps
Eventually, there should be a bootstrap script to install the necessary dependencies, but until then, I'm just keeping track of them here.k"

### Language Server for Bash
(bash-language-server instructions)[https://github.com/bash-lsp/bash-language-server]
1. For Neovim, we must install the server binary
2. Then, we need to add the autocmd that invokes `bash-language-server` when a ".sh" file is opened


