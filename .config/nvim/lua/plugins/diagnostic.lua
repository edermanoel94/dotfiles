return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	priority = 1000,
	config = function()
		require("tiny-inline-diagnostic").setup({
			transparent_bg = true,
			transparent_cursorline = true,

			options = {
				multilines = {
					enabled = true,
					always_show = true,
				},
			},
		})

    vim.diagnostic.config({ virtual_text = false })
	end,
}
