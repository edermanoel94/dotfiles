-- plugins
vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/martindur/zdiff.nvim",
})

-- options
local gitsigns = require("gitsigns")

gitsigns.setup({})

require("zdiff").setup()

-- keymaps
vim.keymap.set("n", "<leader>gm", ":Gitsigns diffthis main<cr>", { silent = true, desc = "Diff against main" })

vim.keymap.set("n", "<leader>zd", function()
	require("zdiff").open()
end, { desc = "Zdiff (uncommitted)" })
vim.keymap.set("n", "<leader>zD", function()
	require("zdiff").open("main")
end, { desc = "Zdiff (vs main)" })

vim.keymap.set("n", "<leader>gl", gitsigns.blame_line, { silent = true })
vim.keymap.set("n", "<leader>gb", gitsigns.blame, { silent = true })
