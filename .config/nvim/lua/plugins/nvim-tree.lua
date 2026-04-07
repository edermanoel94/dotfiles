return {
	"nvim-tree/nvim-tree.lua",
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      filters = {
        dotfiles = false,
      },
      view = {
        adaptive_size = true,
      },
    })

		vim.keymap.set("n", "<leader>E", ":NvimTreeFindFileToggle<CR>")
		vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {
			noremap = true,
		})
	end,
}
