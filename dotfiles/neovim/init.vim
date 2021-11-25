set encoding=utf-8
scriptencoding utf-8

function! s:MakeDir(dir)
  if !isdirectory(expand(a:dir))
    call mkdir(expand(a:dir), 'p')
  endif
endfunction

set shell=zsh

let mapleader=','

filetype plugin indent on
if (has("termguicolors"))
  set termguicolors
endif
syntax on
set background=light
let g:gruvbox_contrast_light='hard'
colorscheme gruvbox

set autoindent
set autoread
set backspace=indent,eol,start
set backupcopy=yes
set backupdir=~/.local/share/nvim/backup//
set cmdheight=1
set colorcolumn=80,100
set completeopt=menuone,noinsert,noselect
set cursorline
set diffopt+=vertical
set directory=~/.local/share/nvim/swap//
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
set mouse=a
set noautowrite
set nocursorline
set number
set ruler
set scrolloff=3
set shiftwidth=2
set shortmess+=c
set showbreak="↪ "
set showcmd
set showmatch
set showmode
set showtabline=2
set signcolumn=yes
set smartcase
set softtabstop=2
set splitright
set splitbelow
set tabstop=2
set undodir=~/.local/share/nvim/undo//
set undofile
set updatetime=750
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

let g:netrw_banner=0
let g:markdown_fenced_languages=['javascript', 'js=javascript', 'json=javascript']

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
let g:neoterm_default_mod='vertical'
let g:neoterm_size=60
let g:neoterm_autoinsert=1

inoremap <c-q> <ESC>:Ttoggle<CR>
nnoremap <leader>m :MaximizerToggle!<cr>
nnoremap <c-q> :Ttoggle<cr>
nnoremap <leader>F :Neoformat prettier<cr>
nnoremap <leader>p :CtrlP<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>; :CtrlPMRU<cr>
nnoremap <silen> <c-b> :CtrlPBuffer<cr>
nnoremap <leader>d :NERDTreeToggle<cr>
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
tnoremap <c-q> <c-\><c-n>:Ttoggle<cr>

