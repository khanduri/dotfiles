set nocompatible               " be iMproved
filetype off                   " required!

" https://github.com/spf13/spf13-vim/issues/90
set t_Co=256

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

""""""""""""""""""""""""""""""""""""""""""""""""
" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

""""""""""""""""""""""""""""""""""""""""""""""""
" Color scheme
Bundle 'cschlueter/vim-mustang'
Bundle 'godlygeek/csapprox'

Bundle 'wincent/Command-T'

Bundle 'fholgado/minibufexpl.vim'

Bundle 'majutsushi/tagbar'
Bundle 'vim-scripts/AutoTag'

Bundle 'scrooloose/nerdtree'

Bundle 'scrooloose/syntastic'

"Bundle 'msanders/snipmate.vim'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'

Bundle 'jpalardy/vim-slime'

""""""""""""""""""""""""""""""""""""""""""""""""
" Utils

" <leader>t for triggering the TODO list
Bundle 'vim-scripts/TaskList.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'sjl/gundo.vim'

Bundle 'ghewgill/vim-scmdiff'
Bundle 'tomtom/tcomment_vim'
Bundle 'uguu-org/vim-matrix-screensaver'

" <leader><leader>w -- front word
" <leader><leader>b -- back word
" <leader><leader>j -- front line
" <leader><leader>k -- back line
Bundle 'Lokaltog/vim-easymotion'

Bundle 'Lokaltog/powerline'
Bundle 'Lokaltog/powerline-fonts'
Bundle 'Lokaltog/vim-distinguished'

Bundle 'vim-scripts/sort-python-imports'
Bundle 'lrvick/Conque-Shell'

"Bundle 'flazz/vim-colorschemes'
" Bundle 'sjbach/lusty'
" Bundle 'mattn/gist-vim'
" Bundle 'klen/python-mode'

filetype plugin indent on     " required!

set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

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
set pastetoggle=<F3>           " Press F3 for toggle paste mode
set wildignore=*.swp,*.bak,*.pyc,*.class " Ignore some file
set autowrite 				   " auto read when a file is changed from outside
set cmdheight=1                " Explicitly set the height of the command line
set number                     " Display line numbers
set relativenumber             " Display line numbers
set numberwidth=1              " using only 1 col (and 1 space) while possible
set colorcolumn=80             " Mark 80th column

set cmdheight=1                " Explicitly set the height of the command line
set title                      " show title in console title bar
set wildmenu                   " Menu completion in command mode on <Tab>
set cursorline
set wildmode=list:longest,full " com-line completion <tab> (file,help,options)
set nowrap                     " no line wrapping;
set guioptions+=b              " add a horizontal scrollbar to the bottom
set enc=utf-8                  " UTF-8 as the default buffer encoding
set laststatus=2               " Always show status line, even for one window
set scrolloff=3                " Scroll when cursor is within 3 char of top/bot
set shiftround " Round indent to multiple of 'shiftwidth' for > and < commands
set showcmd " Show (par) commands (or selection size in Visual mode) on status
set t_RV=                      " Don't request terminal version str (for xterm)
set so=7                       "Set 7 lines to curors when moving vertical
set ruler                      "Always show current position
set hid                        "Change buffer - without saving
set hidden
set mouse=a
set backspace=eol,start,indent " Set backspace config
set whichwrap+=<,>,h,l
set nolazyredraw               "Don't redraw while executing macros
set magic                      "Set magic on, for regular expressions
set showmatch          "Show matching bracets when text indicator is over them
set tm=500
set noerrorbells visualbell t_vb= "No sound on errors
autocmd GUIEnter * set visualbell t_vb=

" To highlight what's under the cursor
autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

" keystrokes
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

nmap <leader>w :w<cr>      " quicksave

nmap <leader>v :vsplit<cr>      " Vertical split window
nmap <leader>s :split<cr>       " Horizontal split window

map <leader>ev :e! ~/.vimrc<cr>  " Fast editing of the .vimrc
map <leader>eb :e! ~/.bashrc<cr> " Fast editing of the .bashrc

map <F5> :wall!<CR>:!sbcl --load foo.cl<CR><CR>

" This can be done with *
"nmap <leader>s /<C-r><C-w><Enter> " Lookup the term under the cursor
nnoremap <leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>

" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vimrc
au! BufWritePost $MYVIMRC source $MYVIMRC

autocmd * :%s/\s\+$//e

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shell=/bin/bash
set guioptions-=T
let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }
set gfn=Liberation\ Mono\ 10
set encoding=utf8

syntax enable "Enable syntax hl
set background=light
"let g:solarized_termcolors=256
"colorscheme solarized
"colorscheme kolor
"colorscheme mustang
colorscheme distinguished

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
" nnoremap <leader>p  " +gP            " Paste in normal mode


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
nnoremap <leader>3 :vertical resize +5<cr>
nnoremap <leader>4 :vertical resize -5<cr>


nnoremap <leader>za :set foldmethod=indent<cr>
nnoremap <leader>zz :set foldlevel=99<cr>


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



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CommandT shortcuts
map <leader>f :CommandT<CR>
map <leader>ff :CommandT ~/projects/HearsayLabs/fanmgmt<CR>
map <leader>fh :CommandT ~/projects/HearsayLabs<CR>
map <leader>fd :CommandT ~/projects/djangoSamples<CR>
map <leader>fa :CommandT ~/projects/djangoSamples/effectiveDjangoTutorial<CR>
map <leader>fo :CommandT ~/projects/djangoSamples/oneLiner/oneLiner<CR>
map <leader>f. :CommandT ~/projects/dotfiles<CR>
map <leader>fp :CommandT ~/projects<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sort Python Imports
map <leader>i :PyFixImports<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MinibufferExp

" Taken from http://dotfiles.org/~joaoTrindade/.vimrc
" Show the miniBufExplorer from the start
"let g:miniBufExplorerMoreThanOne = 0

" Not using because I don't use the vertival window
" Use a vertical windows
"let g:miniBufExplVSplit = 5
"let g:miniBufExplSplitBelow=1 "Put the miniBufExplorer windows at the right
"let g:miniBufExplMaxSize = 15 "Maximum size of the mini buffer explorer window
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplMapWindowNavVim = 1

let g:miniBufExplTabWrap = 1        " show complete (no broken on two lines)
let g:miniBufExplModSelTarget = 1   " Set to 1 if using other explorer (TagList)
let g:miniBufExplUseSingleClick = 1 " single click on tabs rather than double

hi MBENormal guifg=LightBlue             " NOT CHANGED and NOT VISIBLE.
hi MBEChanged guifg=Red                  " HAVE CHANGED and NOT VISIBLE
hi MBEVisibleNormal term=bold cterm=bold gui=bold guifg=Green  " NOT CHANGED and VISIBLE
hi MBEVisibleChanged term=bold cterm=bold gui=bold guifg=Green " CHANGED and VISIBLE

let g:bufExplorerSortBy = "name"

nnoremap <leader>n :MBEbn<cr>
nnoremap <leader>p :MBEbp<cr>
nnoremap <leader>d :MBEClose<cr>

autocmd BufRead,BufNew :call UMiniBufExplorer

" Taken from http://dev.gentoo.org/~bass/configs/vimrc.html
" Adapt the status line according to the window
if has("autocmd")
  au FileType qf
      \ if &buftype == "quickfix" |
      \     setlocal statusline=%2*%-3.3n%0* |
      \     setlocal statusline+=\ \[Compiler\ Messages\] |
      \     setlocal statusline+=%=%2*\ %<%P |
      \ endif

  fun! FixMiniBufExplorerTitle()
    if "-MiniBufExplorer-" == bufname("%")
      setlocal statusline=%2*%-3.3n%0*
      setlocal statusline+=\[Buffers\]
      setlocal statusline+=%=%2*\ %<%P
    endif
  endfun

  au BufWinEnter *
      \ let oldwinnr=winnr() |
      \ windo call FixMiniBufExplorerTitle() |
      \ exec oldwinnr . " wincmd w"
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TagBar
let g:tagbar_usearrows=1
let g:tagbar_width=30
let g:tagbar_singleclick=1

" Use leader + l to open Tagbar in Right side
nnoremap <leader>; :TagbarToggle<CR>

" Need to run "ctags -R ."
set tags=tags;/
" For autoload tags Check out: http://andrewradev.com/2011/06/08/vim-and-ctags/

autocmd BufWritePost *
      \ if filereadable('tags') |
      \   call system('ctags -a '.expand('%')) |
      \ endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree

" Enable this for make NERDTree load every opening files
" autocmd VimEnter * NERDTree " Make Always Load NERDTree every opening files
" autocmd VimEnter * wincmd p " Automatically go to buffer every time open files
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

"map <leader>t :NERDTreeTabsToggle<CR>
nnoremap <leader>tree :NERDTreeToggle ~/projects<CR>
let g:NERDTreeShowBookmarks=1
let g:NERDTreeMouseMode=3
let g:NERDTreeWinSize=30


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
let g:syntastic_python_checkers=['pylint', 'pyflakes', 'pep8', 'flake8']
"let g:syntastic_javascript_checkers=['jslint']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Powerline
" https://powerline.readthedocs.org/en/latest/fontpatching.html#font-patching
"set guifont=Menlo\ Bold\ for\ Powerline
set guifont=Menlo\ Regular\ for\ Powerline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Easymotion
hi EasyMotionTarget ctermbg=none ctermfg=green
" let g:EasyMotion_leader_key = '<Leader>'


let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['python'] = 'python,django'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Slime
let g:slime_target = 'tmux'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Conque
nnoremap <leader>cb :ConqueTerm bash<cr>
nnoremap <leader>cs :ConqueTerm python<cr>


