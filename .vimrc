set nocompatible              " be iMproved, required
filetype off                  " required
filetype plugin on

" vim-plug plugin config:
call plug#begin()

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'fatih/vim-go'
Plug 'flazz/vim-colorschemes'
Plug 'mbbill/undotree'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'liuchengxu/vim-clap'
Plug 'tpope/vim-vinegar'

if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

call plug#end()

" Add tabnine
set rtp+=~/tabnine-vim

" nerdtree stuff
" autocmd vimenter * NERDTree
" let NERDTreeShowHidden=1
" let NERDTreeMinimalUI = 1
" let NERDTreeDirArrows = 1

" ale options
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_column_always = 1

" keybindings
" map <C-n> :NERDTreeToggle<CR>
" nmap <F1> :NERDTreeToggle<CR>
" nmap <F2> :NERDComComment<CR>
noremap <PageUp> :tabprevious<CR>
noremap <PageDown> :tabnext<CR>
"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
command FCD lcd %:p:h

syntax enable

" themeing:
set termguicolors
colorscheme fairyfloss
highlight Comment cterm=italic gui=italic
highlight Function cterm=italic gui=italic
highlight Keyword cterm=italic gui=italic
highlight Type cterm=italic gui=italic
highlight Class cterm=italic gui=italic
" "colorscheme soft-era
" colorscheme strawberry-light
let g:robin_airline = 1
let g:airline_theme = 'fairyfloss'
" uncomment these lines to switch between colorschemes depending on mode if
" that's your thing
" au InsertLeave * colorscheme darkblue
" au InsertEnter * colorscheme molokai
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

set number

" gui settings
set guifont=Dank\ Mono:h14

" set indentation widths
set tabstop=2 shiftwidth=2 expandtab softtabstop=2

" start a new line and autoindent where lines are too long
" set autoindent
" set textwidth=100
set nowrap

" fix error where vim cannot backspace
set bs=2

" set Explore/netrw settings
" let g:netrw_liststyle = 1
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1
let g:netrw_winsize = 20
autocmd VimEnter * :Vexplore

" set current window/buffer working dir to dir of file?
autocmd TabNew,TabNewEntered * :tcd %:p:h
