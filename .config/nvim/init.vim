let g:airline_powerline_fonts = 1
let g:ccls_levels = 10

" ------------------------------------------
" Plugins
" ------------------------------------------
"call plug#begin(stdpath('data') . '/plugged')
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tomasiser/vim-code-dark'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tikhomirov/vim-glsl'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'neovim/nvim-lspconfig'
Plug 'm-pilia/vim-ccls'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'phaazon/hop.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'kevinhwang91/nvim-bqf'
Plug 'akinsho/toggleterm.nvim'
call plug#end()

" ------------------------------------------
" Settings
" ------------------------------------------
colorscheme codedark
let g:airline_theme = 'codedark'
set termguicolors " for correct nvim-tree colors
set path+=**
set hidden
set number
set mouse=a
set incsearch
set hlsearch
set wildmenu
set splitright
set splitbelow
set visualbell " disable audio bell
set t_vb= " disable audio bell
set laststatus=2 " always display status line
set clipboard+=unnamedplus
set updatetime=100
set tabstop=3
set shiftwidth=3
set expandtab
set timeoutlen=1000 ttimeoutlen=0 " remove ESC timeout
set cursorline " highlight current line
set jumpoptions+=stack
set signcolumn=yes

" Display tabs and spaces
set list
set listchars=tab:›\
set listchars+=lead:·
set listchars+=trail:·
set listchars+=multispace:·
highlight SpecialKey ctermfg=240 guifg=grey70


" ------------------------------------------
" nvim-tree
" ------------------------------------------
let g:nvim_tree_git_hl = 1

lua << EOF
require('nvim-tree').setup {
    open_on_tab = true,
    update_focused_file = {
        enable      = true,
        update_cwd  = false,
        ignore_list = {}
    },
    view = {
        width = 30,
        height = 30,
        hide_root_folder = false,
        side = 'left',
        auto_resize = true
    }
}
EOF

" ------------------------------------------
" LSP
" ------------------------------------------
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  -- buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end

local ccls_cmd = "ccls"

if vim.loop.os_uname().sysname == "Windows_NT" then
    ccls_cmd = "C:/Program Files (x86)/ccls/bin/ccls.exe"
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      signs = false,
      update_in_insert = false,
    }
)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'ccls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    cmd = { ccls_cmd },
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

" ------------------------------------------
" Treesitter
" ------------------------------------------
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      --["foo.bar"] = "Identifier",
    },
    additional_vim_regex_highlighting = false,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}
EOF

" ------------------------------------------
" Auto-completion
" ------------------------------------------
lua <<EOF
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
EOF

lua <<EOF
vim.cmd([[:highlight DiffDelete guifg=grey70]])
vim.cmd([[:highlight GitSignsAdd guifg=#6A9955]])
vim.cmd([[:highlight GitSignsChange guifg=#569CD6]])
vim.cmd([[:highlight GitSignsDelete guifg=#F44747]])

require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '▎', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '▎', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '▎', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '▎', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '▎', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  keymaps = {
    -- Default keymap options
    noremap = true,

    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'"},

    ['n <leader>gs'] = '<cmd>Gitsigns stage_hunk<CR>',
    ['v <leader>gs'] = ':Gitsigns stage_hunk<CR>',
    ['n <leader>gu'] = '<cmd>Gitsigns undo_stage_hunk<CR>',
    ['n <leader>gr'] = '<cmd>Gitsigns reset_hunk<CR>',
    ['v <leader>gr'] = ':Gitsigns reset_hunk<CR>',
    ['n <leader>gR'] = '<cmd>Gitsigns reset_buffer<CR>',
    ['n <leader>gp'] = '<cmd>Gitsigns preview_hunk<CR>',
    ['n <leader>gb'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
    ['n <leader>gS'] = '<cmd>Gitsigns stage_buffer<CR>',
    ['n <leader>gU'] = '<cmd>Gitsigns reset_buffer_index<CR>',

    -- Text objects
    ['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
    ['x ih'] = ':<C-U>Gitsigns select_hunk<CR>'
  },
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 100,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
  diff_opts = { internal = false }
}
EOF

" ------------------------------------------
" Terminal
" ------------------------------------------
lua <<EOF

terminal_shell = "bash"
if vim.loop.os_uname().sysname == "Windows_NT" then
    terminal_shell = [["C:/Program Files/Git/bin/bash.exe"]]
end

require("toggleterm").setup{
   shell = terminal_shell,
   insert_mappings = true,
   open_mapping = [[<c-g>]],
}

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-w>h', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-w>j', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-w>k', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-w>l', [[<C-\><C-n><C-W>l]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-w>p', [[<C-\><C-n><C-W>p]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<S-tab>', [[<C-\><C-n>:tabprevious<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

EOF

" ------------------------------------------
" Additional plugins
" ------------------------------------------
lua <<EOF
require'hop'.setup()
EOF

" ------------------------------------------
" FZF
" ------------------------------------------

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  ccl
  botright copen
endfunction

let g:fzf_preview_window = []
let g:fzf_layout = { 'down': '15%' }
"let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_action = {
    \ 'ctrl-q': function('s:build_quickfix_list'),
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-d': 'vsplit'}

" ------------------------------------------
" Key bindings
" ------------------------------------------

function FocusQuickfix()
   ccl
   botright copen
endfunction

:imap jj <ESC>
nnoremap <Space> <Nop>
let mapleader = " "
"nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-p> :GFiles<CR>

nnoremap <leader>o  :call FocusQuickfix()<CR>
nnoremap <leader>f  :Rg<SPACE>
nnoremap <C-f>      :Rg<SPACE>
nnoremap <leader>b  :Buffers<CR>
nnoremap <C-b>      :Buffers<CR>
nnoremap <leader>c  :vsp $MYVIMRC<CR>
nnoremap <leader>s  :source $MYVIMRC<CR>
nnoremap <leader>d  :NvimTreeFocus<CR>

" Tab navigation like Firefox
nnoremap <S-tab>    :tabprevious<CR>
"nnoremap <tab>     :tabnext<CR>
nnoremap <C-t>      :tabnew<CR>
inoremap <C-t>      <Esc>:tabnew<CR>

nnoremap <C-n>      :bnext<CR>
nnoremap <C-m>      :bprev<CR>

nnoremap gh         :CclsCallHierarchy -float<CR>
nnoremap <leader>w  :HopWord<CR>

