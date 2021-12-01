set encoding=utf-8
scriptencoding utf-8

function! s:MakeDir(dir)
  if !isdirectory(expand(a:dir))
    call mkdir(expand(a:dir), 'p')
  endif
endfunction

function! s:VimPath(filename)
  return '~/.config/nvim/' . a:filename
endfunction

function! s:InstallVimPlug()
  let vimplug_path=expand(s:VimPath('autoload/plug.vim'))
  if !filereadable(vimplug_path)
    silent !clear
    execute "!curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  endif
endfunction

function! s:SourceVimFile(vimfile)
  let path_name=expand(s:VimPath(a:vimfile))
  if filereadable(path_name)
    execute 'source ' . fnameescape(path_name)
  endif
endfunction

set shell=zsh
exec s:InstallVimPlug()
exec s:SourceVimFile('bundles.vim')

let mapleader=' '

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

" airline
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

" markdown
let g:vim_markdown_folding_disabled=1
let g:markdown_fenced_languages=['javascript', 'js=javascript', 'json=javascript']

" maximizer
nnoremap <leader>m :MaximizerToggle!<cr>

" neoterm
let g:neoterm_default_mod='horizontal'
let g:neoterm_size=60
let g:neoterm_autoinsert=1
inoremap <c-q> <ESC>:Ttoggle<CR>
nnoremap <c-q> :Ttoggle<cr>
tnoremap <c-q> <c-\><c-n>:Ttoggle<cr>

" neoformat
nnoremap <leader>F :Neoformat prettier<cr>

" fzf
nnoremap <leader><space> :GFiles<cr>
nnoremap <leader>ff :Rg<cr>
inoremap <expr> <c-x><c-f> fzf#vim#complete#path(
  \ "find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'",
  \ fzf#wrap({'dir': expand('%:p:h')}))
if has('nvim')
  au! TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
  au! FileType fzf tunmap <buffer> <Esc>
endif

" fugitive
nnoremap <leader>gg :G<cr>

" lsp-config
lua require'lspconfig'.tsserver.setup{ on_attach=require'completion'.on_attach }
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <silent> gh <cmd>lua vim.lsp.buf.hover()<cr>
nnoremap <silent> gH <cmd>lua vim.lsp.buf.code_action()<cr>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<cr>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<cr>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent> gR <cmd>lua vim.lsp.buf.rename()<cr>

" vim-test
nnoremap <silent> tt :TestNearest<cr>
nnoremap <silent> tf :TestFile<cr>
nnoremap <silent> ts :TestSuite<cr>
nnoremap <silent> t_ :TestLast<cr>
let test#strategy='neovim'
let test#neovim#term_position='horizontal'

" vimspector
nnoremap <leader>da :call vimspector#Launch()<cr>
nnoremap <leader>dx :call vimspector#Reset()<cr>
nnoremap <S-k> :call vimspector#StepOut()<cr>
nnoremap <S-l> :call vimspector#StepInto()<cr>
nnoremap <S-j> :call vimspector#StepOver()<cr>
nnoremap <leader>d_ :call vimspector#Restart()<cr>
nnoremap <leader>dn :call vimspector#Continue()<cr>
nnoremap <leader>drc :call vimspector#RunToCursor()<cr>
nnoremap <leader>dh :call vimspector#ToggleBreakpoint()<cr>
nnoremap <leader>de :call vimspector#ToggleConditionalBreakpoint()<cr>
nnoremap <leader>dX :call vimspector#ClearBreakpoints()<cr>

" tmux-navigator
let g:tmux_navigator_no_mappings=1
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

