set encoding=utf-8
scriptencoding utf-8

function! s:MakeDir(dir)
	if !isdirectory(expand(a:dir))
		call mkdir(expand(a:dir), 'p')
	endif
endfunction

function! s:VimPath(filename)
	return '~/.vim/' . a:filename
endfunction

function! s:InstallVimPlug()
	let vim_plug_path = expand(s:VimPath('autoload/plug.vim'))
	if !filereadable(vim_plug_path)
		silent !clear
		execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	endif
endfunction

function! s:SourceVimFile(vimfile)
	let path_name = expand(s:VimPath(a:vimfile))
	if filereadable(path_name)
		execute 'source ' . fnameescape(path_name)
	endif
endfunction

if &shell =~# 'fish$'
	set shell=sh
endif

exec s:InstallVimPlug()

let mapleader=','
exec s:SourceVimFile('bundles.vim')

filetype plugin indent on
syntax on
set background=light
let g:gruvbox_contrast_light='hard'
colorscheme gruvbox

set autoindent
set autoread
set backspace=indent,eol,start
set backupcopy=yes
set backupdir=~/.local/share/vim/backup//
set colorcolumn=80,100
set completeopt=menu
set cursorline
set directory=~/.local/share/vim/swap//
set expandtab
set gdefault
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set modelines=0
set noautowrite
set nocursorline
set relativenumber
set ruler
set scrolloff=3
set shiftwidth=2
set showbreak="↪ "
set showcmd
set showmatch
set showmode
set showtabline=2
set smartcase
set softtabstop=2
set tabstop=2
set termguicolors
set undodir=~/.local/share/vim/undo//
set undofile
set visualbell
set wildmenu
set wildmode=list:longest

exec s:MakeDir(&backupdir)
exec s:MakeDir(&directory)
exec s:MakeDir(&undodir)

augroup trailing
	au!
	au InsertEnter * :set listchars-=trail:˽
	au InsertLeave * :set listchars+=trail:˽
augroup END

if executable('rg')
	set grepprg=rg\ --color=never
endif

let g:airline_mode_map={
	\ '__' : '-',
	\ 'c'  : 'C',
	\ 'i'  : 'I',
	\ 'ic' : 'I',
	\ 'ix' : 'I',
	\ 'n'  : 'N',
	\ 'ni' : 'N',
	\ 'no' : 'N',
	\ 'multi' : 'M',
	\ 'R'  : 'R',
	\ 'Rv' : 'R',
	\ 's'  : 'S',
	\ 'S'  : 'S',
	\ '^S' : 'S',
	\ 't'  : 'T',
	\ 'v'  : 'V',
	\ 'V'  : 'V',
	\ '^V' : 'V',
\ }
let g:airline#extensions#tabline#enabled=1
let g:ctrlp_dotfiles=1
let g:ctrlp_show_hidden=1
let g:vim_markdown_folding_disabled=1
let g:tmux_navigator_no_mappings=1
let g:ctrlp_custom_ignore='\.git$\|\.hg$\|\.svn$'
let g:ctrlp_user_command={
	\ 'types': {
		\ 1: ['.git', 'cd %s && git ls-files']
	\ },
	\ 'fallback': 'rg %s --files --color=never --glob ""'
\ }

nnoremap <leader>p :CtrlP<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>; :CtrlPMRU<cr>
nnoremap <silen> <c-b> :CtrlPBuffer<cr>
nnoremap <leader>d :NERDTreeToggle<cr>
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
