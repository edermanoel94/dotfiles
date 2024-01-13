set nocompatible

filetype off
filetype plugin indent on

syntax on

set autoread
set hidden
set noerrorbells
set tabstop=2 softtabstop=2 shiftwidth=2 shiftround expandtab nowrap
set noswapfile cursorline
set autoindent copyindent smartindent
set nu relativenumber
set hlsearch incsearch ignorecase smartcase
set encoding=utf-8
set colorcolumn=120
set textwidth=120
set foldmethod=manual

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
nnoremap <leader>q :bp<BAR>bd #<CR>
nnoremap <silent><leader>q :lclose<bar>b#<bar>bd #<CR>
nnoremap <silent><leader>Q :q<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>a :cclose<CR>

nnoremap <leader>lg :!lazygit<CR>

nnoremap <silent><C-l> :nohl<CR>:syntax sync fromstart<CR>

vnoremap <leader>f zf

" Save searches
set viminfo+=/10000

noremap x "_x
noremap X "_x

nnoremap / /\v
vnoremap / /\v

set laststatus=2
set statusline=[%n]\ %<%f%h%m

" keep more context when scrolling off the end of a buffer
set scrolloff=1

set mouse=a mousehide

call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'doums/darcula'
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
Plug 'vim-test/vim-test'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'kien/rainbow_parentheses.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

"---------------------------------------------------------------- NERDTree {{{1

nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>E :NERDTreeFind<CR>

"---------------------------------------------------------------- Theme {{{1

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

highlight ColorColumn ctermbg=0 guibg=lightgrey

" colorscheme gruvbox
colorscheme darcula
set termguicolors
set bg=dark


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

" Testing a new feature
nmap <silent> t<C-d> :call DebugNearest()<CR>

"---------------------------------------------------------------- GO {{{1
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

au BufRead,BufNewFile *.gohtml set filetype=gohtmltmpl

let g:go_fmt_experimental = 1
let g:go_decls_includes = 'func,type'
let g:go_decls_mode = 'fzf'

let g:go_test_timeout = "30s"
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

let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
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

function! s:viclip_copy(content) abort
      let encoded = system('base64', a:content)
      let req_body = json_encode(printf('{"content": "%s"}', encoded))
      silent! call system('curl --connect-timeout 1 -X POST -H "Content-Type: application/json" -d ' . req_body . ' http://192.168.0.5:8080/clip')
endfunction

function! s:viclip_is_up() abort
    let status_code = system('curl --connect-timeout 1 -s -o /dev/null -w "%{http_code}" http://192.168.0.5:8080/health')
    if status_code != 200
      return 0
    endif
    return 1
endfunction

function! s:create_breakpoint() abort
  let l:line = "b" . " " . expand('%') . ":" . line(".")
  if len(l:line) > 0
    if len(getline('.')) < 1
      echoerr "cannot get statement from this line"
      return
    endif
    let is_up = s:viclip_is_up()
    if is_up == 1
      call s:viclip_copy(l:line)
    else
      echom "viclip is current offline"
      call setreg("*", l:line)
      call setreg("+", l:line)
    endif
    echom l:line
  else
    echoerr "cannot find filename"
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>create_breakpoint()<CR>

" FZF

nnoremap <C-p> :Files!<CR>
nnoremap <C-b> :Buffers<CR>

" RG

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

nnoremap <C-f> :Rg 

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

