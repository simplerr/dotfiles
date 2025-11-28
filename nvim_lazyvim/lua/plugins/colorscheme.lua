return {
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
      require("vscode").setup({
        -- Enable transparent background
        transparent = false,
        -- Enable italic comments
        italic_comments = true,
        -- Disable nvim-tree background color
        disable_nvimtree_bg = true,
      })
      vim.cmd.colorscheme("vscode")
      -- Strengthen current line highlight
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2d2d2d" })
    end,
  },
}
