-- plugins
vim.pack.add({
	"https://github.com/vim-test/vim-test",
})

-- options
vim.g["test#strategy"] = "neovim"
vim.g["test#go#gotest#options"] = "-v"
vim.g["test#neovim#start_normal"] = 1

vim.g["test#neovim#term_position"] = "botright 17"

-- keymaps
vim.keymap.set("n", "t<C-n>", function()
	vim.cmd("TestNearest")
end, { desc = "Test Nearest" })

vim.keymap.set("n", "t<C-f>", function()
	vim.cmd("TestFile")
end, { desc = "Test File" })

vim.keymap.set("n", "d<C-n>", function()
	vim.g["test#go#runner"] = "delve"
	vim.cmd("TestNearest")
	vim.g["test#go#runner"] = nil
end, { desc = "Debug Nearest" })
