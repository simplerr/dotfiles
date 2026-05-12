-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
-- Unbind s so it restores default behaviour (delete char + insert)
vim.keymap.del({ "n", "x", "o" }, "s")

vim.keymap.set("n", "<leader>gK", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Blame line" })
-- Bind , to flash.nvim jump (what s used to do)
vim.keymap.set({ "n", "x", "o" }, ",", function()
  require("flash").jump()
end, { desc = "Flash" })

-- Bind Ctrl-P to fuzzy file finder
vim.keymap.set("n", "<C-p>", function()
  Snacks.picker.files()
end, { desc = "Find Files" })

local function load_gitsigns()
  require("lazy").load({ plugins = { "gitsigns.nvim" } })
  return require("gitsigns")
end

local function pick_gitsigns_base()
  local gs = load_gitsigns()
  local ok, Snacks = pcall(require, "snacks")
  if ok and Snacks.picker and Snacks.picker.git_log then
    Snacks.picker.git_log({
      title = "Gitsigns Base Commit",
      confirm = function(picker, item)
        picker:close()
        if not item or not item.commit then
          return
        end
        vim.schedule(function()
          gs.change_base(item.commit)
          vim.notify("Gitsigns base: " .. item.commit)
        end)
      end,
    })
    return
  end

  vim.ui.input({ prompt = "Gitsigns base commit: " }, function(commit)
    if commit and commit ~= "" then
      gs.change_base(commit)
      vim.notify("Gitsigns base: " .. commit)
    end
  end)
end

pcall(vim.keymap.del, "n", "<leader>gB")
pcall(vim.keymap.del, "x", "<leader>gB")

vim.keymap.set("n", "<leader>gB", pick_gitsigns_base, { desc = "GitSigns Pick Base" })
vim.keymap.set("n", "<leader>gR", function()
  load_gitsigns().change_base()
  vim.notify("Gitsigns base reset")
end, { desc = "GitSigns Reset Base" })

local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({
    { "<leader>gB", desc = "GitSigns Pick Base" },
    { "<leader>gR", desc = "GitSigns Reset Base" },
  })
end
