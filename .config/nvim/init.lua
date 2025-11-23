-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("options")

require("lazy").setup({
	{ import = "plugins" },
})

vim.cmd.colorscheme("gruvbox")

local function create_breakpoint()
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

vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		vim.opt.expandtab = false
		vim.opt.tabstop = 4
		vim.opt.shiftwidth = 4

		vim.keymap.set("n", "<leader>b", create_breakpoint, { buffer = true })

		vim.api.nvim_create_user_command("A", function(opts)
			vim.cmd("GoAlt")
		end, {})

		vim.keymap.set("n", "<leader>fs", "<cmd>GoFillStruct<CR>", { silent = true })
		vim.keymap.set("n", "<leader>ta", "<cmd>GoAddTag<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>c", "<cmd>GoCoverage -t<CR>", { silent = true, desc = "Toggle Go coverage" })
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(event)
		-- NOTE: Remember that Lua is a real programming language, and as such it is possible
		-- to define small helper and utility functions so you don't have to repeat yourself.
		--
		-- In this case, we create a function that lets us more easily define mappings specific
		-- for LSP related items. It sets the mode, buffer and description for us each time.
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("g.", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
		map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
		map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		map("gs", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
		map("gS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
		map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
	end,
})
