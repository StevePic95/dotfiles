# Bash Configuration Notes
Using the default bash shell residing in /bin/bash.

## File Structure
The bash configs have been split up into a few different files to keep things neat and tidy. This also makes it easier to parse different parts of the configs, which can be useful for scripts that display the current settings quickly in a more human-readable format.

### .bashrc
This is the main config file; it sources all the other files. It's also sourced itself by the `.profile` file, which is used for login shells. Because of this sourcing, `.bashrc` and `.profile` are the only files that need a symlink in the user's home directory.

### .profile
As previously mentioned, `.profile` is only used by login shells, but it sources `.bashrc` anyway for consistency in shell behavior.

### .bash_custom_aliases
All custom alias definitions go here. Note the format of comments that can make it easier to write custom scripts that parse the file to show the user which custom aliases they have set. The default aliases that came with the original `.bashrc` file are not stored here since they are practically the original commands to me anyway.

### .bash_exports
This is where we put any miscellaneous exports, such as setting environment variables for certain tools to work as intended.

### .bash_functions
Certain setup steps just make more sense when they're grouped together, even though they may otherwise have been split into multiple files. (e.g., pyenv setup involves updating PATH and PYTHONPATH). This can get tricky when the order of these steps matters. To keep things readable and bug-free, these sorts of steps are written as functions and imported by `.bashrc`.

### .bash_paths
All updates to PATH go here (other than those that make more sense as part of a separate function, as explained above).

### .bash_prompt
All code that sets up the terminal prompt goes here.

