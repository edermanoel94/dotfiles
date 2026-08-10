-- plugins
vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
})

-- options
local lualine = require("lualine")
lualine.setup({
	options = {
		theme = "gruvbox",
	},
})
