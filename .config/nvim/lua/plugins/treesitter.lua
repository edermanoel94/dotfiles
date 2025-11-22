return { 
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "go",
      "gowork",
      "gomod",
      "gosum",
      "gotmpl",
      "sql",
      "comment",
      "diff",
      "html",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "vim",
      "vimdoc",
      "json",
    },
    auto_install = true,
    sync_install = false,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true
    },
  },
}
