set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Bundle 'scrooloose/nerdtree'
Plugin 'flazz/vim-colorschemes'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/syntastic'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" if on windows use below: 
" set rtp+=$HOME/vimfiles/bundle/Vundle.vim/
" call vundle#begin('$USERPROFILE/vimfiles/bundle/')
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

map <C-n> :NERDTreeToggle<CR>

autocmd vimenter * NERDTree

syntax enable

set number

"colorscheme mizore
"colorcheme grishin
"colorscheme lilypink
colorscheme landscape

set tabstop=8 shiftwidth=4 expandtab

if has('gui_running')
    " gvim specific settings here
    set gfn=Lucida_Console:h9.5
    set gfw=Lucida_Console:h9.5
    set lsp=3
endif

" Syntastic Config Here
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set signcolumn=yes

" Language Options
let g:syntastic_python_checkers = ['prospector']

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_style_error_symbol = '😭'
let g:syntastic_style_warning_symbol = '😬'
let g:syntastic_error_symbol = '🔥'
let g:syntastic_warning_symbol = '⚠️'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn
