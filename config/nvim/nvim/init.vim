" Set basic functionality.
" set number
set number relativenumber
set mouse=a
set ignorecase
set lazyredraw

" Set formatting.
set bs=2
set tabstop=4
set autoindent
set noexpandtab
set shiftwidth=4

" Avoid swap file errors.
set nowritebackup
set nobackup
set noswapfile

" Use hidden mode.
set laststatus=0
set noruler
set noshowcmd

" Set file formatting.
set encoding=utf-8

" Use the system clipboard.
set clipboard+=unnamedplus

" Neovide uses effects
let g:neovide_refresh_rate=144

" Show syntax and font.
syntax enable

" Use a cool font for gui clients.
set guifont=Fira\ Code\ Bold:h14:cANSI:qDRAFT

