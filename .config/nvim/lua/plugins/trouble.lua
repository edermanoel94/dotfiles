-- plugins
vim.pack.add({
	"https://github.com/folke/trouble.nvim",
})

-- options
require("trouble").setup()

-- keymaps
vim.keymap.set("n", "<leader>fd", "<cmd>Trouble diagnostics toggle<cr>", { silent = true })
