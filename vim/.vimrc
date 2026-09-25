" Plugin-free fallback; safe to source repeatedly.
set nocompatible
syntax enable
filetype plugin indent on
let mapleader = ','
set number relativenumber hidden
set ignorecase smartcase incsearch hlsearch
set expandtab tabstop=4 softtabstop=4 shiftwidth=4 shiftround
set autoindent wrap linebreak scrolloff=7
set colorcolumn=80 textwidth=120
set wildmenu wildmode=list:longest,full
set history=1000 laststatus=2
set nobackup nowritebackup noswapfile
if has('persistent_undo')
  let &undodir = expand('~/.vim/undodir')
  if !isdirectory(&undodir)
    call mkdir(&undodir, 'p', 0700)
  endif
  set undofile
endif
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>/ :bnext<CR>
nnoremap <leader>. :bprevious<CR>
nnoremap <leader>` :bdelete<CR>
augroup DotfilesVim
  autocmd!
  autocmd FileType markdown setlocal spell textwidth=0
  autocmd FileType javascript,typescript setlocal shiftwidth=2 softtabstop=2 tabstop=2
augroup END
