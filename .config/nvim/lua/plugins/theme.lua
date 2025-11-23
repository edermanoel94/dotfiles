return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = true,
		opts = {},
	},
	{
		"xiantang/darcula-dark.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"sainnhe/everforest",
	},
	{
		"pmouraguedes/neodarcula.nvim",
		lazy = false,
		priority = 1000,
	},
}
