set nocompatible
filetype off

call plug#begin('~/.vim/plugged')

" TODOs in a file: <leader>t
Plug 'vim-scripts/TaskList.vim'

" Movement: <leader><leader>{w,b,j,k}
Plug 'easymotion/vim-easymotion'

" Colorscheme (vim fallback; nvim uses tokyonight)
Plug 'Lokaltog/vim-distinguished'

" HTML/CSS expand
Plug 'mattn/emmet-vim'
Plug 'mattn/webapi-vim'

" Fuzzy finder (vim only — nvim uses Telescope)
Plug 'ctrlpvim/ctrlp.vim'

" Search across files
Plug 'mileszs/ack.vim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'sjl/gundo.vim'
Plug 'majutsushi/tagbar'
Plug 'tomtom/tcomment_vim'
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

" Solidity
Plug 'tomlion/vim-solidity'

" nvim-only
if has('nvim')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'folke/tokyonight.nvim'
endif

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set history=1000
set wildignore=*.swp,*.bak,*.pyc,*.class
set autowrite
set cmdheight=1
set number
set relativenumber
set numberwidth=1
set colorcolumn=80
set title
set wildmenu
set wildmode=list:longest,full
set nowrap
set encoding=utf-8
if !has('nvim')
  set pastetoggle=<F3>
  set guioptions+=b
endif
set laststatus=2
set scrolloff=7
set shiftround
set showcmd
set ruler
set hidden
set cursorline
set clipboard=unnamed
set mouse=a
set whichwrap=h,l,~,[,]
set tm=500
set backspace=eol,start,indent
set magic
set showmatch
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

set completeopt=menuone,longest,preview

set incsearch
set hlsearch
set ignorecase
set smartcase

let mapleader=","
let g:mapleader=","

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>

nmap <leader>v :vsplit<cr>
nmap <leader>s :split<cr>

map <leader>ea :e! ~/.bash_aliases<cr>
map <leader>eb :e! ~/.bashrc<cr>
map <leader>es :e! ~/.ssh/config<cr>
map <leader>ev :e! ~/.vimrc<cr>

map <leader>p :echo expand('%:p')<cr>

nmap <silent> <leader>k :wincmd k<CR>
nmap <silent> <leader>j :wincmd j<CR>
nmap <silent> <leader>h :wincmd h<CR>
nmap <silent> <leader>l :wincmd l<CR>

nnoremap <leader>1 :resize +5<cr>
nnoremap <leader>2 :resize -5<cr>
nnoremap <leader>3 :vertical resize +5<cr>
nnoremap <leader>4 :vertical resize -5<cr>

command! BD bp | sp | bn | bd

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shell=/bin/bash
if !has('nvim')
  set guioptions-=T
  if !has('gui_running')
    set t_Co=256
  endif
endif
if has('termguicolors')
  set termguicolors
endif

syntax enable
set background=light
colorscheme distinguished

highlight Cursor  cterm=reverse gui=reverse
highlight iCursor cterm=reverse gui=reverse

try
  lang en_US
catch
endtry

if has("gui_running")
  set lines=43
  set co=87
  set fu
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text, tab, indent
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=120
set smarttab
set expandtab
set linebreak
set autoindent
set smartindent
set wrap

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files, backups, undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup
set nowritebackup
set noswapfile

if !isdirectory($HOME.'/.vim/undodir')
  call mkdir($HOME.'/.vim/undodir', 'p')
endif
set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folds
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>za :set foldmethod=indent<cr>
nnoremap <leader>zz :set foldlevel=99<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType python nnoremap <buffer> <F5> :w<CR>:!python %<CR>
autocmd FileType python setlocal spell spelllang=en_us

autocmd BufEnter,BufRead *.mkd,*.md,*.mdown,*.markdown setlocal tw=0 spell

autocmd FileType html,xhtml,css setlocal sw=4 ts=4 sts=4 textwidth=0
autocmd FileType javascript,typescript setlocal sw=2 ts=2 sts=2

" Strip trailing whitespace on save (skip markdown — trailing 2 spaces = <br>)
autocmd BufWritePre * if &filetype !~? 'markdown' | %s/\s\+$//e | endif

autocmd FileType css        setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python     setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml        setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType vim        setlocal omnifunc=syntaxcomplete#Complete

augroup QFClose
  autocmd!
  autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix" | q | endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" CtrlP (vim only; nvim overrides <leader>f with Telescope)
map <leader>f  :CtrlP<CR>
map <leader>fp :CtrlP ~/projects<CR>

" Lightline + buffer tabline at top
set showtabline=2
let g:lightline = {
  \ 'tabline':          { 'left': [['buffers']], 'right': [['close']] },
  \ 'component_expand': { 'buffers': 'lightline#bufferline#buffers' },
  \ 'component_type':   { 'buffers': 'tabsel' },
  \ }
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline#bufferline#show_number  = 2

nnoremap <leader>/ :bnext<cr>
nnoremap <leader>. :bprev<cr>
nnoremap <leader>` :bdelete<cr>

nmap <leader>b1 <Plug>lightline#bufferline#go(1)
nmap <leader>b2 <Plug>lightline#bufferline#go(2)
nmap <leader>b3 <Plug>lightline#bufferline#go(3)
nmap <leader>b4 <Plug>lightline#bufferline#go(4)
nmap <leader>b5 <Plug>lightline#bufferline#go(5)

" Tagbar
let g:tagbar_usearrows   = 1
let g:tagbar_width       = 30
let g:tagbar_singleclick = 1
nnoremap <leader>; :TagbarToggle<CR>

set tags=tags;/

" NERDTree
augroup NERDTreeAutoclose
  autocmd!
  autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
augroup END

function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" SentiLink-specific path — change for other systems
nnoremap <leader>tr :NERDTreeToggle ~/go/src/github.com/sentilink<CR>
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeMouseMode     = 3
let g:NERDTreeWinSize       = 30
let NERDTreeIgnore          = ['\.pyc$']
