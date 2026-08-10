local function list_buffers()
	local qf_items = {}

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
			local name = vim.api.nvim_buf_get_name(bufnr)
			-- Last known cursor position, so jumping lands where you left off
			local lnum = vim.api.nvim_buf_get_mark(bufnr, '"')[1]

			local text = name ~= "" and vim.fn.fnamemodify(name, ":~:.") or "[No Name]"

			if vim.bo[bufnr].modified then
				text = text .. " [+]"
			end

			table.insert(qf_items, {
				bufnr = bufnr,
				lnum = math.max(lnum, 1),
				col = 1,
				text = text,
			})
		end
	end

	vim.fn.setqflist({}, "r", {
		title = "Buffers",
		items = qf_items,
	})

	vim.cmd("copen")
end

vim.keymap.set("n", "<C-b>", list_buffers, { silent = true })
