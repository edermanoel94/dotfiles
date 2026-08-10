require("vim._core.ui2").enable({})
vim.g.mapleader = " "

vim.opt.encoding = "utf-8"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 250

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.compatible = false
vim.opt.hlsearch = true
vim.opt.laststatus = 3
vim.opt.autoindent = true

vim.o.breakindent = true -- prevent line wrapping
-- vim.opt.fillchars = { vert = " " } -- remove line divider between splits
vim.opt.fillchars = { eob = " " }

vim.opt.incsearch = true -- "find the next match as we type the search
vim.opt.wrap = false -- "dont wrap lines
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true

vim.o.completeopt = "menu,menuone,noselect,preview"
vim.o.winborder = "rounded"
vim.o.pumheight = 10
vim.o.showmode = false

vim.opt.path:append("**")
vim.opt.isfname:append("@-@")

vim.opt.clipboard:append("unnamedplus")
