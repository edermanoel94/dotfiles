set guifont=FiraCode\ Nerd\ Font\ Mono:h10
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=L
set guioptions-=b

highlight Cursor guifg=black guibg=white
highlight iCursor guifg=black guibg=white
set guicursor=n-v-c:block-Cursor

let &t_SI = "\e[4 q"
let &t_SR = "\e[6 q"
let &t_EI = "\e[2 q"
let &t_ti .= "\e[1 q"
let &t_te .= "\e[0 q"
