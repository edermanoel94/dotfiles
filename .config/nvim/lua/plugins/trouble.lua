return {
	"folke/trouble.nvim",
	opts = {},
	cmd = "Trouble",
	keys = {
		{
			"<leader>fd",
			"<cmd>Trouble diagnostics toggle focus=false<CR>",
			desc = "Diagnostics",
		},
		{
			"<leader>bd",
			"<cmd>Trouble diagnostics toggle focus=false filter.buf=0<CR>",
			desc = "Buffer Diagnostics",
		},
		{
			"<leader>br",
			"<cmd>Trouble lsp toggle focus=false filter.buf=0<CR>",
			desc = "Buffer References",
		},
		{
			"<leader>gr",
			"<cmd>Trouble lsp toggle focus=false filter.buf=0<CR>",
			desc = "References",
		},
	},
}
