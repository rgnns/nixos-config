call plug#begin()

Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'direnv/direnv.vim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'janko/vim-test'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kassio/neoterm'
Plug 'kien/rainbow_parentheses.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'puremourning/vimspector'
Plug 'rktjmp/lush.nvim'
Plug 'sbdchd/neoformat'
Plug 'szw/vim-maximizer'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'chr4/nginx.vim'
Plug 'bazelbuild/vim-bazel',       { 'for': 'bzl' }
Plug 'hail2u/vim-css3-syntax',     { 'for': 'css' }
Plug 'gko/vim-coloresque',         { 'for': ['css', 'scss', 'sass', 'stylus'] }
Plug 'dart-lang/dart-vim-plugin',  { 'for': 'dart' }
Plug 'elixir-editors/vim-elixir',  { 'for': ['ex', 'exs'] }
Plug 'dag/vim-fish',               { 'for': 'fish' }
Plug 'jparise/vim-graphql',        { 'for': 'graphql' }
Plug 'pangloss/vim-javascript',    { 'for': 'javascript' }
Plug 'heavenshell/vim-jsdoc',      { 'for': ['javascript', 'typescript'] }
Plug 'maxmellon/vim-jsx-pretty',   { 'for': ['javascript', 'typescript'] }
Plug 'elzr/vim-json',              { 'for': 'json' }
Plug 'plasticboy/vim-markdown',    { 'for': 'markdown' }
Plug 'LnL7/vim-nix',               { 'for': 'nix' }
Plug 'vim-ruby/vim-ruby',          { 'for': 'ruby' }
Plug 'rust-lang/rust.vim',         { 'for': 'rust' }
Plug 'keith/swift.vim',            { 'for': 'swift' }
Plug 'lervag/vimtex',              { 'for': 'tex' }
Plug 'cespare/vim-toml',           { 'for': 'toml' }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }

call plug#end()
