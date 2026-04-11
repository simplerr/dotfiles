-- Offline mode configuration for Lazy.nvim
-- This file helps Lazy.nvim work better when internet is not available

-- Check if we're in offline mode
local offline_mode_file = vim.fn.stdpath("config") .. "/.offline_mode"
local is_offline = vim.fn.filereadable(offline_mode_file) == 1

if is_offline then
  -- Configure Lazy.nvim for offline operation
  local lazy_config = require("lazy.core.config")
  
  -- Disable automatic installation of missing plugins
  if lazy_config.options.install then
    lazy_config.options.install.missing = false
  end
  
  -- Disable update checker
  if lazy_config.options.checker then
    lazy_config.options.checker.enabled = false
  end
  
  -- Set shorter git timeouts
  if lazy_config.options.git then
    lazy_config.options.git.timeout = 5
  end
  
  -- Show a message that we're in offline mode
  vim.notify("Neovim running in offline mode", vim.log.levels.INFO)
end
