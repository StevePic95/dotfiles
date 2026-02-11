# Zsh Configuration Notes
Using zsh as the default shell.

## File Structure
The zsh configs have been split up into a few different files to keep things neat and tidy. This mirrors the organization previously used for bash. This also makes it easier to parse different parts of the configs, which can be useful for scripts that display the current settings quickly in a more human-readable format.

### .zshrc
This is the main config file; it sources all the other files. Unlike bash, zsh automatically reads `.zshrc` for all interactive shells and `.zprofile` for login shells, so there's no need to manually source `.zshrc` from `.zprofile`.

### .zprofile
Used by login shells only. Contains login-specific setup like adding `~/.local/bin` to PATH. zsh sources this before `.zshrc` for login shells.

### .zsh_custom_aliases
All custom alias definitions go here. Note the format of comments that can make it easier to write custom scripts that parse the file to show the user which custom aliases they have set. The default aliases that came with the original config are not stored here since they are practically the original commands to me anyway.

### .zsh_exports
This is where we put any miscellaneous exports, such as setting environment variables for certain tools to work as intended.

### .zsh_functions
Certain setup steps just make more sense when they're grouped together, even though they may otherwise have been split into multiple files. (e.g., pyenv setup involves updating PATH and PYTHONPATH). This can get tricky when the order of these steps matters. To keep things readable and bug-free, these sorts of steps are written as functions and imported by `.zshrc`.

### .zsh_paths
All updates to PATH go here (other than those that make more sense as part of a separate function, as explained above). Paths are conditionally added only if their directories exist.

### .zsh_prompt
All code that sets up the terminal prompt goes here. Uses zsh prompt escapes (%n, %m, %~, %F{color}, etc.) instead of the bash equivalents.

### .zsh_secrets
Gitignored file for sensitive environment variables (API keys, tokens, etc.).

## Key Differences from Bash
- `setopt` replaces `shopt` for shell options
- `bindkey -v` replaces `set -o vi` for vi mode
- `autoload -Uz compinit && compinit` replaces bash-completion sourcing
- Prompt uses `%n` (user), `%m` (host), `%~` (directory) instead of `\u`, `\h`, `\w`
- History uses `SAVEHIST` instead of `HISTFILESIZE`, and has `SHARE_HISTORY` for cross-session sharing
