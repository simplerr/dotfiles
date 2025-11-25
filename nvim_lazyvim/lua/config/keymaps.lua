-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>ef", function()
  local explorer = Snacks.explorer.reveal()
  if explorer then
    explorer:focus()
  end
end, { desc = "Focus/Reveal Explorer" })
