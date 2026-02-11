-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Use a bash language server for files ending in ".sh" or any of the shell dotfiles used
ShellLanguageServerSetup = function()
  -- These files will invoke bash-language-server
  local shell_pattern = {
    "*.sh",
    ".bash_custom_aliases",
    ".bash_exports",
    ".bash_functions",
    ".bash_logout",
    ".bash_paths",
    ".bash_prompt",
    ".bash_secrets",
    ".bashrc",
    ".profile",
  }

  -- Zsh dotfiles get zsh filetype
  local zsh_pattern = {
    "*.zsh",
    ".zshrc",
    ".zprofile",
    ".zshenv",
    ".zlogin",
    ".zlogout",
    ".zsh_custom_aliases",
    ".zsh_exports",
    ".zsh_functions",
    ".zsh_paths",
    ".zsh_prompt",
    ".zsh_secrets",
  }

  vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = shell_pattern,
    command = "set filetype=sh",
  })

  vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = zsh_pattern,
    command = "set filetype=zsh",
  })
end

-- Call functions defined above
ShellLanguageServerSetup()
