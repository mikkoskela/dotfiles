set runtimepath^=/.vim runtimepath+=/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
call plug#begin('~/.vim/plugged')

Plug 'nvim-lua/plenary.nvim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-vinegar'

call plug#end()

" Plugin configuration
lua require('telescope').load_extension('fzf')

let NERDTreeHijackNetrw = 0
let NERDTreeShowHidden = 1

" Key bindings

nnoremap <leader>t :NERDTreeToggle<cr>

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" Set theme
set background=light
colorscheme PaperColor
