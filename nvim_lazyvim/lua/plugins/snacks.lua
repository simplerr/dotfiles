return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      win = {
        list = {
          keys = {
            ["<C-p>"] = false, -- unbind so global Ctrl-P (find files) works
          },
        },
      },
    },
  },
}
