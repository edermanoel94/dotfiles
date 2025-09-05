set nocompatible

filetype off
filetype plugin indent on

syntax on

set encoding=UTF-8

set autoread
set hidden
set noerrorbells
set tabstop=2 softtabstop=2 shiftwidth=2 shiftround expandtab nowrap
set noswapfile cursorline
set autoindent copyindent smartindent
set nu relativenumber
set hlsearch incsearch ignorecase smartcase
set colorcolumn=120
set textwidth=120
set re=0
set viewoptions=cursor,folds,slash,unix
set viewoptions-=options

set clipboard=unnamed
set completeopt-=preview
set updatetime=100

set wildignore+=__debug_bin
set wildignore+=*.o,*.a,*.so,*.pyc,*.swp,.git/,*.class,*/target/*,*.idea/*,venv/,node_modules/

set path+=**

let mapleader=" "

map Q <Nop>

" replace all with case sensitive
" nnoremap <leader
