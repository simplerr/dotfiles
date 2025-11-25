-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    -- Uncomment these lines if you want to disable icons entirely
    -- default_component_configs = {
    --   icon = {
    --     folder_closed = "",
    --     folder_open = "",
    --     folder_empty = "",
    --     default = "",
    --   },
    -- },
    filesystem = {
      follow_current_file = {
        enabled = true,          -- This will find and focus the file in the active buffer every time
        leave_dirs_open = true,  -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['l'] = 'open',
          ['h'] = 'close_node',
        },
      },
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(file_path)
          -- Auto close neo-tree when a file is opened (optional)
          -- Remove this if you want neo-tree to stay open
          -- require("neo-tree.command").execute({ action = "close" })
        end
      },
    },
  },
}
