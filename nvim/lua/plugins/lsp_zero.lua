-- LSP configuration using LazyVim's native mason integration
-- Language servers are auto-installed by mason when added to the servers table
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server",
        "clangd",
        "css-lsp",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "json-lsp",
        "jdtls",
        "typescript-language-server",
        "ltex-ls",
        "marksman",
        "pyright",
        "rust-analyzer",
        "sqlls",
        "yaml-language-server",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
        clangd = {},
        cssls = {},
        dockerls = {},
        docker_compose_language_service = {},
        jsonls = {},
        jdtls = {},
        ts_ls = {},
        ltex = {},
        marksman = {},
        pyright = {},
        rust_analyzer = {},
        sqlls = {},
        yamlls = {},
      },
    },
  },
}
