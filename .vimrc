set nocompatible              " be iMproved, required
filetype off                  " required

" vim-plug plugin config:
call plug#begin()

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
Plug 'fatih/vim-go'
Plug 'flazz/vim-colorschemes'
Plug 'mbbill/undotree'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'preservim/nerdtree'
Plug 'hashivim/vim-terraform'
Plug 'luochen1990/rainbow'
Plug 'preservim/nerdcommenter'
Plug 'python-mode/python-mode'
Plug 'talha-akram/noctis.nvim'

call plug#end()

filetype plugin on

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" set rtp+=/Users/robinyonge/code/git/codota/tabnine-vim

" rainbow parentheses
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf = {
\	'guifgs': ['lightmagenta', 'lightgreen', 'lightblue', 'lightred'],
\	'ctermfgs': ['lightmagenta', 'lightgreen', 'lightblue', 'lightred'],
\	'guis': [''],
\	'cterms': [''],
\ 'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'markdown': {
\			'parentheses_options': 'containedin=markdownCode contained',
\		},
\		'lisp': {
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\		},
\		'haskell': {
\			'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/\v\{\ze[^-]/ end=/}/ fold'],
\		},
\		'vim': {
\			'parentheses_options': 'containedin=vimFuncBody',
\		},
\		'perl': {
\			'syn_name_prefix': 'perlBlockFoldRainbow',
\		},
\		'stylus': {
\			'parentheses': ['start=/{/ end=/}/ fold contains=@colorableGroup'],
\		},
\		'css': 0,
\		'nerdtree': 0,
\	}
\}

let g:pymode_options_max_line_length=100

" nerdtree stuff
autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let NERDTreeShowHidden=1
let NERDTreeUseTCD=1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" nerdcommenter stuff
let mapleader = ","
let g:NERDTrimTrailingWhitespace = 1
let g:NERDSpaceDelims = 1
let g:NERDCreateDefaultMappings = 1
map [count]<leader>cc :NERDCommenterToggle

" ale options
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_column_always = 1

" hashivim options
let g:terraform_fmt_on_save=1

" keybindings
map <C-n> :NERDTreeToggle<CR>
nmap <F1> :Clap filer<CR>
nmap <F2> :Clap files<CR>
nmap <F3> :Clap grep<CR>
nmap <F4> :Clap buffers<CR>
nmap <F6> :set cmdheight=2<CR>
noremap <PageUp> :tabprevious<CR>
noremap <PageDown> :tabnext<CR>
"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
command TCD tcd %:p:h
let g:clap_open_action = { 'ctrl-t': 'tab split', 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }

syntax enable
au BufNewFile,BufRead Jenkinsfile setf groovy

" themeing:
set termguicolors
colorscheme fairyfloss
" colorscheme noctis_lilac
highlight Comment cterm=italic gui=italic
highlight Function cterm=italic gui=italic
highlight Keyword cterm=italic gui=italic
highlight Type cterm=italic gui=italic
highlight Class cterm=italic gui=italic
" "colorscheme soft-era
" colorscheme strawberry-light
let g:robin_airline = 1
let g:airline_theme = 'fairyfloss'
let g:clap_theme = { 'clap_display': {'guibg': '59', 'ctermbg': '#49483e'} }

" uncomment these lines to switch between colorschemes depending on mode if
" that's your thing
" au InsertLeave * colorscheme darkblue
" au InsertEnter * colorscheme molokai
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

set number

" gui settings
set guifont=Dank\ Mono:h16

" set indentation widths
set tabstop=2 shiftwidth=2 expandtab softtabstop=2

" start a new line and autoindent where lines are too long
" set autoindent
" set textwidth=100
set nowrap

" fix error where vim cannot backspace
set bs=2

" set current window/buffer working dir to dir of file?
autocmd TabNew,TabNewEntered * :tcd %:p:h

" working on my own nvim plugin in go
if exists('g:loaded_tweet')
    finish
endif
let g:loaded_tweet = 1

function! s:Requiretweet(host) abort
    " 'tweet' is the binary created by compiling the program above.
    return jobstart(['tweet'], {'rpc': v:true})
endfunction

call remote#host#Register('tweet', 'x', function('s:Requiretweet'))
" The following lines are generated by running the program
" command line flag --manifest tweet
call remote#host#RegisterPlugin('tweet', '0', [
    \ {'type': 'function', 'name': 'Tweet', 'sync': 1, 'opts': {}},
    \ ])


set shellcmdflag=-c

source ~/.vim/init.vim
