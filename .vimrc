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
set foldmethod=manual
set re=0

set clipboard=unnamed
set completeopt-=preview
set updatetime=100

set wildignore+=__debug_bin
set wildignore+=*.o,*.a,*.so,*.pyc,*.swp,.git/,*.class,*/target/*,*.idea/*,venv/,node_modules/

set path+=**

let mapleader=" "

map Q <Nop>

" replace all with case sensitive
" nnoremap <leader>s :%s/<C-r><C-w>//gI<Left><Left><Left>
nnoremap <silent><leader>Q :q<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>a :cclose<CR>
nnoremap <leader>gb :!git blame % -L 10<CR>

nnoremap <leader>lg :!lazygit<CR>

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

Plug 'junegunn/fzf', {'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'doums/darcula'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'kien/rainbow_parentheses.vim'
Plug 'pablopunk/persistent-undo.vim'
Plug 'airblade/vim-gitgutter'
Plug 'vim-test/vim-test'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()


autocmd BufWritePost *.c,*.h silent! exec "!ctags -R ."


"---------------------------------------------------------------- NERDTree {{{1

nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>E :NERDTreeFind<CR>

"---------------------------------------------------------------- Theme {{{1

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

highlight ColorColumn ctermbg=0 guibg=lightgrey

"colorscheme gruvbox
colorscheme darcula
set termguicolors
"set bg=dark

"---------------------------------------------------------------- Vim Test {{{1
let test#strategy = "vimterminal"

nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>

let g:test#go#gotest#options = '-v'

function! DebugNearest()
  let g:test#go#runner = 'delve'
  TestNearest
  unlet g:test#go#runner
endfunction

function! DebugFile()
  let g:test#go#runner = 'delve'
  TestFile
  unlet g:test#go#runner
endfunction

nmap <silent> d<C-n> :call DebugNearest()<CR>
nmap <silent> d<C-f> :call DebugFile()<CR>

"---------------------------------------------------------------- GO {{{1
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

au BufRead,BufNewFile *.gohtml set filetype=gohtmltmpl

let g:go_fmt_experimental = 1
let g:go_decls_includes = 'func,type'
let g:go_decls_mode = 'fzf'

let g:go_test_timeout = "30s"
let g:go_test_show_name = 1
let g:go_list_type = "quickfix"
let g:go_fmt_command = "gopls"

let g:go_textobj_include_function_doc = 0

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1

let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1

let g:go_metalinter_enabled = ['govet', 'revive', 'golint', 'errcheck']
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['golint']

let g:go_addtags_transform = "camelcase"

let g:go_doc_popup_window = 1
let g:go_auto_type_info = 1

" Alternates file
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

autocmd FileType go nmap gr <Plug>(go-referrers)
autocmd FileType go nmap gi <Plug>(go-implements)
autocmd FileType go nmap gI <Plug>(go-if-err)
autocmd FileType go nmap gs <Plug>(go-decls)
autocmd FileType go nmap gS <Plug>(go-decls-dir)

autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>fs <Plug>(go-fill-struct)
autocmd FileType go nmap <leader>ta <Plug>(go-add-tags)
autocmd FileType go nmap <leader>rn <Plug>(go-rename)

let g:go_debug_windows = {
      \ 'vars':       'leftabove 50vnew',
      \ 'stack':      'leftabove 50new',
      \ }

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

"---------------------------------------------------------------- FZF {{{1
nnoremap <C-p> :Files!<CR>
nnoremap <C-b> :Buffers<CR>

"---------------------------------------------------------------- JQ {{{1

if executable('jq')
  nnoremap <leader>jq :%!jq .<CR>
  nnoremap <leader>ji :%!jq -rc .<CR>
endif

"---------------------------------------------------------------- WHITESPACE {{{1
if exists('loaded_trailing_whitespace_plugin') | finish | endif

let loaded_trailing_whitespace_plugin = 1

if !exists('g:extra_whitespace_ignored_filetypes')
  let g:extra_whitespace_ignored_filetypes = []
endif

function! ShouldMatchWhitespace()
  for ft in g:extra_whitespace_ignored_filetypes
    if ft ==# &filetype | return 0 | endif
  endfor
  return 1
endfunction

highlight default ExtraWhitespace ctermbg=darkred guibg=darkred

autocmd ColorScheme * highlight default ExtraWhitespace ctermbg=darkred guibg=darkred
autocmd BufRead,BufNew * if ShouldMatchWhitespace() | match ExtraWhitespace /\\\@<![\u3000[:space:]]\+$/ | else | match ExtraWhitespace /^^/ | endif

autocmd InsertLeave * if ShouldMatchWhitespace() | match ExtraWhitespace /\\\@<![\u3000[:space:]]\+$/ | endif
autocmd InsertEnter * if ShouldMatchWhitespace() | match ExtraWhitespace /\\\@<![\u3000[:space:]]\+\%#\@<!$/ | endif

function! s:FixWhitespace(line1,line2)
  silent! keepjumps execute ':' . a:line1 . ',' . a:line2 . 's/\\\@<!\s\+$//'
endfunction

command! -range=% FixWhitespace call <SID>FixWhitespace(<line1>,<line2>)
