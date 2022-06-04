set complete=.,w,b,u
set nocompatible "be iMproved, required"
set wrapscan "Cycle search"


"---Splits---"
set splitbelow
set splitright

nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>

"---General-Styling---"
set number	"Show line numbers"
set cursorline "Show cursorline"
set hlsearch	"Highlight the search"
set incsearch	"Incremental highlight"
set showmode
set backspace=indent,eol,start
set signcolumn=yes

let mapleader = ',' "Default leader is \ but let's use , to set a better namespace"


"---Visuals---"
syntax enable	"Enable syntax highlight"
set t_CO=256	"Use 256 colors"
"colorscheme delek	"Use custom color scheme"
"set guifont=Fira_Code:h16
highlight clear SignColumn


"--Indents---"
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab	"Use spaces instead of tabs"


"---Mappings---"
"Map vimrc to a command"
"nmap <Leader>ev :tabedit ~/.vimrc<cr>
"Remove search highlight"
"nmap <Leader><space> :nohlsearch<cr>
"Search for a tag"
nmap <Leader>f :tag<space>
"Better NerdTreeToggle"
"nmap <Leader>1 :NERDTreeToggle<cr>
"nmap <Leader>f :tag<space>

"---Plugins---"
let NERDTreeHijackNetrw = 0

"---Auto-commands---"

"Source vimrc on save automatically"
augroup autosourcing
	autocmd!
	autocmd BufWritePost .vimrc source %
augroup END
