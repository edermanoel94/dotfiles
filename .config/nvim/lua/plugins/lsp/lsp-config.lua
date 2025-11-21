return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
    "j-hui/fidget.nvim",
  },
  config = function()

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("g.", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
        map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
        map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("gs", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
        map("gS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
        map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
        end,
      })

    end,
  }
