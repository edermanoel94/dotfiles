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
set nocursorline
set textwidth=120
set re=0

set clipboard=unnamed
set completeopt-=preview

set path+=**

let mapleader=" "

map Q <Nop>

" replace all with case sensitive
" nnoremap <leader>s :%s/<C-r><C-w>//gI<Left><Left><Left>
nnoremap <silent><leader>Q :q<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>c :copen<CR>
nnoremap <leader>a :cclose<CR>

nnoremap <silent><C-l> :nohl<CR>:syntax sync fromstart<CR>

" Save searches
set viminfo+=/10000

noremap x "_x
noremap X "_x

nnoremap / /\v
vnoremap / /\v

" keep more context when scrolling off the end of a buffer
set scrolloff=1

set mouse=a mousehide

call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'natebosch/vim-lsc'
Plug 'vim-test/vim-test'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'

call plug#end()

"---------------------------------------------------------------- PERSISTENT UNDO {{{1
let undodir = expand('~/.vim/undo')
if !isdirectory(undodir)
  call mkdir(undodir)
endif
set undodir=~/.vim/undo
set undofile


"---------------------------------------------------------------- LSP {{{1

let g:lsc_trace_level = 'verbose'

let g:lsc_server_commands = {
    \ 'cpp': {
        \ 'command': 'clangd --background-index',
        \ 'suppress_stderr': v:true
    \},
    \ 'c': {
        \ 'command': 'clangd --background-index',
        \ 'suppress_stderr': v:true
    \},
    \ 'go': {
        \ 'command': 'gopls serve',
        \ 'supress_stderr': v:true,
        \ 'workspace_settings': {
            \ 'gopls': {
                \ 'gofumpt': v:true,
            \}
        \}
    \},
\}

let g:lsc_auto_map = v:true

let g:lsc_auto_map = {
    \ 'GoToDefinition': 'gd',
    \ 'GoToDefinitionSplit': ['<C-W>]', '<C-W><C-]>'],
    \ 'FindReferences': 'gr',
    \ 'NextReference': '<C-n>',
    \ 'PreviousReference': '<C-p>',
    \ 'FindImplementations': 'gI',
    \ 'FindCodeActions': 'ga',
    \ 'Rename': '<leader>rn',
    \ 'ShowHover': v:true,
    \ 'DocumentSymbol': 'gs',
    \ 'WorkspaceSymbol': 'gS',
    \ 'SignatureHelp': '<C-K>',
    \ 'Completion': 'completefunc',
    \}

"---------------------------------------------------------------- NERDTree {{{1
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>E :NERDTreeFind<CR>

"---------------------------------------------------------------- Theme {{{1

highlight ColorColumn ctermbg=0 guibg=lightgrey

set termguicolors
set bg=dark

colorscheme gruvbox

"---------------------------------------------------------------- Vim Test {{{1
let test#strategy = "vimterminal"

nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>

let g:test#go#gotest#options = '-v'

function! DebugNearest()
  let g:test#go#runner = 'delve'
  TestNearest
  unlet g:test#go#runner
endfunction

nmap <silent> d<C-n> :call DebugNearest()<CR>

"---------------------------------------------------------------- MISC {{{1
function! s:create_breakpoint() abort
  let l:line = "b" . " " . expand('%') . ":" . line(".")
  if len(l:line) > 0
    if len(getline('.')) < 1
      echoerr "cannot get statement from this line"
      return
    endif
    call setreg("+", l:line)
    echom l:line
  else
    echoerr "cannot find filename"
  endif
endfunction

function! s:open_github_repo_code() abort
  let l:cur_proj = trim(fnamemodify(system('pwd'), ':t'))
  let l:file = expand('%') . "#L" . line(".")
  let l:branch_tag = trim(system('git rev-parse --abbrev-ref HEAD'))
  echom l:branch_tag
  let l:link_gh = "https://github.com/pismo/" . l:cur_proj . "/tree/". l:branch_tag . "/" . l:file
  let l:cmd = "open " . l:link_gh
  call setreg("+", l:link_gh)
  call system(l:cmd)
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>create_breakpoint()<CR>

nmap <leader>f :<C-u>call <SID>open_github_repo_code()<CR>

"---------------------------------------------------------------- BOOKMARK {{{1

let g:bookmark_no_default_key_mappings = 1

nmap <Leader>mm <Plug>BookmarkToggle
nmap <Leader>mt <Plug>BookmarkAnnotate
nmap <Leader>ma <Plug>BookmarkShowAll

"---------------------------------------------------------------- JQ {{{1

if executable('jq')
  nnoremap <leader>jq :%!jq .<CR>
  nnoremap <leader>ji :%!jq -rc .<CR>
endif
