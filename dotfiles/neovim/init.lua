vim.o.hlsearch = false
vim.wo.number = true
vim.o.hidden = true
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.opt.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'
vim.o.termguicolors = true

vim.o.background = 'light'
vim.g.gruvbox_contrast_light = 'hard'
vim.cmd [[colorscheme gruvbox]]

vim.api.nvim_set_keymap('', ',', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ','
vim.g.maplocalleader = ','
