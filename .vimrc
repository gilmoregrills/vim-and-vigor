set nocompatible              " be iMproved, required
filetype off                  " required

" vim-plug plugin config:
call plug#begin()

Plug 'flazz/vim-colorschemes'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'spf13/vim-autoclose'
Plug 'mbbill/undotree'
Plug 'w0rp/ale'
Plug 'ncm2/ncm2'
Plug 'fatih/vim-go'

call plug#end()

map <C-n> :NERDTreeToggle<CR>
autocmd vimenter * NERDTree

syntax enable

" themeing:
" abstract is a good base theme at least, worth looking at editing it to be softer
" set t_Co=256
" set background=dark
set termguicolors
colorscheme fairyfloss
let g:robin_airline = 1
let g:airline_theme = 'fairyfloss'
" uncomment these lines to switch between colorschemes depending on mode
" au InsertLeave * colorscheme darkblue
" au InsertEnter * colorscheme molokai


set number


" gui settings
set guifont=Dank\ Mono:h14

" set indentation widths
set tabstop=4 shiftwidth=4 expandtab softtabstop=4

" start a new line and autoindent where lines are too long
set autoindent
set textwidth=100

" fix error where vim cannot backspace
set bs=2

