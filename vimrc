set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.
" Example  plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'

" Molokai Color Scheme
Plugin 'tomasr/molokai'
" crtlp plugin
Plugin 'kien/ctrlp.vim'

" NERDTree
Plugin 'scrooloose/nerdtree'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ


" Put your non-Plugin stuff after this line

" Switch syntax highlighting on
syntax on

" Show line numbers
set number

set t_Co=256
colorscheme molokai
set background=dark

" ctrlp.vim
let g:ctrlp_working_path_mode = 'ra'


