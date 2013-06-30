syntax on
set tabstop=8
set expandtab
set softtabstop=4
set shiftwidth=4
set background=dark
filetype indent plugin on
au BufEnter,BufRead *.py setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
