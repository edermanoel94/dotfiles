return {
	"kevinhwang91/nvim-ufo",
	dependencies = "kevinhwang91/promise-async",
	config = function()
		vim.opt.foldenable = true
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99

		local ufo = require("ufo")
		vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
		vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
		vim.keymap.set("n", "zK", function()
			local winid = ufo.peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover()
			end
		end, { desc = "Peek Fold" })

    -- lsp or else treesitter or else indent
    local function chainedSelector(bufnr)
      local function handleFallbackException(err, providerName)
        if type(err) == 'string' and err:match('UfoFallbackException') then
          return require('ufo').getFolds(bufnr, providerName)
        else
          return require('promise').reject(err)
        end
      end

      return require('ufo').getFolds(bufnr, 'lsp'):catch(function(err)
        return handleFallbackException(err, 'treesitter')
      end):catch(function(err)
        return handleFallbackException(err, 'indent')
      end)
    end

		require("ufo").setup({
      preview = {
        mappings = {
          scrollU = '<C-u>',
          scrollD = '<C-d>',
        },
      },
			provider_selector = function(bufnr, filetype, bufType)
        return chainedSelector
			end,
		})
	end,
}
