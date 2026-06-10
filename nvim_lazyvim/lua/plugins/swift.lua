return {
  -- Swift LSP via sourcekit-lsp.
  -- Ships with the Xcode/Swift toolchain (on PATH at /usr/bin/sourcekit-lsp),
  -- so it is NOT a Mason package -- LazyVim sets it up directly.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          -- Recommended for sourcekit-lsp + Neovim so file changes (e.g. from a
          -- build) are picked up reliably.
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
        },
      },
    },
  },

  -- Swift syntax / highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "swift" } },
  },
}
