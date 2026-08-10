-- plugins
vim.pack.add({
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

-- disable netrw before nvim-tree loads
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- options
require("nvim-tree").setup({
	filters = {
		dotfiles = false,
	},
	view = {
		adaptive_size = true,
	},
})

-- keymaps
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { silent = true, desc = "Toggle NvimTree" })
vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeFindFileToggle<cr>", { silent = true, desc = "Find file in NvimTree" })
