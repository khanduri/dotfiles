set nocompatible               " be iMproved
filetype off                   " required!

" https://github.com/spf13/spf13-vim/issues/90
set t_Co=256

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'


" Color scheme
Bundle 'cschlueter/vim-mustang'
Bundle 'godlygeek/csapprox'
Bundle 'flazz/vim-colorschemes'

filetype plugin indent on     " required!

" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed.."


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set history=1000 			   " lines of history VIM has to remember
set wildignore=*.swp,*.bak,*.pyc,*.class " Ignore some file
set autowrite 				   " auto read when a file is changed from outside
set cmdheight=1                " Explicitly set the height of the command line
set number                     " Display line numbers
set numberwidth=1              " using only 1 col (and 1 space) while possible
set title                      " show title in console title bar
set wildmenu                   " Menu completion in command mode on <Tab>
set pastetoggle=<F3>           " Press F3 for toggle paste mode
set cursorline
set colorcolumn=80             " Mark 80th column
set wildmode=list:longest,full " com-line completion <tab> (file,help,options)
set nowrap                     " no line wrapping;
set guioptions+=b              " add a horizontal scrollbar to the bottom
set enc=utf-8                  " UTF-8 as the default buffer encoding
set laststatus=2               " Always show status line, even for one window
set scrolloff=3                " Scroll when cursor is within 3 char of top/bot
set shiftround                 " Round indent to multiple of 'shiftwidth' for > and < commands
set showcmd " Show (par) commands (or selection size in Visual mode) on status
set t_RV=                      " Don't request terminal version str (for xterm)
set so=7                       "Set 7 lines to curors when moving vertical
set ruler                      "Always show current position
set hid                        "Change buffer - without saving
set nohidden
set mouse=a
set backspace=eol,start,indent " Set backspace config
set whichwrap+=<,>,h,l
set nolazyredraw               "Don't redraw while executing macros
set magic                      "Set magic on, for regular expressions
set showmatch                  "Show matching bracets when text indicator is over them
set tm=500
set noerrorbells visualbell t_vb= "No sound on errors
autocmd GUIEnter * set visualbell t_vb=

" Keystrokes
set whichwrap=h,l,~,[,] " h,l wrap bet lines, cursor keys wrap in insertion mode
set completeopt=menuone,longest,preview " Set auto-complete form

"Search options
set incsearch    " show 'best match so far' as you type
set hlsearch     " highlight the items found by the search
set ignorecase   " ignores case of letters on searches
set smartcase    " Override 'ignore-case' if search pattern has upper case chars

" Set the leader key to a comma (,)
let mapleader=","
let g:mapleader=","

nmap <leader>w :w!<cr>          " Fast saving with leader + w
map <leader>e :e! ~/.vimrc<cr>  " Fast editing of the .vimrc

" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vimrc
"au! BufWritePost $MYVIMRC source $MYVIMRC

autocmd BufWritePre * :%s/\s\+$//e

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable "Enable syntax hl
set shell=/bin/bash
set guioptions-=T
let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }
set gfn=Liberation\ Mono\ 10
set encoding=utf8

set background=dark
colorscheme kolor

try
  lang en_US
catch
endtry

" GUI is running or is about to start. Maximize gvim window.
if has("gui_running")
  set lines=43
  set co=87
  set fu
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=80
set smarttab
set expandtab
set lbr
set tw=500
set ai      "Auto indent
set si      "Smart indet
set wrap    "Wrap lines

" http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
"autocmd FileType python " Prepend this to make them python specific checks
highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
match OverLength /\%81v.\+/

" In insert mode, you can paste from clipboard using CTRL+v
inoremap <C-v> <ESC>:set paste<CR>"+gp<ESC>:set nopaste<ENTER>i<RIGHT>
autocmd BufEnter * silent! lcd %:p:h " Set def env based on current edit files
nnoremap <leader>v  " +gP            " Paste using ,v in normal mode


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup                  " Turn backup off
set nowb
set noswapfile
set undodir=~/.vim/undodir
set undofile
set undolevels=1000           "max lines changed that can be undone
set undoreload=10000          "max lines saved for undo

"nnoremap <leader>c <CR>:cclose<CR> " Shortcut to Close quickfix window with leader+c

" Folding: auto save folding: http://princ3.wordpress.com/2007/01/26/automaticaly-save-foldings-in-vim/
"set viewoptions=folds
"au BufWinLeave * silent! mkview
"au BufWinEnter * silent! loadview

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <CR> :nohlsearch<CR>/<BS> "GRB:clear search buffer when hitting return

map <silent> <leader><cr> :nohlsearch<cr>

map <leader>ba :1,300 bd!<cr> " Close all the buffers
map <leader>bd :Bclose<cr>    " Close the current buffer
map <leader>tn :tabnew! %<cr> " Tab configuration
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>cd :cd %:p:h<cr>  " Switch to the directory of the open buffer

map <C-right> :bn<CR>         " Moving tab using CTRL+ the arrows
map <C-left> :bp<CR>

noremap <Space> <PageDown>          " page down
noremap <leader><Space> <PageUp>    " page up

" Mapping to move between windows
nmap <silent> <leader>k :wincmd k<CR>
nmap <silent> <leader>j :wincmd j<CR>
nmap <silent> <leader>h :wincmd h<CR>
nmap <silent> <leader>l :wincmd l<CR>

" resize current buffer by +/- 5
nnoremap <leader>1 :resize +5<cr>
nnoremap <leader>2 :resize -5<cr>
nnoremap <leader>- :vertical resize +5<cr>
nnoremap <leader>= :vertical resize -5<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language specific settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap E w:<CR>:!python % <CR> " Execute Python file being edited with <Shift> + e:

" TODO: lookup a way to cleanup the autocmd in the following
" Because I need spell check
autocmd FileType python :setlocal spell spelllang=en_us
autocmd FileType python hi SpellBad term=reverse ctermfg=white ctermbg=darkred guifg=#ffffff guibg=#7f0000 gui=underline
autocmd FileType python hi SpellCap guifg=#ffffff guibg=#7f007f
autocmd FileType python hi SpellRare guifg=#ffffff guibg=#00007f gui=underline
autocmd FileType python hi SpellLocal term=reverse ctermfg=black ctermbg=darkgreen guifg=#ffffff guibg=#7f0000 gui=underline

" Search and error color highlights
autocmd FileType python hi Search guifg=#ffffff guibg=#0000ff gui=none ctermfg=white ctermbg=darkblue
autocmd FileType python hi IncSearch guifg=#ffffff guibg=#8888ff gui=none ctermfg=white
autocmd FileType python highlight SpellBad guifg=#ffffff guibg=#8888ff gui=none ctermfg=black ctermbg=darkred


au BufEnter,Bufread *.mkd,*.md,*.mdown,*.markdown set tw=0 " markdown

" python formatting help
"autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" Enable omni completion.
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown,ctp set omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php,ctp set omnifunc=phpcomplete#CompletePHP
autocmd FileType vim set omnifunc=syntaxcomplete#Complete

" http://www.brankovukelic.com/post/2091037293/turn-vim-into-powerful-javascript-editor"
" HTML (tab width 2 chr, no wrapping)
autocmd FileType html set sw=2
autocmd FileType html set ts=2
autocmd FileType html set sts=2
autocmd FileType html set textwidth=0

" XHTML (tab width 2 chr, no wrapping)
autocmd FileType xhtml set sw=2
autocmd FileType xhtml set ts=2
autocmd FileType xhtml set sts=2
autocmd FileType xhtml set textwidth=0

" CSS (tab width 2 chr, wrap at 79th char)
autocmd FileType css set sw=2
autocmd FileType css set ts=2
autocmd FileType css set sts=2

autocmd Syntax c,cpp,vim,xml,html,xhtml,js,php,py,python set foldmethod=manual
autocmd Syntax c,cpp,vim,xml,html,xhtml,perl normal zR

"remove trailing whitespace
"http://vim.wikia.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
autocmd BufWritePre *.c :%s/\s\+$//e
autocmd BufWritePre *.cpp :%s/\s\+$//e
autocmd BufWritePre *.c++ :%s/\s\+$//e
autocmd BufWritePre *.h :%s/\s\+$//e
autocmd BufWritePre *.java :%s/\s\+$//e
"autocmd BufWritePre *.php :%s/\s\+$//e
autocmd BufWritePre *.pl :%s/\s\+$//e
autocmd BufWritePre *.py :%s/\s\+$//e
"au BufEnter,BufRead *.php,*.ctp set noexpandtab " tabs, not spaces for php, ctp

" Autoclose quickfix windows when quit
" http://stackoverflow.com/questions/7476126/how-to-automatically-close-the-quick-fix-window-when-leaving-a-file
aug QFClose
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END
