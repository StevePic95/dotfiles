-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Use bash-language-server for files ending in ".sh" or any of the bash dotfiles used
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

  -- Finally, invoke bash-language-server if the filetype is sh
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "sh",
    callback = function()
      vim.lsp.start({
        name = "bash-language-server",
        cmd = { "bash-language-server", "start" },
      })
    end,
  })
end

-- Call functions defined above
BashLanguageServerSetup()
