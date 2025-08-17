-- =========================
-- Bootstrap lazy.nvim
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git","clone","--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git","--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- Options
-- =========================
local o = vim.opt

-- Neovim already 'nocompatible' and filetype plugins enabled by default
vim.cmd("syntax enable")

o.encoding = "utf-8"
o.autoread = true
o.hidden = true
o.errorbells = false
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.shiftround = true
o.expandtab = true
o.wrap = false
o.swapfile = false
o.cursorline = true
o.autoindent = true
o.copyindent = true
o.smartindent = true
o.number = true
o.relativenumber = true
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.colorcolumn = "120"
o.textwidth = 120
o.foldmethod = "manual"
o.re = 0
o.clipboard = "unnamedplus"  -- prefer system clipboard
o.completeopt:remove("preview")
o.updatetime = 100
o.wildignore:append {
  "__debug_bin",
  "*.o","*.a","*.so","*.pyc","*.swp",".git/","*.class","*/target/*","*.idea/*","venv/","node_modules/"
}
o.path:append("**")
o.scrolloff = 1
o.mouse = "a"
-- 'mousehide' is not in Neovim; ignored.
-- Viminfo -> shada in Neovim; keep large search history
o.shada:append("/10000")

vim.g.mapleader = " "

-- =========================
-- Keymaps
-- =========================
local map = vim.keymap.set
local opts_silent = { silent = true }
map("", "Q", "<Nop>") -- disable Ex mode

map("n", "<leader>Q", ":q<CR>", opts_silent)
map("n", "<leader>w", ":w<CR>", {})
map("n", "<leader>a", ":cclose<CR>", {})
map("n", "<leader>gb", ":!git blame % -L 10<CR>", {}) -- as in original
map("n", "<leader>lg", ":!lazygit<CR>", {})

map("n", "<C-l>", ":nohl<CR>:syntax sync fromstart<CR>", opts_silent)

-- delete without yanking
map({"n","x"}, "x", '"_x')
map({"n","x"}, "X", '"_x')

-- very-magic search by default
map("n", "/", "/\\v")
map("x", "/", "/\\v")

-- =========================
-- Plugins via lazy.nvim
-- =========================
require("lazy").setup({
  -- Core FZF
  { "junegunn/fzf", build = function() vim.fn["fzf#install"]() end },
  { "junegunn/fzf.vim" },

  -- Airline (you could switch to lualine, but keeping original)
  { "vim-airline/vim-airline" },
  { "vim-airline/vim-airline-themes" },

  { "AndrewRadev/splitjoin.vim" },
  { "doums/darcula" },
  { "tpope/vim-surround" },
  { "tpope/vim-fugitive" },
  { "preservim/nerdtree" },
  { "kien/rainbow_parentheses.vim" },
  { "pablopunk/persistent-undo.vim" },
  { "airblade/vim-gitgutter" },
  { "vim-test/vim-test" },

  -- Go
  { "fatih/vim-go", build = ":GoUpdateBinaries" },
})

-- =========================
-- Post-plugin settings / colors
-- =========================
vim.o.termguicolors = true
vim.cmd.colorscheme("darcula")

-- Rainbow Parentheses (replicate your autocommands)
vim.api.nvim_create_autocmd("VimEnter", { callback = function()
  vim.cmd("RainbowParenthesesToggle")
end})
vim.api.nvim_create_autocmd("Syntax", { callback = function()
  vim.cmd("RainbowParenthesesLoadRound")
  vim.cmd("RainbowParenthesesLoadSquare")
  vim.cmd("RainbowParenthesesLoadBraces")
end})

-- ColorColumn highlight (GUI)
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "lightgrey" })

-- =========================
-- Autocommands
-- =========================
-- ctags on C/C headers after write
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = {"*.c","*.h"},
  callback = function()
    vim.fn.execute([[silent! !ctags -R .]])
  end,
})

-- Go file-specific options
vim.api.nvim_create_autocmd({"BufNewFile","BufRead"}, {
  pattern = "*.go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end
})

-- gohtml template
vim.api.nvim_create_autocmd({"BufRead","BufNewFile"}, {
  pattern = "*.gohtml",
  callback = function() vim.bo.filetype = "gohtmltmpl" end
})

-- =========================
-- NERDTree mappings
-- =========================
map("n", "<leader>e", ":NERDTreeToggle<CR>", {})
map("n", "<leader>E", ":NERDTreeFind<CR>", {})

-- =========================
-- vim-test
-- =========================
vim.g["test#strategy"] = "vimterminal"
map("n", "t<C-n>", ":TestNearest<CR>", opts_silent)
map("n", "t<C-f>", ":TestFile<CR>", opts_silent)
vim.g["test#go#gotest#options"] = "-v"

local function DebugNearest()
  vim.g["test#go#runner"] = "delve"
  vim.cmd("TestNearest")
  vim.g["test#go#runner"] = nil
end

local function DebugFile()
  vim.g["test#go#runner"] = "delve"
  vim.cmd("TestFile")
  vim.g["test#go#runner"] = nil
end

map("n", "d<C-n>", DebugNearest, opts_silent)
map("n", "d<C-f>", DebugFile, opts_silent)

-- =========================
-- vim-go settings & mappings
-- =========================
vim.g.go_fmt_experimental = 1
vim.g.go_decls_includes = "func,type"
vim.g.go_decls_mode = "fzf"
vim.g.go_test_timeout = "30s"
vim.g.go_test_show_name = 1
vim.g.go_list_type = "quickfix"
vim.g.go_fmt_command = "gopls"
vim.g.go_textobj_include_function_doc = 0
vim.g.go_highlight_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_operators = 1
vim.g.go_highlight_extra_types = 1
vim.g.go_highlight_build_constraints = 1
vim.g.go_metalinter_enabled = { "govet", "revive", "golint", "errcheck" }
vim.g.go_metalinter_autosave = 1
vim.g.go_metalinter_autosave_enabled = { "golint" }
vim.g.go_addtags_transform = "camelcase"
vim.g.go_doc_popup_window = 1
vim.g.go_auto_type_info = 1

-- :A / :AV / :AS / :AT commands (alternate file)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.api.nvim_create_user_command("A",  function(opts) vim.fn["go#alternate#Switch"](opts.bang and 1 or 0, "edit") end, { bang=true })
    vim.api.nvim_create_user_command("AV", function(opts) vim.fn["go#alternate#Switch"](opts.bang and 1 or 0, "vsplit") end, { bang=true })
    vim.api.nvim_create_user_command("AS", function(opts) vim.fn["go#alternate#Switch"](opts.bang and 1 or 0, "split") end, { bang=true })
    vim.api.nvim_create_user_command("AT", function(opts) vim.fn["go#alternate#Switch"](opts.bang and 1 or 0, "tabe") end, { bang=true })

    -- <Plug> mappings need remap=true
    local ro = { buffer = true, remap = true }
    map("n", "gr", "<Plug>(go-referrers)", ro)
    map("n", "gi", "<Plug>(go-implements)", ro)
    map("n", "gI", "<Plug>(go-if-err)", ro)
    map("n", "gs", "<Plug>(go-decls)", ro)
    map("n", "gS", "<Plug)(go-decls-dir)", ro) -- original had gS; keep as-is
    map("n", "<leader>c",  "<Plug>(go-coverage-toggle)", ro)
    map("n", "<leader>fs", "<Plug>(go-fill-struct)", ro)
    map("n", "<leader>ta", "<Plug>(go-add-tags)", ro)
    map("n", "<leader>rn", "<Plug>(go-rename)", ro)
  end
})

-- Custom helpers (Lua versions)
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

local function open_github_repo_code()
  local cur_proj = vim.fn.trim(vim.fn.fnamemodify(vim.fn.system("pwd"), ":t"))
  local file = ("%s#L%d"):format(vim.fn.expand("%"), vim.fn.line("."))
  local branch = vim.fn.trim(vim.fn.system("git rev-parse --abbrev-ref HEAD"))
  local link = ("https://github.com/pismo/%s/tree/%s/%s"):format(cur_proj, branch, file)
  vim.fn.setreg("+", link)
  vim.fn.system("open " .. link)
  vim.notify(link)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    map("n", "<leader>b", create_breakpoint, { buffer = true })
  end
})
map("n", "<leader>f", open_github_repo_code, {})

-- =========================
-- FZF mappings
-- =========================
map("n", "<C-p>", ":Files!<CR>", {})
map("n", "<C-b>", ":Buffers<CR>", {})

-- =========================
-- jq helpers (only if jq exists)
-- =========================
if vim.fn.executable("jq") == 1 then
  map("n", "<leader>jq", ":%!jq .<CR>", {})
  map("n", "<leader>ji", ":%!jq -rc .<CR>", {})
end

-- =========================
-- Trailing whitespace highlighter & fixer
-- =========================
-- Keep your logic, now in Lua-driven autocmds
vim.g.loaded_trailing_whitespace_plugin = 1
vim.g.extra_whitespace_ignored_filetypes = vim.g.extra_whitespace_ignored_filetypes or {}

vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "darkred" })
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "darkred" })
  end
})

local function should_match_whitespace()
  local ft = vim.bo.filetype
  for _, v in ipairs(vim.g.extra_whitespace_ignored_filetypes) do
    if v == ft then return false end
  end
  return true
end

local function match_trailing_ws()
  if should_match_whitespace() then
    vim.cmd([[match ExtraWhitespace /\\\@<![\u3000[:space:]]\+$/]])
  else
    vim.cmd([[match ExtraWhitespace /^^/]])
  end
end

vim.api.nvim_create_autocmd({"BufRead","BufNew"}, { callback = match_trailing_ws })
vim.api.nvim_create_autocmd("InsertLeave", { callback = match_trailing_ws })
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    if should_match_whitespace() then
      vim.cmd([[match ExtraWhitespace /\\\@<![\u3000[:space:]]\+\%#\@<!$/]])
    end
  end
})

vim.api.nvim_create_user_command("FixWhitespace", function(opts)
  local line1 = opts.line1
  local line2 = opts.line2
  vim.cmd(("silent! keepjumps %d,%ds/\\%%@<!\\s\\+$//"):format(line1, line2))
end, { range = "%" })
