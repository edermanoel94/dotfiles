return {
	"MattesGroeger/vim-bookmarks",
	init = function()
		vim.g.bookmark_no_default_key_mappings = 1
	end,
	keys = {
		{ "<Leader>mm", "<cmd>BookmarkToggle<cr>", desc = "Bookmark Toggle" },
		{ "<Leader>mt", "<cmd>BookmarkAnnotate<cr>", desc = "Bookmark Annotate" },
		{ "<Leader>ma", "<cmd>BookmarkShowAll<cr>", desc = "Bookmark Show All" },
	},
}

