-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.list = true
vim.opt.listchars = {
  lead = "·",
  trail = "·",
}
-- Disable format on save globally
vim.g.autoformat = false

vim.g.snacks_animate = false
-- Disable inlay hints by default
vim.g.lazyvim_no_inlay_hints = true
