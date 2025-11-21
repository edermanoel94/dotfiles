return {
  "folke/trouble.nvim",
  opts = {},
  cmd = "Trouble",
  keys = {
    {
      "<leader>T",
      "<cmd>Trouble diagnostics toggle<CR>",
      desc = "Diagnostics",
    },
    {
      "<leader>bd",
      "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>gr",
      "<cmd>Trouble lsp toggle focus=false filter.buf=0<CR>",
      desc = "References",
    },
  }
}
