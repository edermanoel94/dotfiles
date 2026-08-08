-- pre install
vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Build blink.cmp after install/update",
	group = vim.api.nvim_create_augroup("blink_build", { clear = true }),
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "blink.cmp" and (kind == "install" or kind == "update") then
			-- on a fresh install the plugins are on disk but not yet on 'runtimepath',
			-- so they have to be packadd'ed before `require` can find them.
			-- blink.lib comes first: blink.cmp fails to load without it
			pcall(vim.cmd.packadd, "blink.lib")
			pcall(vim.cmd.packadd, "blink.cmp")
			vim.notify("Building blink.cmp...", vim.log.levels.INFO)
			-- `build()` runs `cargo build --release` and then installs the artifact
			-- into `$repo/lib/`, which is the only place blink looks for it
			require("blink.cmp").build():pwait()
		end
	end,
})

-- plugins
vim.pack.add({
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/Saghen/blink.lib",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/rafamadriz/friendly-snippets",
})

-- options
require("luasnip.loaders.from_vscode").lazy_load()

require("blink.cmp").setup({
	snippets = { preset = "luasnip" },
	keymap = {
		preset = "default",
		["<Tab>"] = { "accept", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<S-Tab>"] = { "show" },
		["<S-p>"] = { "select_prev", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
	},
	completion = {
		menu = {
			auto_show = true,
			draw = {
				treesitter = { "lsp" },
				columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
			},
		},
		documentation = { auto_show = true },
	},
	signature = { enabled = true },
	fuzzy = { implementation = "lua" },
	sources = {
		default = {
			"lsp",
			"path",
			"snippets",
			"buffer",
		},
		per_filetype = {
			sql = { "lsp", "snippets", "buffer" },
		},
		providers = {
			lsp = {
				score_offset = 90,
			},
		},
	},
})
