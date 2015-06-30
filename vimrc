set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'scrooloose/syntastic'

Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

Plugin 'tpope/vim-surround'



call vundle#end()            " required
filetype plugin indent on    " required

"Syntatic settings
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers = ['perl']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


" Ultisnips
let g:UltiSnipsExpandTrigger="<leader>c"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"


"General
syntax on

set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set gdefault
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
"set hlsearch
"set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

"set number
"set spell
set ruler

"Autosave and Autoread
set autoread
set autowriteall
set noswapfile
set nobackup
au CursorHold,CursorHoldI * checktime
au CursorHold,CursorHoldI * silent! wa
set updatetime=2000
filetype plugin on
let g:tex_flavor='latex -interaction=nonstopmode'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_CompileRule_pdf = 'pdflatex -interaction nonstopmode $*'
let g:Tex_ViewRule_pdf = 'mupdf'


let Tex_FoldedSections=""
let Tex_FoldedEnvironments=""
let Tex_FoldedMisc=""

"Persisten-undo magic
set undofile

"Disable the super annoying autocomment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"Make j and k not jump when wraping
nnoremap j gj
nnoremap k gk

"set leader to comma
let mapleader = ","


"Math with qalc
nnoremap <leader>m :.!~/bin/calc<Enter>
nnoremap <leader>i :read !latestimage<Enter>
nnoremap <leader>v :!open '<cfile>'<CR>

"read spaces in path's
set isfname+=32

"Make tab into another escape
"nnoremap <Tab> <Esc>
"vnoremap <Tab> <Esc>gV
"onoremap <Tab> <Esc>
"inoremap <Tab> <Esc>`^
"inoremap <S-Tab> <Tab>
set enc=utf-8

"sync paste buffer and vims register
set clipboard^=unnamed

" don't clobber up the directory with dot undo file
set undodir=~/.vim/undodir//


"Open new file
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>w :w<CR>

