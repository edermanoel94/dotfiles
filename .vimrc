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
set updatetime=300

set wildignore+=__debug_bin
set wildignore+=*.o,*.a,*.so,*.pyc,*.swp,.git/,*.class,*/target/*,*.idea/*,venv/,node_modules/

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

"set laststatus=2
"set statusline=[%n]\ %<%f%h%m

" keep more context when scrolling off the end of a buffer
set scrolloff=1

set mouse=a mousehide

call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'doums/darcula'
Plug 'ayu-theme/ayu-vim'
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'aklt/plantuml-syntax'
Plug 'tyru/open-browser.vim'
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
Plug 'edermanoel94/vim-test'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'zhimsel/vim-stay'
Plug 'junegunn/goyo.vim'
Plug 'pablopunk/persistent-undo.vim'
Plug 'luochen1990/rainbow'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

"---------------------------------------------------------------- NERDTree {{{1
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>E :NERDTreeFind<CR>

"---------------------------------------------------------------- Theme {{{1

let g:rainbow_active = 1

highlight ColorColumn ctermbg=0 guibg=lightgrey

set termguicolors
set bg=dark

" colorscheme gruvbox
colorscheme darcula

"---------------------------------------------------------------- Plantuml Previewer {{{1

"au FileType plantuml let g:plantuml_previewer#plantuml_jar_path = get(
"    \  matchlist(system('cat `which plantuml` | grep plantuml.jar'), '\v.*\s[''"]?(\S+plantuml\.jar).*'),
"    \  1,
"    \  0
"    \)

nmap <silent> <leader>pl :PlantumlOpen<CR>
nmap <silent> <leader>ps :PlantumlStart<CR>

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

"---------------------------------------------------------------- GOYO {{{1
autocmd BufNewFile,BufRead *.slide call SetVimPresentationMode()

function SetVimPresentationMode()
  nnoremap <buffer> <Right> :n<CR>
  nnoremap <buffer> <Left> :N<CR>

  if !exists('#goyo')
    Goyo
  endif
endfunction

"---------------------------------------------------------------- Fugitive {{{1

nnoremap <leader>gl :Git blame<CR>

"---------------------------------------------------------------- GO {{{1
autocmd BufNewFile,BufRead *.go setlocal foldmethod=syntax foldlevel=99 noexpandtab tabstop=4 shiftwidth=4

au BufRead,BufNewFile *.gohtml set filetype=gohtmltmpl

let g:go_fmt_experimental = 1
let g:go_decls_includes = 'func,type'
let g:go_decls_mode = 'fzf'

let g:go_test_timeout = "30s"
let g:go_test_show_name = 1
let g:go_list_type = "quickfix"

" Navigation / rename / diagnostics come from vim-lsp (gopls).
" vim-go keeps :GoTest, :GoCoverage, :GoFillStruct, :GoAddTags, alternate files.
let g:go_fmt_autosave = 0
let g:go_imports_autosave = 0
let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0

let g:go_textobj_include_function_doc = 0

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1

let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1

let g:go_addtags_transform = "camelcase"

let g:go_fold_enable = [ 'block',  'import',  'package_comment',  'comment' ]

" Alternates file
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

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

" FZF

nnoremap <C-p> :Files!<CR>
nnoremap <C-b> :Buffers<CR>

" RG

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

nnoremap <C-f> :Rg 

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

"---------------------------------------------------------------- LSP {{{1

let g:lsp_settings = {
\   'gopls': {
\     'workspace_config': {
\       'gopls': {
\         'gofumpt': v:true,
\         'staticcheck': v:true,
\         'usePlaceholders': v:true,
\       },
\     },
\   },
\ }

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_document_highlight_enabled = 1
let g:lsp_signs_enabled = 1

let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<CR>"

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes

  nmap <buffer> gd         <plug>(lsp-definition)
  nmap <buffer> gD         <plug>(lsp-declaration)
  nmap <buffer> gr         <plug>(lsp-references)
  nmap <buffer> gi         <plug>(lsp-implementation)
  nmap <buffer> gt         <plug>(lsp-type-definition)
  nmap <buffer> K          <plug>(lsp-hover)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> g.         <plug>(lsp-code-action)
  nmap <buffer> [g         <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g         <plug>(lsp-next-diagnostic)
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

augroup lsp_format_go
  au!
  autocmd BufWritePre *.go call execute('LspDocumentFormatSync')
augroup END

"---------------------------------------------------------------- GO DIAGNOSTICS (LSP + golangci-lint) {{{1

" Combined quickfix: gopls diagnostics + golangci-lint output.
" - BufWritePost: re-runs golangci-lint (sync) and rebuilds the qf list.
" - User lsp_diagnostics_updated: rebuilds qf with latest gopls diagnostics
"   plus the last stored golangci-lint items.

let s:go_lint_items = []

function! s:lsp_diagnostics_to_items(bufnr) abort
  let l:items = []
  if !exists('*lsp#internal#diagnostics#state#_get_all_diagnostics_grouped_by_server_for_buffer')
    return l:items
  endif
  let l:grouped = lsp#internal#diagnostics#state#_get_all_diagnostics_grouped_by_server_for_buffer(a:bufnr)
  for l:server in keys(l:grouped)
    for l:d in l:grouped[l:server]
      let l:severity = get(l:d, 'severity', 1)
      let l:type = l:severity ==# 1 ? 'E' : (l:severity ==# 2 ? 'W' : 'I')
      call add(l:items, {
      \   'bufnr': a:bufnr,
      \   'lnum':  l:d.range.start.line + 1,
      \   'col':   l:d.range.start.character + 1,
      \   'text':  '[' . l:server . '] ' . substitute(l:d.message, '\n', ' ', 'g'),
      \   'type':  l:type,
      \ })
    endfor
  endfor
  return l:items
endfunction

function! s:refresh_go_qf() abort
  if &filetype !=# 'go' | return | endif
  let l:items = s:lsp_diagnostics_to_items(bufnr('%')) + s:go_lint_items
  call setqflist([], ' ', {
  \   'title': 'GO DIAGNOSTIC:',
  \   'items': l:items,
  \ })
  if empty(s:go_lint_items)
    cclose
  else
    botright copen
    wincmd p
  endif
endfunction

let s:go_lint_job = v:null
let s:go_lint_output = []

function! s:golangci_lint_on_out(ch, msg) abort
  call add(s:go_lint_output, a:msg)
endfunction

function! s:golangci_lint_on_exit(job, status) abort
  let l:parsed = getqflist({'lines': s:go_lint_output, 'efm': '%f:%l:%c: %m,%f:%l: %m'})
  let s:go_lint_items = map(filter(get(l:parsed, 'items', []), 'v:val.valid'),
  \   {_, i -> extend(i, {'text': '[golangci-lint] ' . i.text})})
  let s:go_lint_output = []
  let s:go_lint_job = v:null
  call s:refresh_go_qf()
endfunction

function! s:golangci_lint() abort
  if !executable('golangci-lint')
    let s:go_lint_items = []
    call s:refresh_go_qf()
    return
  endif
  if s:go_lint_job isnot v:null && job_status(s:go_lint_job) ==# 'run'
    call job_stop(s:go_lint_job)
  endif
  let s:go_lint_output = []
  let s:go_lint_job = job_start(['golangci-lint', 'run'], {
  \   'cwd':     expand('%:p:h'),
  \   'out_cb':  function('s:golangci_lint_on_out'),
  \   'err_cb':  function('s:golangci_lint_on_out'),
  \   'exit_cb': function('s:golangci_lint_on_exit'),
  \ })
endfunction

augroup go_diagnostics_qf
  au!
  autocmd BufWritePost *.go call s:golangci_lint()
augroup END

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
