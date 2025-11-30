-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gK", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Blame line" })

vim.keymap.set("n", "<leader>gB", function()
  -- Delete all gitsigns-blame buffers first
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:match("gitsigns%-blame://") and vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
      return
    end
  end
  -- Open blame if no blame buffer existed
  require("gitsigns").blame()
end, { desc = "Toggle blame buffer" })

vim.keymap.set("n", "<leader>ef", function()
  local explorer = Snacks.explorer.reveal()
  if explorer then
    explorer:focus()
  end
end, { desc = "Focus/Reveal Explorer" })

vim.keymap.set("n", "<C-S-E>", function()
  local explorer = Snacks.explorer.reveal()
  if explorer then
    explorer:focus()
  end
end, { desc = "Focus/Reveal Explorer" })
