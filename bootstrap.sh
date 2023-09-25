# After cloning the dotfile repo, use this script to backup your original
# dotfiles (in a folder called old_dotfiles_bkp) and replace them with
# symlinks to the new ones in the repo.

set -o errexit

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if ! [[ -e "$HOME/old_dotfiles_bkp" ]]; then
  mkdir -p "$HOME/old_dotfiles_bkp/.config/"
fi

if [[ -e "$HOME/.bashrc" ]]; then
  mv "$HOME/.bashrc" "$HOME/old_dotfiles_bkp/"
fi
cd ~ && ln -s "$(echo "$ROOT/bash/.bashrc")" .

if [[ -e "$HOME/.config/nvim" ]]; then
  mv "$HOME/.config/nvim" "$HOME/old_dotfiles_bkp/.config/"
fi
cd ~/.config/ && ln -s "$(echo "$ROOT/nvim")" .

if [[ -e "$HOME/.config/tmux" ]]; then
  mv "$HOME/.config/tmux" "$HOME/old_dotfiles_bkp/.config/"
  mkdir "$HOME/.config/tmux"
fi
cd ~/.config/tmux/ && ln -s "$(echo "$ROOT/tmux/tmux.conf")" .
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

source ~/.bashrc
source ~/.config/tmux/tmux.conf
