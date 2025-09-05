vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.encoding="utf-8"
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.swapfile = false

vim.opt.termguicolors = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.compatible=false
vim.opt.hlsearch=true
vim.opt.laststatus = 2
vim.opt.vb = true
vim.opt.ruler = true
vim.opt.spelllang="en_us"
vim.opt.autoindent=true
vim.opt.colorcolumn="120"
vim.opt.textwidth=120
vim.opt.scrollbind=false
vim.opt.wildmenu=true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)


vim.opt.showcmd=true -- "show incomplete cmds down the bottom
vim.opt.showmode=true -- "show current mode down the bottom
vim.opt.incsearch=true -- "find the next match as we type the search
vim.opt.wrap=false -- "dont wrap lines
vim.opt.backup=false
vim.opt.swapfile=false
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.keymap.set('n', '<leader>a', '<cmd>cclose<CR>', { silent = true })

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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			"ellisonleao/gruvbox.nvim",
			priority = 1000,
			config = true,
			opts = {},
		},
		{
			"nvim-tree/nvim-tree.lua",
			config = function()
				vim.g.loaded_netrw = 1
				vim.g.loaded_netrwPlugin = 1

				require("nvim-tree").setup({})

				vim.keymap.set("n", "<leader>E", ":NvimTreeFindFileToggle<CR>")
				vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {
					noremap = true,
				})
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("lualine").setup({
					options = { theme = "gruvbox" },
				})
			end,
		},
		"NMAC427/guess-indent.nvim",
		{
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
        local gitsigns = require('gitsigns')

        vim.keymap.set('n', "<leader>gl", gitsigns.blame_line)
        vim.keymap.set('n', "<leader>gb", function()
          gitsigns.blame()
        end)
      end
		},
		{
			"nvim-telescope/telescope.nvim",
			event = "VimEnter",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{
					"nvim-telescope/telescope-fzf-native.nvim",
					build = "make",
					cond = function()
						return vim.fn.executable("make") == 1
					end,
				},
				{ "nvim-telescope/telescope-ui-select.nvim" },
				{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
			},
			config = function()
				require("telescope").setup({
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown(),
						},
					},
				})

				pcall(require("telescope").load_extension, "fzf")
				pcall(require("telescope").load_extension, "ui-select")

				-- See `:help telescope.builtin`
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "[S]earch [F]iles" })
				vim.keymap.set("n", "<C-f>", builtin.live_grep, { desc = "[S]earch by [G]rep" })
				vim.keymap.set("n", "<C-b>", builtin.buffers, { desc = "[ ] Find existing buffers" })

				-- It's also possible to pass additional configuration options.
				--  See `:help telescope.builtin.live_grep()` for information about particular keys
				vim.keymap.set("n", "<leader>s/", function()
					builtin.live_grep({
						grep_open_files = true,
						prompt_title = "Live Grep in Open Files",
					})
				end, { desc = "[S]earch [/] in Open Files" })
			end,
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				"mason-org/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				{ "j-hui/fidget.nvim", opts = {} },
				"saghen/blink.cmp",
			},
			config = function()
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
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
						map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
						map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
						map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
						map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
						map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
						map("gs", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
						map("gS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
						map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

						-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
						---@param client vim.lsp.Client
						---@param method vim.lsp.protocol.Method
						---@param bufnr? integer some lsp support methods only in specific files
						---@return boolean
						local function client_supports_method(client, method, bufnr)
							if vim.fn.has("nvim-0.11") == 1 then
								return client:supports_method(method, bufnr)
							else
								return client.supports_method(method, { bufnr = bufnr })
							end
						end

						local client = vim.lsp.get_client_by_id(event.data.client_id)
						if
							client
							and client_supports_method(
								client,
								vim.lsp.protocol.Methods.textDocument_documentHighlight,
								event.buf
							)
						then
							local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
							vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.document_highlight,
							})

							vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.clear_references,
							})

							vim.api.nvim_create_autocmd("LspDetach", {
								group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
								callback = function(event2)
									vim.lsp.buf.clear_references()
									vim.api.nvim_clear_autocmds({
										group = "kickstart-lsp-highlight",
										buffer = event2.buf,
									})
								end,
							})
						end
					end,
				})

				vim.diagnostic.config({
					severity_sort = true,
					float = { border = "rounded", source = "if_many" },
					underline = { severity = vim.diagnostic.severity.ERROR },
					signs = vim.g.have_nerd_font and {
						text = {
							[vim.diagnostic.severity.ERROR] = "󰅚 ",
							[vim.diagnostic.severity.WARN] = "󰀪 ",
							[vim.diagnostic.severity.INFO] = "󰋽 ",
							[vim.diagnostic.severity.HINT] = "󰌶 ",
						},
					} or {},
					virtual_text = {
						source = "if_many",
						spacing = 2,
						format = function(diagnostic)
							local diagnostic_message = {
								[vim.diagnostic.severity.ERROR] = diagnostic.message,
								[vim.diagnostic.severity.WARN] = diagnostic.message,
								[vim.diagnostic.severity.INFO] = diagnostic.message,
								[vim.diagnostic.severity.HINT] = diagnostic.message,
							}
							return diagnostic_message[diagnostic.severity]
						end,
					},
				})

				local capabilities = require("blink.cmp").get_lsp_capabilities()

				local servers = {
					gopls = {},
					lua_ls = {
						settings = {
							Lua = {
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					},
				}

				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, {
					"stylua", -- Used to format Lua code
				})
				require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
				require("mason-lspconfig").setup({
					ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
					automatic_installation = false,
					handlers = {
						function(server_name)
							local server = servers[server_name] or {}
							server.capabilities =
							vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
							require("lspconfig")[server_name].setup(server)
						end,
					},
				})
			end,
		},
		{ -- Highlight, edit, and navigate code
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			main = "nvim-treesitter.configs", -- Sets main module to use for opts
			opts = {
				ensure_installed = {
					"bash",
					"c",
					"go",
					"diff",
					"html",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"query",
					"vim",
					"vimdoc",
          "json",
				},
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "ruby" },
				},
				indent = { enable = true, disable = { "ruby" } },
			},
		},
		{
			"ray-x/go.nvim",
			dependencies = { -- optional packages
				"ray-x/guihua.lua",
				"neovim/nvim-lspconfig",
				"nvim-treesitter/nvim-treesitter",
			},
			opts = {
				-- lsp_keymaps = false,
				-- other options
			},
			config = function(lp, opts)
				require("go").setup(opts)
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
		},
		{
			'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async',
			config = function()

				-- vim.opt.foldcolumn = '0'
				vim.opt.foldlevel = 99
				vim.opt.foldlevelstart = 99
				vim.opt.foldenable = true

				local ufo = require('ufo')
				vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'Open all folds' })
				vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'Close all folds' })
				vim.keymap.set('n', 'zK', function() local winid = ufo.peekFoldedLinesUnderCursor()
					if not winid then
						vim.lsp.buf.hover()
					end
				end, { desc = "Peek Fold" })

        local ftMap = {
          vim = 'indent',
          go = {'indent'},
          git = ''
        }
        require('ufo').setup({
          provider_selector = function(bufnr, filetype)
            -- return a string type use internal providers
            -- return a string in a table like a string type
            -- return empty string '' will disable any providers
            -- return `nil` will use default value {'lsp', 'indent'}
            return ftMap[filetype] or {'treesitter', 'indent'}
          end
        })
      end
    },
    {
      'edermanoel94/vim-test',
      keys = {
        { 't<C-n>', function() vim.cmd("TestNearest") end, desc = "Test Nearest" },
        { 't<C-f>', function() vim.cmd("TestFile") end, desc = "Test File" },
        { 'd<C-n>', function() 
          vim.g["test#go#runner"] = 'delve'
          vim.cmd("TestNearest")
          vim.g["test#go#runner"] = nil
        end,
          desc = "Debug Nearest" 
        },
      },
      config = function()
        vim.g["test#strategy"] = 'neovim'
        vim.g["test#go#gotest#options"] = '-v'
        vim.g["test#neovim#start_normal"] = 1

        vim.g["test#neovim#term_position"] = 'botright 17'

        vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { silent = true })
        vim.keymap.set('t', '<C-c>', [[<C-\><C-n>]], { silent = true })
        vim.keymap.set('t', '<C-w>h', [[<C-\><C-n><C-w>h]], { silent = true })
        vim.keymap.set('t', '<C-w>j', [[<C-\><C-n><C-w>j]], { silent = true })
        vim.keymap.set('t', '<C-w>k', [[<C-\><C-n><C-w>k]], { silent = true })
        vim.keymap.set('t', '<C-w>l', [[<C-\><C-n><C-w>l]], { silent = true })
      end
    },
    {
      "kylechui/nvim-surround",
      version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup()
      end
    },
  },
	checker = { enabled = true }, })

require("gruvbox").setup({})

vim.cmd("colorscheme gruvbox")

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
		vim.opt.expandtab =false
		vim.opt.tabstop = 4
		vim.opt.shiftwidth = 4

		vim.keymap.set("n", "<leader>b", create_breakpoint, { buffer = true })

		vim.api.nvim_create_user_command("A",  function(opts) 
			vim.cmd("GoAlt")
		end , {})

		vim.keymap.set('n', '<leader>c',  '<cmd>GoCoverage<CR>', { silent = true })
		vim.keymap.set('n', '<leader>fs', '<cmd>GoFillStruct<CR>', { silent = true })
		vim.keymap.set('n', '<leader>ta', '<cmd>GoAddTag<CR>', { silent = true })
	end
})
