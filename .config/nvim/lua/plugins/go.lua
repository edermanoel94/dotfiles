return {
	"ray-x/go.nvim",
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("go").setup({
			gofmt = "gofumpt",
			tag_transform = "snakecase",
			tag_options = "",

			lsp_cfg = false,       -- gopls is managed by mason-lspconfig in lsp.lua
			lsp_gofumpt = false,   -- formatting handled by conform.nvim

			lsp_inlay_hints = {
				enable = false,
			},

			trouble = true,
		})

		local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",
			callback = function()
				require("go.format").goimports()
			end,
			group = format_sync_grp,
		})
	end,
	event = { "CmdlineEnter" },
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
