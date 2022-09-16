let mapleader = " "

" set nocompatible            " disable compatibility to old-time vi
" set showmatch               " show matching
" set ignorecase              " case insensitive
" set mouse=v                 " middle-click paste with
" set hlsearch                " highlight search
" set incsearch               " incremental search
" set tabstop=4               " number of columns occupied by a tab
" set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
" set expandtab               " converts tabs to white space
" set shiftwidth=4            " width for autoindents
" set autoindent              " indent a new line the same amount as the line just typed
" set number                  " add line numbers
" set wildmode=longest,list   " get bash-like tab completions
" set cc=80                   " set an 80 column border for good coding style
filetype plugin indent on   " allow auto-indenting depending on file type
" syntax on                   " syntax highlighting
" set mouse=a                 " enable mouse click
set clipboard+=unnamedplus  " using system clipboard
" filetype plugin on
" set cursorline              " highlight current cursorline
" set ttyfast                 " Speed up scrolling in Vim
" " set spell                 " enable spell check (may need to download language package)
set noswapfile            " disable creating swap file
" " set backupdir=~/.cache/vim " Directory to store backup files.

" " set spell
set termguicolors

" set signcolumn=auto:2
set signcolumn=yes

"" General tab settings
" set tabstop=4       " number of visual spaces per TAB
" set softtabstop=4   " number of spaces in tab when editing
" set shiftwidth=4    " number of spaces to use for autoindent
" set expandtab       " expand tab to spaces so that tabs are spaces

" Set matching pairs of characters and highlight matching brackets
set matchpairs+=<:>,「:」,『:』,【:】,“:”,‘:’,《:》

set number relativenumber  " Show line number and relative line number

" Time in milliseconds to wait for a mapped sequence to complete,
" see https://unix.stackexchange.com/q/36882/221410 for more info
set timeoutlen=500

set updatetime=500  " For CursorHold events

tnoremap <C-j> <C-\><C-n>

let test#strategy = "dispatch"

set spelllang=en
set spellsuggest=best,9

let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

hi SpellBad   guisp=red    gui=undercurl term=underline cterm=undercurl
hi SpellCap   guisp=yellow gui=undercurl term=underline cterm=undercurl
hi SpellRare  guisp=blue   gui=undercurl term=underline cterm=undercurl
hi SpellLocal guisp=orange gui=undercurl term=underline cterm=undercurl
