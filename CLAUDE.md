# Dotfiles Project Instructions

## Repository Structure
- `zsh/` - Zsh configuration files (modular: prompt, aliases, paths, exports, functions, secrets)
- `nvim/` - Neovim configuration (LazyVim-based, LSP via mason)
- `tmux/` - Tmux config + tmuxp workspace presets
- `starship/` - Starship prompt configuration
- `claude/` - Claude Code settings (symlinked into ~/.claude/)
- `scripts/` - Helper scripts (alias viewer, features display)
- `bootstrap.sh` - Idempotent setup script that installs everything from zero
- `bash/` - Legacy bash configs (kept for reference, no longer active)

## Feature Display Script
When adding or removing features from the dotfiles, **always update the features display script** at:
`scripts/command_line_tools/dotfiles_features/dotfiles_features.sh`

This script is invoked via the `features` alias and serves as the user's reference for everything their dotfiles provide. Keep it in sync with reality.

## Custom Aliases Format
Custom aliases in `zsh/.zsh_custom_aliases` follow a structured comment format for parsing:
```
###
# TITLE: Short Name
# DESCRIPTION: What it does
# EXAMPLES: Description of example::example_command||Another example::another_command
alias name='command'
###
```
Always follow this format when adding new aliases. The `lsa` alias uses a Python script that parses this format.

## Key Conventions
- All PATH additions go in `zsh/.zsh_paths` with conditional `[[ -d ... ]]` guards
- All exports (non-PATH) go in `zsh/.zsh_exports`
- Setup functions go in `zsh/.zsh_functions` and are called from `.zshrc`
- Sensitive data goes in `zsh/.zsh_secrets` (gitignored)
- Bootstrap script must remain idempotent with verbose `[OK]`/`[SKIP]`/`[INFO]`/`[ERROR]` output
- Symlinks are managed by `bootstrap.sh` -- new config files need an `ensure_symlink` entry there
