return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  config = function()
    -- vim.opt.foldcolumn = '0'
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true

    local ufo = require('ufo')
    vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'Close all folds' })
    vim.keymap.set('n', 'zK', function()
      local winid = ufo.peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = "Peek Fold" })

    local ftMap = {
      vim = 'indent',
      go = { 'indent' },
      git = ''
    }
    require('ufo').setup({
      provider_selector = function(bufnr, filetype)
        -- return a string type use internal providers
        -- return a string in a table like a string type
        -- return empty string '' will disable any providers
        -- return `nil` will use default value {'lsp', 'indent'}
        return ftMap[filetype] or { 'treesitter', 'indent' }
      end
    })
  end
}
