set complete=.,w,b,u
set nocompatible              " be iMproved, required


"---Splits---"
set splitbelow
set splitright


"---General-Styling---"
set number	"Show line numbers"
set hlsearch	"Highlight the search"
set incsearch	"Incremental highlight"
set backspace=indent,eol,start

let mapleader = ',' "Default leader is \ but let's use , to set a better namespace"


"---Visuals---"
syntax enable	"Enable syntax highlight"
set t_CO=256	"Use 256 colors"
colorscheme industry	"Use custom color scheme"


"--Indents---"
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab	"Use spaces instead of tabs"


"---Mappings---"

"Map vimrc to a command"
nmap <Leader>ev :tabedit ~/.vimrc<cr>
"Remove search highlight"
nmap <Leader><space> :nohlsearch<cr>
"Search for a tag"
nmap <Leader>f :tag<space>

