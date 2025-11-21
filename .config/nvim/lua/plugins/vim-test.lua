return {
  'vim-test/vim-test',
  keys = {
    { 't<C-n>', function() vim.cmd("TestNearest") end, desc = "Test Nearest" },
    { 't<C-f>', function() vim.cmd("TestFile") end,    desc = "Test File" },
    {
      'd<C-n>',
      function()
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
}
