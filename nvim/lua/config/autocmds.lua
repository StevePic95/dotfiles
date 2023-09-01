-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Use a bash language server for files ending in ".sh" or any of the bash dotfiles used
BashLanguageServerSetup = function()
  -- These files will invoke bash-language-server
  local bash_pattern = {
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

  -- Use the pattern above to set the filetype to sh
  vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = bash_pattern,
    command = "set filetype=sh",
  })
end

-- Call functions defined above
BashLanguageServerSetup()
