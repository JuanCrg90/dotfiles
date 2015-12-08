set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'


" Syntax and language improvements
Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Raimondi/delimitMate'
Plugin 'scrooloose/syntastic'
Plugin 'mattn/emmet-vim'
Plugin 'edsono/vim-matchit'
Plugin 'jiangmiao/auto-pairs'

" Color Scheme
Plugin 'tomasr/molokai'

" Navigation
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'

" Git integration
Plugin 'tpope/vim-fugitive'

" Close buffer without close the window
Plugin 'moll/vim-bbye'

" JSDoc integration
Plugin 'heavenshell/vim-jsdoc'

" Multiple Cursors
Plugin 'terryma/vim-multiple-cursors'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ


" Put your non-Plugin stuff after this line

" Define the map leader key
let mapleader = ","

" Colors
set t_Co=256
colorscheme molokai
set background=dark

" Deactivate cursor keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" Hide mouse when typing
set mousehide

" Search configuration
set incsearch
set hlsearch
set ignorecase
set smartcase
set showmatch
set matchtime=2 " How many tenths of a second to blink

" Switch syntax highlighting on
syntax on

" Show line numbers
set number

" ctrlp.vim
let g:ctrlp_working_path_mode = 'ra'

" Indentation
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set wrap

" Strip trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Show NERDTree
nmap <leader>ne :NERDTree<cr>

" Close Buffer without close window moll/vim-bbye
nnoremap <Leader>q :Bdelete<CR>


" Syntastic

let g:syntastic_enable_signs=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': [] }
let g:syntastic_check_on_wq = 0
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_scss_checkers = ['scss_lint']


" Emmet
let g:user_emmet_leader_key='<tab>'
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" Poweline support
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

set laststatus=2

