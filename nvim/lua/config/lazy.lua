local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Using lsp-zero to handle language servers
-- See this link for reference: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md
local lsp = require("lsp-zero").preset({
  name = 'recommended',
  manage_nvim_cmp = {
    set_sources = 'recommended',
    set_basic_mappings = true,
    set_extra_mappings = true,
    use_luasnip = true,
    set_format = true,
    documentation_window = true,
  },
})

lsp.on_attach(function(client, bufnr)
  --see :help lsp-zero-keybindings to learn the available actions
  lsp.default_keymaps({
    buffer = bufnr,
    preserve_mappings = false
  })
end)

-- language servers that connect to lsp-zero client (installed automatically
-- using mason when added to this list)
-- Must be in this list: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local language_servers = {
  "bashls",
  "clangd",
  "cssls",
  "dockerls",
  "docker_compose_language_service",
  "jsonls",
  "jdtls",
  "tsserver", --js and ts both
  "ltex",
  "marksman",
  "pyright",
  "rust_analyzer",
  "sqlls",
  "yamlls",
}
lsp.ensure_installed(language_servers)

lsp.setup()
