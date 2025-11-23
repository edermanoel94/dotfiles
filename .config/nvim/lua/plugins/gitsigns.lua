return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	},
	config = function()
		local gitsigns = require("gitsigns")

		vim.keymap.set("n", "<leader>gl", gitsigns.blame_line)
		vim.keymap.set("n", "<leader>gb", function()
			gitsigns.blame()
		end)
	end,
}
