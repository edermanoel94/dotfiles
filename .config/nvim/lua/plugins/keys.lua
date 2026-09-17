vim.pack.add({
	"https://github.com/folke/which-key.nvim",
})

local wk = require("which-key")

wk.setup({
	-- Your layout configuration (e.g., preset = "classic" or "helix")
	preset = "classic",
})
