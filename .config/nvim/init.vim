let g:airline_powerline_fonts = 1
let g:ccls_levels = 10

" ------------------------------------------
" Plugins
" ------------------------------------------
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tomasiser/vim-code-dark'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tikhomirov/vim-glsl'
Plug 'bfrg/vim-cpp-modern'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'neovim/nvim-lspconfig'
Plug 'm-pilia/vim-ccls'
call plug#end()

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
        hide_root_folder =  false,
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
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local ccls_cmd = "ccls"

if vim.loop.os_uname().sysname == "Windows_NT" then
    ccls_cmd = "C:/Program Files (x86)/ccls/bin/ccls.exe"
end

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
" Mixed
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

" Display tabs and spaces
set list
set listchars=tab:›\
set listchars+=lead:·
set listchars+=trail:·
set listchars+=multispace:·
highlight SpecialKey ctermfg=240 guifg=grey70

" Syntax highlighting
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1

" ------------------------------------------
" FZF
" ------------------------------------------
"let g:fzf_layout = { 'down': '20%' }
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-d': 'vsplit'}

" Indent using spaces
set tabstop=4
set shiftwidth=4
set expandtab

set timeoutlen=1000 ttimeoutlen=0 " remove ESC timeout

set cursorline " highlight current line

" ------------------------------------------
" Key bindings
" ------------------------------------------
:imap jj <ESC>
let mapleader = "\<Space>"
"nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <leader>f :Rg<SPACE>
nnoremap <leader>b :Buffers<CR>
nnoremap <C-b>     :Buffers<CR>
nnoremap <leader>c :vsp $MYVIMRC<CR>
nnoremap <leader>s :source $MYVIMRC<CR>

nnoremap <C-S-e>    :NvimTreeFocus<CR>
nnoremap <leader>e  :NvimTreeFocus<CR>

" Tab navigation like Firefox
nnoremap <S-tab>    :tabprevious<CR>
"nnoremap <tab>     :tabnext<CR>
nnoremap <C-t>      :tabnew<CR>
inoremap <C-t>      <Esc>:tabnew<CR>

nnoremap gh         :CclsCallHierarchy -float<CR>

