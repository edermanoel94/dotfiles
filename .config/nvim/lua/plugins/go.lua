-- build hooks (guihua compiles a native fzy lib, go.nvim installs its binaries).
-- must be registered before `vim.pack.add`, which fires PackChanged synchronously
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("GoPackChanged", { clear = true }),
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if kind ~= "install" and kind ~= "update" then
			return
		end

		if name == "guihua.lua" then
			-- the fzy ffi lib lives in lua/fzy; the repo-root Makefile only has a
			-- `tests` target, so running make there builds nothing
			vim.system({ "make" }, { cwd = ev.data.path .. "/lua/fzy" })
		elseif name == "go.nvim" then
			-- on a fresh install the plugin is on disk but not yet on 'runtimepath'
			pcall(vim.cmd.packadd, "go.nvim")
			require("go.install").update_all_sync()
		end
	end,
})

-- plugins
vim.pack.add({
	"https://github.com/ray-x/guihua.lua",
	"https://github.com/ray-x/go.nvim",
})

-- options: setup is deferred to the first Go buffer to keep startup fast
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("GoSetup", { clear = true }),
	pattern = { "go", "gomod", "gowork", "gotmpl" },
	once = true,
	callback = function()
		require("go").setup({
			gofmt = "gofumpt",
			tag_transform = "snakecase",
			tag_options = "",

			lsp_cfg = false, -- gopls is managed by mason-lspconfig in lsp.lua

			lsp_inlay_hints = {
				enable = false,
			},

			trouble = true,
		})
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("GoFormat", { clear = true }),
	pattern = "*.go",
	callback = function()
		require("go.format").goimports()
	end,
})

function _G.create_go_breakpoint()
	local file = vim.fn.expand("%")
	local line = vim.fn.line(".")
	if file == "" then
		vim.api.nvim_err_writeln("cannot find filename")
		return
	end
	if vim.fn.getline(".") == "" then
		vim.api.nvim_err_writeln("cannot get statement from this line")
		return
	end
	local text = ("b %s:%d"):format(file, line)
	vim.fn.setreg("+", text)
	vim.notify(text)
end
