-- rebuild parsers whenever vim.pack updates nvim-treesitter, so the parsers
-- always match the queries of the revision in use
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

-- plugins
vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

-- the main branch of nvim-treesitter has no `ensure_installed` option:
-- setup() silently ignores it, so parsers have to be installed explicitly.
-- install() is a no-op for languages already installed.
require("nvim-treesitter").install({
	"bash",
	"css",
	"diff",
	"go",
	"gomod",
	"gowork",
	"gosum",
	"graphql",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"json5",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"query",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})
