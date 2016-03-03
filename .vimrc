set nocompatible
filetype  off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'

call vundle#end()
filetype plugin indent on
syntax on

set background=dark
colorscheme solarized

set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

set number
set relativenumber

set clipboard=unnamed

"set guifont=DejaVu\ Sans\ Mono\ 13 
set guifont=Inconsolata\ for\ Powerline\ 14

set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
" Always show statusline
set laststatus=2

" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256
set term=xterm-256color
set termencoding=utf-8
let g:Powerline_symbols = 'fancy'
"let g:Powerline_symbols.space = "\ua0"
