# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for a Linux/macOS development environment. Primary editor is Neovim with Lua configuration; also includes configs for Vim, IdeaVim, tmux, zsh, i3, and Alacritty.

## Structure

- `.config/nvim/` - Neovim configuration (Lua-based with lazy.nvim)
  - `init.lua` - Bootstrap lazy.nvim, load options, set colorscheme
  - `lua/options.lua` - Vim options and global keymaps
  - `lua/plugins/` - Individual plugin specs (one file per plugin)
- `.vimrc` - Legacy Vim config with vim-plug
- `.ideavimrc` - JetBrains IDE vim bindings
- `.tmux.conf` - Tmux with prefix `Ctrl+a`, vim-style navigation
- `.zshrc` - Oh-my-zsh with cloud theme
- `.config/i3/` - i3 window manager (Linux)
- `.aerospace.toml` - AeroSpace tiling WM (macOS)

## Key Conventions

**Leader Key:** Space (`<space>`) across all editors

**Default indent:** 2 spaces (Go overrides to tabs, 4-width via FileType autocmd)

**Neovim Keybindings:**
- `<leader>w` / `<leader>Q` - Save / Quit
- `<leader>e` - Toggle file tree, `<leader>E` - Find file in tree
- `<leader>f` - Format buffer
- `<leader>a` / `<leader>o` - Close / Open quickfix list
- LSP: `gd` (definition), `gD` (declaration), `gr` (references), `gi` (implementation), `gt` (type def), `gs` (doc symbols), `gS` (workspace symbols), `g.` (code action), `<leader>rn` (rename)
- LSP hover: `<C-k>` in insert mode
- Telescope: `<leader>sf` (files), `<leader>sg` (grep), `<leader>sb` (buffers)
- Testing: `t<C-n>` (nearest), `t<C-f>` (file), `d<C-n>` (debug nearest)
- Terminal windows: `<C-h/j/k/l>` to navigate splits from terminal mode

**nvim-cmp completion:** `<C-p>`/`<C-n>` select, `<CR>` confirm, `<Tab>`/`<S-Tab>` navigate/expand snippets

**Claude Code integration (`claudecode.nvim`):**
- `<leader>ac` - Toggle Claude, `<leader>af` - Focus, `<leader>ar` - Resume, `<leader>aC` - Continue
- `<leader>ab` - Add current buffer, `<leader>as` (visual) - Send selection
- `<leader>aa` / `<leader>ad` - Accept / Deny diff

**Go-specific (FileType autocmd):**
- Uses tabs (4-width), not spaces
- `<leader>b` - Create delve breakpoint (copies `b file:line` to clipboard)
- `<leader>c` - Toggle coverage
- `:A` / `:AV` - Alternate file (test ↔ implementation)
- `<leader>fs` - Fill struct, `<leader>ta` - Add tags, `<leader>fp` - Fix plurals

**Tmux:** Prefix is `Ctrl+a`, pane navigation with `hjkl`, `|` and `-` for splits

## Plugin Management

Neovim uses lazy.nvim with automatic bootstrap. Plugins are defined as individual Lua files in `lua/plugins/`. LSP servers are managed by mason.nvim (gopls, lua_ls, rust_analyzer, zls auto-installed). Completion via nvim-cmp + LuaSnip + lspkind.

Notable plugins: `claudecode.nvim` (Claude AI), `nvim-tree` (file explorer), `telescope` (fuzzy finder), `conform.nvim` (formatting), `vim-test` + nvim-dap (testing/debugging), `trouble.nvim` (diagnostics), `gitsigns` (git), `go.nvim` (Go extras).

## Formatting

Conform.nvim handles formatting per filetype: gofumpt (Go), stylua (Lua), prettier (JS/TS/JSON), rustfmt (Rust), zigfmt (Zig), clang-format (C/C++).

## Theme

Gruvbox dark is the primary colorscheme. Font: JetBrainsMono Nerd Font.

## Zsh

Oh-my-zsh with `cloud` theme. Aliases in `.zsh_aliases`: `lg` (lazygit), `c` (clear), `e` (exit), `ports` (list listening ports), `cheat <topic>` (cheat.sh lookup).