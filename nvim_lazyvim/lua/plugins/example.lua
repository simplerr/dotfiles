return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 100,
      },
    },
  },

  -- add flash.nvim for enhanced search
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("flash").setup({})
      -- Unbind s from flash
      vim.keymap.del({ "n", "x", "o" }, "s")
      -- Bind flash char mode to ,
      vim.keymap.set({ "n", "x", "o" }, ",", function() require("flash").jump() end, { desc = "Flash" })
    end,
  },
}
