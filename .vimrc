set complete=.,w,b,u
set nocompatible "be iMproved, required
set wrapscan "Cycle search
set clipboard=unnamedplus
set mouse=a


"---Splits---"
set splitbelow
set splitright

nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>

"---General-Styling---"
set title "Show file title
set number	"Show line numbers
set cursorline "Show cursorline
set hlsearch	"Highlight the search
set incsearch	"Incremental highlight
set ignorecase "Ignore case during search
set smartcase "User smart case for mixed case search
set showmode
set showmatch
set backspace=indent,eol,start
set signcolumn=yes

let mapleader = ',' "Default leader is \ but let's use , to set a better namespace


"---Visuals---"
syntax enable "Enable syntax highlight"
set t_CO=256 "Use 256 colors"
"highlight clear SignColumn
filetype plugin indent on "auto-indent based on file type


"--Indents---"
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab "Use spaces instead of tabs


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


"---Undo---
if empty(glob($HOME . '/.vim/undodir'))
    call mkdir($HOME . '/.vim/undodir', 'p')
endif

set undofile "Maintain undofiles between sessions
set undodir=~/.vim/undodir

"---Plugins---
let NERDTreeHijackNetrw = 0
let NERDTreeShowHidden = 1

"---Auto-commands---"

"Source vimrc on save automatically
augroup autosourcing
	autocmd!
	autocmd BufWritePost .vimrc source %
augroup END
