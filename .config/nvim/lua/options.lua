vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.encoding = "utf-8"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.compatible = false
vim.opt.hlsearch = true
vim.opt.laststatus = 2
vim.opt.vb = true
vim.opt.ruler = true
vim.opt.spelllang = "en_us"
vim.opt.autoindent = true
vim.opt.colorcolumn = "120"
vim.opt.textwidth = 120
vim.opt.scrollbind = false
vim.opt.wildmenu = true
vim.opt.showcmd = true -- "show incomplete cmds down the bottom
vim.opt.showmode = true -- "show current mode down the bottom
vim.opt.incsearch = true -- "find the next match as we type the search
vim.opt.wrap = false -- "dont wrap lines
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.path:append("**")

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>Q", "<cmd>q<CR>", { silent = true })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { silent = true })
vim.keymap.set("n", "<leader>a", "<cmd>cclose<CR>", { silent = true })
vim.keymap.set("n", "<leader>o", "<cmd>copen<CR>", { silent = true })
