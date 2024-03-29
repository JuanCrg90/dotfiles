set nocompatible
filetype off

call plug#begin('~/.vim/plugged')

" Syntax and language improvements
Plug 'jelera/vim-javascript-syntax'
Plug 'othree/yajs.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'dense-analysis/ale'
Plug 'mattn/emmet-vim'
Plug 'geoffharcourt/vim-matchit'
Plug 'jiangmiao/auto-pairs'
Plug 'editorconfig/editorconfig-vim'

" React Syntax highlighting and indenting Support
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'styled-components/vim-styled-components'

" Ruby Stuff
Plug 'janko/vim-test'
Plug 'benmills/vimux'

" Color Scheme
Plug 'tanvirtin/monokai.nvim'
Plug 'patstockwell/vim-monokai-tasty'

" Lualine
Plug 'nvim-lualine/lualine.nvim'

" Navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'scrooloose/nerdtree'
Plug 'rking/ag.vim'

" Git integration
Plug 'tpope/vim-fugitive'

" Close buffer without close the window
Plug 'moll/vim-bbye'

Plug 'hashivim/vim-terraform'

Plug 'mrdotb/vim-tailwindcss'
" All of your Plugs must be added before the following line
call plug#end()
filetype plugin indent on    " required

" Define the map leader key
let mapleader = ","

" .vimrc editing made easy
nnoremap <silent> <Leader>c :vs $MYVIMRC<CR>
nnoremap <silent> <Leader>o :so $MYVIMRC<CR>

" Display all matching files when we tab complete
set wildmenu

" Swap file path
set swapfile
set dir=~/.tmp

" Clipboard
set clipboard=unnamed

" Copy filename to clipboard
nmap ,cs :let @*=expand("%")<CR>

" Copy full path to clipboard
nmap ,cl :let @*=expand("%:p")<CR>

" set Vim-specific sequences for RGB colors
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

syntax on
"colorscheme monokai

let g:vim_monokai_tasty_italic = 1
colorscheme vim-monokai-tasty

" Deactivate cursor keys
" nnoremap <up> <nop>
" nnoremap <down> <nop>
" nnoremap <left> <nop>
" nnoremap <right> <nop>
" inoremap <up> <nop>
" inoremap <down> <nop>
" inoremap <left> <nop>
" inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" Hide mouse when typing
set mouse=a
set mousehide

" Search configuration
set incsearch
set hlsearch
set ignorecase
set smartcase
set showmatch
set matchtime=2 " How many tenths of a second to blink
nnoremap <silent> <leader><space> :nohlsearch<CR>

" Automatic toggling between line number modes
:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" Add fuzzy finder to runtimepath
set rtp+=/usr/local/opt/fzf
nnoremap <silent> <C-p> :FZF<CR>

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

autocmd BufWritePre * %s/\s\+$//e

" Close Buffer without close window moll/vim-bbye
nnoremap <leader>q :Bdelete<CR>

" git commit messages
autocmd Filetype gitcommit setlocal spell textwidth=72

" Nerd Tree
let NERDTreeShowHidden=1
let NERDTreeIgnore=['.DS_Store']
" Show NERDTree
nnoremap <leader>ne :NERDTree<cr>
" Show file in NERDTree
nnoremap <leader>nf :NERDTreeFind<cr>

" Ale
let g:ale_linters = {
\   'javascript': ['eslint', 'prettier'],
\   'ruby': ['reek', 'rubocop', 'ruby'],
\   'css': ['stylelint'],
\   'sass': ['stylelint'],
\   'scss': ['stylelint'],
\   'haml': ['hamllint'],
\   'typescript': ['tslint', 'tsserver']
\}
let g:ale_sign_column_always = 1

" Emmet
let g:user_emmet_leader_key='<tab>'
let g:user_emmet_settings = {
\  'javascript.jsx' : {
\      'extends' : 'jsx',
\  },
\}

autocmd FileType html,css,js,javascript.jsx EmmetInstall

" CSS Complete
" https://github.com/csexton/snipmate.vim
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd BufNewFile,BufRead *.scss set ft=scss.css
inoremap <leader>, <C-x><C-o>

" Allow highlighting in js files
let g:jsx_ext_required = 0

" Ag configuration
nnoremap <leader>/ :Ag

" map esc key to jj
inoremap jj <Esc>

" Add " around word
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel

" Add ' around word
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel

" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
let test#strategy = "vimux"
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

nnoremap <leader>d obinding.pry
nnoremap <leader>r :silent !touch tmp/restart.txt

" Set the completefunc you can do this per file basis or with a mapping
set completefunc=tailwind#complete
" The mapping I use
nnoremap <leader>tt :set completefunc=tailwind#complete<cr>
" Add this autocmd to your vimrc to close the preview window after the completion is done
autocmd CompleteDone * pclose

lua << END
require'lualine'.setup()
END
